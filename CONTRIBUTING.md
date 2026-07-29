# 贡献指南

感谢你考虑为 Oh-My-PM 做贡献！

## 项目概述

Oh-My-PM 是面向产品经理的 AI Agent 工作流系统，以跨 Agent 的 Skills 插件形式分发（`npx skills add` 安装到 Claude Code / Codex / Cursor 等 70+ agent；Claude Code marketplace 插件额外提供 subagent 与命令增强）。通过三层主线（感知→策略→设计）+ 验证辅助和专业化 Skills，实现产品管理任务的自动化。

## 如何贡献

### 报告问题

使用 GitHub Issues 报告 bug 或请求功能：
- Bug Report: 使用 `[BUG]` 模板
- Feature Request: 使用 `[FEAT]` 模板
- Skill Improvement: 使用 `[IMPROVE]` 模板

### 提交代码

#### 1. Fork 并克隆

```bash
git clone https://github.com/your-username/oh-my-pm.git
cd oh-my-pm
```

#### 2. 创建分支

```bash
git checkout -b feat/skill-name
# 或
git checkout -b fix/issue-description
```

#### 3. 新增 Skill

在 `skills/` 下创建 SKILL.md，layer 信息在 frontmatter 中声明：

```
skills/                        # Flat structure, layer info in SKILL.md frontmatter
├── clarify-requirements/      # layer: perception
├── competitive-analysis/      # layer: perception
├── market-research/           # layer: perception
├── product-strategy/          # layer: strategy
├── prd-gen/                   # layer: design
├── prototype-design/          # layer: design
├── feedback-synthesis/        # layer: validation
├── retrospective/             # layer: validation
├── ompm/                      # layer: workflow（全局意图路由）
├── quick-prd/                 # layer: workflow
├── full-pm-cycle/             # layer: workflow
└── feature-launch/            # layer: workflow
```

#### 4. SKILL.md 模板

```markdown
---
name: skill-name
description: 简洁描述（使用 skill-creator 的 pushy 描述原则）
layer: design
input-from: competitive-analysis
output-to: prd-gen
---

# Skill Name

## What This Skill Does
[描述技能功能，解释为什么需要它]

## When to Use
[列出触发场景，使用自然语言描述]

## How It Works
[步骤化说明工作流程]

## Input Parameters
[参数表格]

## Output Structure
[输出格式说明]

## Quality Standards
[质量检查清单]

## Context Integration
[读写哪些 context 文件]

## Example Usage
[使用示例]
```

#### 5. 测试 Skill

```bash
# 运行结构测试
./tests/test-skills.sh

# 手动测试触发
# 在 Claude Code 或 Codex 中使用各种输入测试 Skill 触发率
```

#### 6. 提交 PR

```bash
git add .
git commit -m "feat: add new skill for XXX"
git push origin feat/skill-name
```

## 开发规范

### Commit 规范

```
<type>: <description>

[optional body]
```

Type:
- `feat`: 新 Skill 或功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

### Skill 编写原则

参考 `.claude/skills/skill-creator/SKILL.md`：

1. **Pushy Description**: 主动告诉 Claude 何时使用
2. **Explain Why Not Must**: 解释为什么需要，而不是必须做什么
3. **Progressive Disclosure**: 从简单到详细
4. **Concrete Examples**: 提供具体输入输出示例

### Context 文件规范

机器可读上下文统一为扁平 `docs/product/.ompm/<name>.json` 模型（字段契约见 `contracts/*.schema.json`），人读文档放 `docs/product/` 旁侧：

| 文件 | 格式 | 用途 |
|:-----|:-----|:-----|
| `.ompm/competitive-analysis.json` | JSON | 竞品分析结果 |
| `.ompm/prioritization.json` | JSON | 优先级排序 |
| `.ompm/iteration-plan.json` | JSON | 迭代计划 |
| `.ompm/current-workflow.json` | JSON | 工作流状态 |
| `prd/*.md` | Markdown | PRD 文档 |

## 三层主线 + 验证辅助

| 层级 | 职责 | Skills |
|:-----|:-----|:------------|
| Perception | 需求感知 | clarify-requirements, competitive-analysis, market-research |
| Strategy | 策略规划 | product-strategy |
| Design | 方案设计 | prd-gen, prototype-design |
| Validation（辅助） | 价值验证 | feedback-synthesis, retrospective |

（交付层已于 v1.0.0 取消：PRD 预审并入 prd-gen 尾门，发布 checklist/灰度策略并入 feature-launch。）

## 测试指南

详见 `docs/guides/testing-guide.md`

### 快速测试

```bash
# 结构测试
./tests/test-skills.sh

# 行为测试（真实模型调用，可选）
bash evals/run-evals.sh [skill-name]

# 手动测试（在 Claude Code 或 Codex 中）
"分析淘宝和京东的个人中心功能"
"写一个暗色主题功能的 PRD"
"规划下个迭代"
```

## 代码审查

所有 PR 需要通过：
1. 结构测试 (`./tests/test-skills.sh`)
2. Description 触发率检查
3. 输出质量验证

## 发布流程

1. 全部检查通过：`bash tests/test-skills.sh`（15 passed）+ `bash evals/run-evals.sh --check`；改动了 skill 正文时跑对应行为 evals
2. 更新版本号：`.claude-plugin/plugin.json`（唯一版本源）+ `skills.yaml` / `agents.yaml` / `marketplace.json` 三个清单同步 + AGENTS.md 头部
3. 更新 CHANGELOG.md
4. 提交并推送到 main
5. 打 tag：`git tag -a v<x.y.z> -m "…"` + `git push origin v<x.y.z>`
6. 发 GitHub Release：`gh release create v<x.y.z>`，notes 取自 CHANGELOG——每个版本都要有 Release

## 许可证

MIT License

## 联系方式

- Issues: [GitHub Issues](https://github.com/kelegele/oh-my-pm/issues)
- Discussions: [GitHub Discussions](https://github.com/kelegele/oh-my-pm/discussions)
