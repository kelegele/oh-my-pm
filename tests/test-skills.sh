#!/bin/bash
# Oh-My-PM Skills Test Runner
# 验证全部 Skills 的结构、frontmatter 完整性与 context 传递契约一致性

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$PROJECT_ROOT/skills"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# 合法的 layer 值
VALID_LAYERS=" perception strategy design delivery validation workflow "

# 已废弃的 context 文件名——出现即判 FAIL，防止契约回归
# （统一为扁平 .ompm/<name>.json 后，这些旧名不应再被任何 skill/doc 引用）
FORBIDDEN_CONTEXT_NAMES=(
    "personas.json"
    "user-personas.json"
    "market-data.json"
    "market_data.json"
    "impact.json"
    "feedback.json"
    "workflow_tracking.json"
)

# 从 SKILL.md frontmatter 提取单行字段值（存在性 + 非空校验）
get_field() {
    # $1 = file, $2 = field name (匹配行首 "field:")
    awk -v field="^$2:" '
        /^---$/ { fm = !fm; next }
        fm && $0 ~ field { sub(field, ""); gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }
    ' "$1"
}

test_skill_file() {
    local skill_file="$1"
    local skill_name=$(basename "$(dirname "$skill_file")")

    echo -n "Testing $skill_name... "

    if [ ! -f "$skill_file" ]; then
        echo -e "${RED}FAILED${NC} - File not found"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # frontmatter 起始边界
    if [ "$(head -1 "$skill_file")" != "---" ]; then
        echo -e "${RED}FAILED${NC} - Missing YAML frontmatter opening '---'"
        FAILED=$((FAILED + 1))
        return 1
    fi

    local name desc layer version
    name=$(get_field "$skill_file" "name")
    desc=$(get_field "$skill_file" "description")
    layer=$(get_field "$skill_file" "layer")
    version=$(get_field "$skill_file" "version")

    local errs=""
    [ -z "$name" ] && errs="$errs name"
    [ -z "$desc" ] && errs="$errs description"
    [ -z "$layer" ] && errs="$errs layer"
    [ -z "$version" ] && errs="$errs version"
    if [ -n "$errs" ]; then
        echo -e "${RED}FAILED${NC} - Missing/empty field(s):$errs"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # name 必须与目录名一致
    if [ "$name" != "$skill_name" ]; then
        echo -e "${RED}FAILED${NC} - name '$name' != dir '$skill_name'"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # layer 必须在合法集合内
    if ! echo "$VALID_LAYERS" | grep -q " $layer "; then
        echo -e "${RED}FAILED${NC} - invalid layer '$layer'"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # version 形如 x.y.z
    if ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        echo -e "${RED}FAILED${NC} - version '$version' not semver x.y.z"
        FAILED=$((FAILED + 1))
        return 1
    fi

    echo -e "${GREEN}PASSED${NC}"
    PASSED=$((PASSED + 1))
    return 0
}

test_context_contract() {
    echo "Testing context-passing contract..."
    local contract_failed=0

    # 扫描可执行契约面：skills + .claude-plugin 清单
    # （docs/AGENTS/README 可能在 changelog 中合法提及旧文件名，故不扫描）
    local scan_paths=(
        "$SKILLS_DIR"
        "$PROJECT_ROOT/.claude-plugin"
    )

    for name in "${FORBIDDEN_CONTEXT_NAMES[@]}"; do
        local hits
        hits=$(grep -rlF "$name" "${scan_paths[@]}" 2>/dev/null || true)
        if [ -n "$hits" ]; then
            echo -e "${RED}FAILED${NC} - forbidden context name '$name' found in:"
            echo "$hits" | sed 's/^/    /'
            contract_failed=1
        fi
    done

    if [ $contract_failed -eq 0 ]; then
        echo -e "${GREEN}OK${NC} - no forbidden context filenames"
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
}

# 测试全部 Skills
echo "======================================"
echo "Oh-My-PM Skills Test"
echo "======================================"
echo ""

# 自动发现 skills/*/SKILL.md
shopt -s nullglob
skill_files=("$SKILLS_DIR"/*/SKILL.md)
shopt -u nullglob

echo "Discovered ${#skill_files[@]} skills"
echo ""

if [ "${#skill_files[@]}" -eq 0 ]; then
    echo -e "${RED}FAILED${NC} - no skills discovered under $SKILLS_DIR"
    exit 1
fi

for f in "${skill_files[@]}"; do
    test_skill_file "$f"
done

echo ""
test_context_contract

echo ""
echo "======================================"
echo "Test Results"
echo "======================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
