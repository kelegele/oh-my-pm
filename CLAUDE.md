# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Oh-My-PM 是面向产品经理的 AI Agent 工作流系统，通过 **Claude Code Skill 插件** 形式实现。

系统核心是五层工作流架构和 19 个专业化 Skill (16 层级 Skills + 3 工作流编排器)，实现产品管理任务的自动化与增强。

## 五层工作流架构

| 层级 | 名称 | Skills |
|:---|:---|:---|
| 第一层 | 需求感知层 | `market-intelligence`, `user-research`, `competitive-analysis`, `data-monitoring` |
| 第二层 | 策略规划层 | `product-positioning`, `roadmap-planning`, `prioritization` |
| 第三层 | 方案设计层 | `prd-gen`, `prototype-design`, `process-optimization` |
| 第四层 | 交付协调层 | `requirement-review`, `project-coordination`, `release-management` |
| 第五层 | 价值验证层 | `impact-analysis`, `feedback-synthesis`, `iteration-planning` |

## 目录结构

```
oh-my-pm/
├── skills/                      # Skill 插件目录
│   ├── perception/              # 需求感知层 (4)
│   │   ├── market-intelligence/SKILL.md
│   │   ├── user-research/SKILL.md
│   │   ├── competitive-analysis/SKILL.md
│   │   └── data-monitoring/SKILL.md
│   ├── strategy/                # 策略规划层 (3)
│   │   ├── product-positioning/SKILL.md
│   │   ├── roadmap-planning/SKILL.md
│   │   └── prioritization/SKILL.md
│   ├── design/                  # 方案设计层 (3)
│   │   ├── prd-gen/SKILL.md
│   │   ├── prototype-design/SKILL.md
│   │   └── process-optimization/SKILL.md
│   ├── delivery/                # 交付协调层 (3)
│   │   ├── requirement-review/SKILL.md
│   │   ├── project-coordination/SKILL.md
│   │   └── release-management/SKILL.md
│   ├── validation/              # 价值验证层 (3)
│   │   ├── impact-analysis/SKILL.md
│   │   ├── feedback-synthesis/SKILL.md
│   │   └── iteration-planning/SKILL.md
│   └── workflows/               # 工作流编排器 (3)
│       ├── full-pm-cycle/SKILL.md
│       ├── quick-prd/SKILL.md
│       └── feature-launch/SKILL.md
├── context/                     # 上下文传递目录
│   ├── current-workflow.json
│   ├── market-analysis.json
│   └── prd-draft.md
├── docs/                        # 设计文档
│   └── brainstorming/产品经理 AI Agent 工作流系统设计方案.md
└── CLAUDE.md                    # 本文件
```

## SKILL.md 模板规范

每个 Skill 必须包含 YAML frontmatter 和以下字段：

```markdown
---
name: skill-name
description: 简短描述，何时使用此 Skill
layer: design
input-from: product-positioning,prioritization
output-to: requirement-review,prototype-design
---

# Skill Name

## When to Activate
触发条件描述

## Workflow Steps
1. 步骤一
2. 步骤二
3. 步骤三

## Output Format
输出格式说明

## Quality Gate
质量检查清单
```

## 人机协作模式

| 模式 | 描述 | 适用场景 |
|:---|:---|:---|
| `autopilot` | Agent 自动执行，人工仅审阅 | 数据监控、报告生成、信息汇总 |
| `copilot` | Agent 建议，人工决策确认 | 优先级排序、方案设计、风险评估 |
| `manual` | 人工主导，Agent 辅助 | 战略决策、创意发散、危机处理 |

## 上下文传递机制

1. **隐式传递**: 工作流编排器自动维护上下文
2. **显式引用**: Skill 通过 `context/` 读取前置 Skill 输出
3. **版本控制**: 上下文支持快照，支持回溯

## 反馈闭环

`iteration-planning` Skill 读取 `impact-analysis` 和 `feedback-synthesis` 输出：
- 发现新问题 → 调用 `user-research` 更新需求池
- 验证失败 → 调用 `prd-gen` 重新设计
- 数据正常 → 标记完成，归档到知识库

## 设计原则

- **单一职责**: 每个 Skill 聚焦一个专业能力
- **可组合性**: 支持多 Skill 编排复杂工作流
- **可扩展性**: 新增 Skill 不影响现有体系
- **可评估性**: 每个 Skill 具备明确的输入输出标准

## 实现状态 (v0.2.0)

全部 19 个 Skill 已实现完成：

| Skill | 版本 | 状态 |
|:---|:---|:---|
| `market-intelligence` | 0.1.0 | ✅ |
| `user-research` | 0.1.0 | ✅ |
| `competitive-analysis` | 0.1.0 | ✅ |
| `data-monitoring` | 0.1.0 | ✅ |
| `product-positioning` | 0.1.0 | ✅ |
| `roadmap-planning` | 0.1.0 | ✅ |
| `prioritization` | 0.1.0 | ✅ |
| `prd-gen` | 0.2.0 | ✅ |
| `prototype-design` | 0.1.0 | ✅ |
| `process-optimization` | 0.1.0 | ✅ |
| `requirement-review` | 0.1.0 | ✅ |
| `project-coordination` | 0.1.0 | ✅ |
| `release-management` | 0.1.0 | ✅ |
| `impact-analysis` | 0.1.0 | ✅ |
| `feedback-synthesis` | 0.1.0 | ✅ |
| `iteration-planning` | 0.1.0 | ✅ |
| `quick-prd` (workflow) | 0.2.0 | ✅ |
| `full-pm-cycle` (workflow) | 0.1.0 | ✅ |
| `feature-launch` (workflow) | 0.1.0 | ✅ |

## 参考文档

完整设计方案: `docs/brainstorming/产品经理 AI Agent 工作流系统设计方案.md`
