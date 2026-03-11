# 贡献指南

感谢你考虑为 Oh-My-PM 做贡献！

## 项目概述

Oh-My-PM 是基于 Claude Code Skill 插件的产品经理 AI Agent 工作流系统。通过五层架构和专业化 Skills，实现产品管理任务的自动化。

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

在 `skills/` 下对应层级创建 SKILL.md：

```
skills/
├── perception/           # 需求感知层
├── strategy/             # 策略规划层
├── design/               # 方案设计层
├── delivery/             # 交付协调层
├── validation/           # 价值验证层
└── workflows/            # 工作流编排
```

#### 4. SKILL.md 模板

```markdown
---
name: skill-name
description: 简洁描述（使用 skill-creator 的 pushy 描述原则）
layer: design
input-from: competitive-analysis
output-to: requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.1.0
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

## Collaboration Modes
[三种模式的区别]

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
# 在 Claude Code 中使用各种输入测试 Skill 触发率
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

Context 文件存放在 `context/` 目录：

| 文件 | 格式 | 用途 |
|:-----|:-----|:-----|
| competitive-analysis.json | JSON | 竞品分析结果 |
| prd-draft.md | Markdown | PRD 文档 |
| iteration-plan.json | JSON | 迭代计划 |
| current-workflow.json | JSON | 工作流状态 |

## 三种协作模式

每个 Skill 应支持三种模式：

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:-----|
| autopilot | AI 自动执行，人工审阅 | 数据汇总、报告生成 |
| copilot | AI 建议，人工确认 | 方案设计、优先级排序 |
| manual | 人工主导，AI 辅助 | 战略决策、创意工作 |

## 五层架构

| 层级 | 职责 | 示例 Skills |
|:-----|:-----|:------------|
| Perception | 需求感知 | market-intelligence, user-research |
| Strategy | 策略规划 | product-positioning, roadmap-planning |
| Design | 方案设计 | prd-gen, prototype-design |
| Delivery | 交付协调 | requirement-review, release-management |
| Validation | 价值验证 | impact-analysis, iteration-planning |

## 测试指南

详见 `docs/testing-guide.md`

### 快速测试

```bash
# 结构测试
./tests/test-skills.sh

# 手动测试（在 Claude Code 中）
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

1. 更新版本号
2. 更新 CHANGELOG.md
3. 创建 git tag
4. 推送到 main

## 许可证

MIT License

## 联系方式

- Issues: [GitHub Issues](https://github.com/kelegele/oh-my-pm/issues)
- Discussions: [GitHub Discussions](https://github.com/kelegele/oh-my-pm/discussions)
