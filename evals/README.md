# Oh-My-PM 行为评测（evals）

`tests/test-skills.sh` 做的是**结构校验**（frontmatter 字段、name↔目录一致、契约文件名），
无法发现 skill 的**行为退化**——例如 prd-gen 不再先澄清场景、quick-prd 的 S2.5 硬门控被绕过。
本目录的 evals 用**真实模型调用**验证 skill 行为：让 CLI 阅读某个 `skills/<skill>/SKILL.md`
（command 用例则阅读 `commands/<name>.md`，如 ompm）并处理一条模拟用户请求，然后对输出做字符串断言。

## 用法

```bash
# 运行全部用例
bash evals/run-evals.sh

# 只运行某个 skill 目录下的用例
bash evals/run-evals.sh prd-gen

# 自检：只解析用例并打印字段，不调用模型（零成本）
bash evals/run-evals.sh --check

# 换用 codex 执行（默认 claude -p）
EVAL_CLI=codex bash evals/run-evals.sh

# 调整单案超时（默认 300 秒）
EVAL_TIMEOUT=600 bash evals/run-evals.sh
```

每案打印 PASS/FAIL 及失败原因（缺哪个断言串），结尾汇总；有失败则退出码非零。
模型原始输出留存在 `evals/.results/`（已 gitignore），失败时可直接查看。

## 成本提示

**每个用例 = 1 次模型调用**；首批 14 案全量运行约 14 次调用。
省钱建议：

- 改动某个 skill 后只跑该 skill：`bash evals/run-evals.sh <skill-name>`
- 新增/修改用例后先 `bash evals/run-evals.sh --check` 预检格式，确认无误再真跑
- 超时已设为 300s，模型行为异常时会提前失败，不会空转

## 用例格式（`evals/cases/<skill>/<case>.yaml`）

每案一个文件，YAML 子集（无需 yq，运行器内置 awk 解析器）：

```yaml
# 注释以 # 开头，可放在任何节之外
name: 用例名
prompt: |
  模拟用户的输入，可多行（块标量，缩进两个空格）。
  也支持单行写法：prompt: 帮我写个 PRD
assert_must_contain:        # 输出必须全部包含（大小写不敏感，grep -iF）
  - 字符串1
  - 字符串2
assert_must_contain_any:    # 可选：输出至少包含其一（用于同义措辞容差）
  - 确认
  - 批准
assert_must_not_contain:    # 可选：输出不得包含任何一个
  - 修订记录
```

约定：

- 顶层键必须从第 0 列开始；`prompt` 用 `|` 块标量；列表项为 `  - 字符串`
- 断言串若被成对的单/双引号包围，解析器会自动去掉引号
- 目录名必须等于被测 skill 名（运行器用它定位 `skills/<skill>/SKILL.md`）；
  被测对象是 command 时（如 ompm），目录名等于 command 名，运行器回退定位 `commands/<name>.md`

## 断言设计原则

- **只断言"必然出现"的内容**：优先选 SKILL.md 中的固定措辞（章节标题、阶段名、
  文件名、选项词），不断言模型的自由发挥，避免措辞差异导致的抖动
- **对抗案配双保险**：`assert_must_contain_any` 覆盖多种合规行为表述，
  `assert_must_not_contain` 用"只有违规才会出现"的串（如 PRD 正文的「修订记录」）
  检测模型是否突破门控
- **中英文容差**：英文阶段名用 `assert_must_contain`（grep -i 不区分大小写），
  中英文同义表述用 `assert_must_contain_any`

## 如何新增用例

1. 在 `evals/cases/<skill>/` 下新建 `<case>.yaml`，按上面的格式填写
2. 运行 `bash evals/run-evals.sh --check` 确认解析出的字段符合预期
3. 运行 `bash evals/run-evals.sh <skill>` 实测一次；若因断言过严抖动失败，
   放宽断言串（换固定措辞、改用 any），而不是放宽 skill 行为要求

## 运行机制与隔离

运行器对每个用例拼接如下提示词，再调用 CLI：

> 阅读 \<仓库绝对路径\>/skills/\<skill\>/SKILL.md（command 用例为 .../commands/\<name\>.md）
> 并严格遵循它处理以下用户请求。
> 不要写任何文件，直接在回复中输出你的处理过程和结果。用户请求：\<prompt\>

- **claude**：`claude -p "<提示词>"`，在 `mktemp -d` 临时目录中执行，并附加
  `--setting-sources user`（跳过项目/本地 settings）、`--strict-mcp-config`（不加载 MCP）、
  `--disable-slash-commands`（不注入已安装的本插件 skills）、`--no-session-persistence`、
  `--add-dir <仓库>/skills` 与 `--allowedTools Read`（只允许读 SKILL.md）。
  这样模型只能依据提示词指向的 SKILL.md 行事，不受仓库项目配置干扰
- **codex**（`EVAL_CLI=codex`）：`codex exec --skip-git-repo-check --sandbox read-only
  --ephemeral`，同样在临时目录执行，read-only 沙箱保证不落盘
- 单案调用经 `timeout`/`gtimeout` 包裹（`EVAL_TIMEOUT`，默认 300s），超时判 FAIL

## 与 tests/test-skills.sh 的关系

| | tests/test-skills.sh | evals/run-evals.sh |
|:--|:--|:--|
| 验证对象 | skill 文件**结构**（frontmatter、目录、契约） | skill 提示词**行为**（门控、阶段编排、澄清习惯） |
| 是否调用模型 | 否 | 是（每案 1 次） |
| 运行成本 | 秒级、零成本 | 分钟级、消耗模型额度 |
| 适用场景 | 每次提交前 / CI | 修改 skill 提示词后、发版前 |

两者互补：结构测试保证"文件没坏"，行为评测保证"提示词还管用"。
