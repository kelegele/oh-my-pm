#!/usr/bin/env bash
# =============================================================================
# Oh-My-PM 行为评测运行器（evals）
#
# 用法:
#   bash evals/run-evals.sh              # 运行全部用例
#   bash evals/run-evals.sh prd-gen      # 只运行指定 skill 目录下的用例
#   bash evals/run-evals.sh --check      # 只解析用例并打印字段，不调用模型
#
# 环境变量:
#   EVAL_CLI=claude|codex   评测用 CLI（默认 claude；codex 时使用 codex exec）
#   EVAL_TIMEOUT=300        单案模型调用超时秒数（默认 300）
#
# 机制:
#   对每个 evals/cases/<name>/<case>.yaml，拼接提示词让 CLI 阅读被测定义文件
#   并严格遵循它处理用例中的用户请求，然后对模型输出做 grep -iF 断言
#   （assert_must_contain 全含 / assert_must_contain_any 至少其一 /
#   assert_must_not_contain 全不含）。被测文件定位：优先
#   <仓库>/skills/<name>/SKILL.md；不存在则回退 <仓库>/commands/<name>.md
#   （ompm 等 command 由此接入评测）。
#
# 隔离:
#   在临时目录中执行 CLI，避免加载仓库项目配置（CLAUDE.md / 项目级 settings /
#   已安装的本插件 skills）对被测 SKILL.md 产生干扰。
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CASES_DIR="$SCRIPT_DIR/cases"
RESULTS_DIR="$SCRIPT_DIR/.results"

EVAL_CLI="${EVAL_CLI:-claude}"
EVAL_TIMEOUT="${EVAL_TIMEOUT:-300}"
CHECK_ONLY=0
TARGET_SKILL=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    sed -n '2,23p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

# ---- 参数解析 --------------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --check) CHECK_ONLY=1 ;;
        -h|--help) usage 0 ;;
        -*)
            echo -e "${RED}未知参数: $arg${NC}"
            usage 1
            ;;
        *)
            if [ -n "$TARGET_SKILL" ]; then
                echo -e "${RED}只支持指定一个 skill，收到多余参数: $arg${NC}"
                exit 1
            fi
            TARGET_SKILL="$arg"
            ;;
    esac
done

# ---- 用例解析器（awk 简易 YAML 子集解析，格式约定见 evals/README.md） --------
# 将每个字段写入独立文件：name / prompt / must / mustnot / any
AWK_PARSER="$(cat <<'AWK_EOF'
/^[ \t]*#/ { next }          # 注释行
/^[A-Za-z_]+:/ {             # 顶层键（第 0 列开头）
    key = $0; sub(/:.*/, "", key)
    if (key == "name") {
        line = $0; sub(/^name:[ \t]*/, "", line)
        gsub(/^["']|["']$/, "", line)
        print line > (outdir "/name")
        mode = ""; next
    }
    if (key == "prompt") {
        if ($0 ~ /\|/) { mode = "prompt"; next }   # 块标量 prompt: |
        line = $0; sub(/^prompt:[ \t]*/, "", line) # 行内单行 prompt
        gsub(/^["']|["']$/, "", line)
        print line > (outdir "/prompt")
        mode = ""; next
    }
    if (key == "assert_must_contain")     { mode = "must";    next }
    if (key == "assert_must_not_contain") { mode = "mustnot"; next }
    if (key == "assert_must_contain_any") { mode = "any";     next }
    mode = ""; next                              # 其他顶层键，忽略
}
mode == "prompt" {
    if ($0 ~ /^[ \t]/) {                         # 缩进行 = 块标量内容
        line = $0; sub(/^(  |\t| )/, "", line)   # 去掉一层缩进
        print line > (outdir "/prompt")
    } else if ($0 ~ /^[ \t]*$/) {
        print "" > (outdir "/prompt")            # 保留块内空行
    } else {
        mode = ""                                # 非缩进行，块结束
    }
    next
}
mode == "must" || mode == "mustnot" || mode == "any" {
    if ($0 ~ /^[ \t]*-[ \t]*/) {                 # 列表项 "  - 字符串"
        line = $0; sub(/^[ \t]*-[ \t]*/, "", line); sub(/[ \t]+$/, "", line)
        gsub(/^["']|["']$/, "", line)            # 去掉成对的包围引号
        f = (mode == "must") ? "must" : ((mode == "mustnot") ? "mustnot" : "any")
        print line > (outdir "/" f)
    } else if ($0 !~ /^[ \t]*$/) {
        mode = ""                                # 非列表非空行，本节结束
    }
    next
}
AWK_EOF
)"

parse_case() {
    # $1 = 用例文件  $2 = 输出目录
    awk -v outdir="$2" "$AWK_PARSER" "$1"
}

# ---- timeout 命令探测（macOS 默认无 timeout，可能只有 coreutils 的 gtimeout） --
TIMEOUT_CMD=""
if command -v timeout >/dev/null 2>&1; then
    TIMEOUT_CMD="timeout"
elif command -v gtimeout >/dev/null 2>&1; then
    TIMEOUT_CMD="gtimeout"
fi

# ---- CLI 前置检查 ------------------------------------------------------------
if [ "$CHECK_ONLY" -eq 0 ]; then
    if [ "$EVAL_CLI" != "claude" ] && [ "$EVAL_CLI" != "codex" ]; then
        echo -e "${RED}EVAL_CLI 只支持 claude 或 codex，当前值: $EVAL_CLI${NC}"
        exit 1
    fi
    if ! command -v "$EVAL_CLI" >/dev/null 2>&1; then
        echo -e "${RED}未找到 CLI: $EVAL_CLI${NC}"
        exit 1
    fi
    if [ -z "$TIMEOUT_CMD" ]; then
        echo -e "${YELLOW}警告: 未找到 timeout/gtimeout，单案调用将不设超时${NC}"
    fi
fi

# ---- 收集用例 ----------------------------------------------------------------
shopt -s nullglob
if [ -n "$TARGET_SKILL" ]; then
    case_files=("$CASES_DIR/$TARGET_SKILL"/*.yaml)
else
    case_files=("$CASES_DIR"/*/*.yaml)
fi
shopt -u nullglob

if [ "${#case_files[@]}" -eq 0 ]; then
    if [ -n "$TARGET_SKILL" ]; then
        echo -e "${RED}未找到 skill「${TARGET_SKILL}」的用例（期望: evals/cases/${TARGET_SKILL}/*.yaml）${NC}"
        echo "可用 skill 目录:"
        ls -1 "$CASES_DIR" 2>/dev/null | sed 's/^/  /'
    else
        echo -e "${RED}未发现任何用例（evals/cases/<skill>/*.yaml）${NC}"
    fi
    exit 1
fi

echo "======================================"
if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "Oh-My-PM Evals 用例自检（不调用模型）"
else
    echo "Oh-My-PM Behavior Evals (CLI: $EVAL_CLI, timeout: ${EVAL_TIMEOUT}s)"
fi
echo "======================================"
echo "发现 ${#case_files[@]} 个用例"
echo ""

# ---- 单案执行 ----------------------------------------------------------------
run_case() {
    local skill="$1" case_file="$2"
    local case_slug; case_slug="$(basename "$case_file" .yaml)"
    local label="$skill/$case_slug"
    local work; work="$(mktemp -d)"

    parse_case "$case_file" "$work"

    local name="" prompt=""
    [ -f "$work/name" ] && name="$(cat "$work/name")"
    [ -f "$work/prompt" ] && prompt="$(cat "$work/prompt")"

    local must=() mustnot=() any=() line
    if [ -f "$work/must" ]; then
        while IFS= read -r line; do [ -n "$line" ] && must+=("$line"); done < "$work/must"
    fi
    if [ -f "$work/mustnot" ]; then
        while IFS= read -r line; do [ -n "$line" ] && mustnot+=("$line"); done < "$work/mustnot"
    fi
    if [ -f "$work/any" ]; then
        while IFS= read -r line; do [ -n "$line" ] && any+=("$line"); done < "$work/any"
    fi

    if [ -z "$name" ] || [ -z "$prompt" ]; then
        echo -e "${RED}FAIL${NC} $label — 用例格式错误（缺少 name 或 prompt）"
        rm -rf "$work"
        return 1
    fi

    # 被测文件定位：优先 skills/<skill>/SKILL.md；不存在则回退 commands/<skill>.md
    local target_file=""
    if [ -f "$PROJECT_ROOT/skills/$skill/SKILL.md" ]; then
        target_file="$PROJECT_ROOT/skills/$skill/SKILL.md"
    elif [ -f "$PROJECT_ROOT/commands/$skill.md" ]; then
        target_file="$PROJECT_ROOT/commands/$skill.md"
    else
        echo -e "${RED}FAIL${NC} $label — 找不到被测文件（skills/$skill/SKILL.md 或 commands/$skill.md）"
        rm -rf "$work"
        return 1
    fi

    # --check 模式：只展示解析结果
    if [ "$CHECK_ONLY" -eq 1 ]; then
        local first_line="${prompt%%$'\n'*}"
        echo -e "${GREEN}OK${NC} $label"
        echo "      name:   $name"
        echo "      prompt: ${first_line}  (共 ${#prompt} 字符)"
        if [ "${#must[@]}" -gt 0 ]; then
            local joined; joined="$(IFS='、'; echo "${must[*]}")"
            echo "      must:     $joined"
        fi
        if [ "${#any[@]}" -gt 0 ]; then
            local joined_any; joined_any="$(IFS='、'; echo "${any[*]}")"
            echo "      any:      $joined_any"
        fi
        if [ "${#mustnot[@]}" -gt 0 ]; then
            local joined_not; joined_not="$(IFS='、'; echo "${mustnot[*]}")"
            echo "      mustnot:  $joined_not"
        fi
        rm -rf "$work"
        return 0
    fi

    # 拼接提示词：让模型阅读被测定义文件并遵循它处理用户请求，不落盘任何文件
    local full_prompt
    full_prompt="阅读 ${target_file} 并严格遵循它处理以下用户请求。不要写任何文件，直接在回复中输出你的处理过程和结果。

用户请求：
${prompt}"

    # 在临时目录运行，隔离仓库项目配置
    local run_dir; run_dir="$(mktemp -d)"
    mkdir -p "$RESULTS_DIR"
    local out="$RESULTS_DIR/${skill}__${case_slug}.out.txt"
    local err="$RESULTS_DIR/${skill}__${case_slug}.err.txt"

    local cmd=()
    if [ "$EVAL_CLI" = "codex" ]; then
        cmd=(codex exec --skip-git-repo-check --sandbox read-only --ephemeral "$full_prompt")
    else
        cmd=(claude -p "$full_prompt"
             --setting-sources user
             --strict-mcp-config
             --disable-slash-commands
             --no-session-persistence
             --add-dir "$(dirname "$target_file")"
             --allowedTools "Read")
    fi
    if [ -n "$TIMEOUT_CMD" ]; then
        cmd=("$TIMEOUT_CMD" "$EVAL_TIMEOUT" "${cmd[@]}")
    fi

    local rc=0
    ( cd "$run_dir" && "${cmd[@]}" ) >"$out" 2>"$err" || rc=$?
    rm -rf "$run_dir"

    # ---- 断言 ----
    local failed=0 reasons="" s anyok
    if [ "$rc" -ne 0 ]; then
        failed=1
        if [ "$rc" -eq 124 ]; then
            reasons="模型调用超时（${EVAL_TIMEOUT}s）"
        else
            reasons="CLI 执行失败（exit ${rc}）: $(tail -n 3 "$err" 2>/dev/null | tr '\n' ' ')"
        fi
    else
        for s in "${must[@]}"; do
            if ! grep -qiF -- "$s" "$out"; then
                failed=1; reasons="${reasons}缺少必含串「${s}」；"
            fi
        done
        if [ "${#any[@]}" -gt 0 ]; then
            anyok=0
            for s in "${any[@]}"; do
                if grep -qiF -- "$s" "$out"; then anyok=1; break; fi
            done
            if [ "$anyok" -eq 0 ]; then
                failed=1
                reasons="${reasons}以下断言需至少命中其一但均未命中（$(IFS='、'; echo "${any[*]}")）；"
            fi
        fi
        for s in "${mustnot[@]}"; do
            if grep -qiF -- "$s" "$out"; then
                failed=1; reasons="${reasons}命中禁含串「${s}」；"
            fi
        done
    fi

    rm -rf "$work"
    if [ "$failed" -eq 0 ]; then
        echo -e "${GREEN}PASS${NC} $label — $name"
        return 0
    else
        echo -e "${RED}FAIL${NC} $label — $name"
        echo -e "      原因: ${reasons}"
        echo -e "      模型输出留存: $out"
        return 1
    fi
}

# ---- 主循环 ------------------------------------------------------------------
PASSED=0
FAILED=0
FAILED_CASES=()

for f in "${case_files[@]}"; do
    skill="$(basename "$(dirname "$f")")"
    if run_case "$skill" "$f"; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
        FAILED_CASES+=("$skill/$(basename "$f" .yaml)")
    fi
done

echo ""
echo "======================================"
echo "Eval Results"
echo "======================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
if [ "${#FAILED_CASES[@]}" -gt 0 ]; then
    echo "失败用例:"
    for c in "${FAILED_CASES[@]}"; do echo "  - $c"; done
fi
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}All evals passed!${NC}"
    exit 0
else
    echo -e "${RED}Some evals failed!${NC}"
    exit 1
fi
