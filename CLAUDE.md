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
├── agents/                      # Subagent 定义 (8 个)
│   ├── perception/              # 市场研究、竞品分析、用户研究、数据监控
│   ├── design/                  # 流程优化
│   ├── validation/              # 效果分析、反馈汇总
│   └── workflows/               # PM 编排器
├── commands/                    # CLI 命令定义 (4 个)
│   ├── quick-prd.md
│   ├── full-pm-cycle.md
│   ├── feature-launch.md
│   └── ompm.md
├── context/                     # 上下文传递目录
│   ├── current-workflow.json
│   ├── market-analysis.json
│   └── prd-draft.md
├── docs/                        # 设计文档
│   └── brainstorming/产品经理 AI Agent 工作流系统设计方案.md
└── CLAUDE.md                    # 本文件
```

## Commands (CLI 命令)

4 个工作流命令可直接调用：

| 命令 | 功能 | 示例 |
|:-----|:-----|:-----|
| `/quick-prd` | 快速生成带竞品分析的 PRD | `/quick-prd "用户中心改版" 淘宝 京东` |
| `/full-pm-cycle` | 完整产品管理周期 (0-1 产品) | `/full-pm-cycle "新项目管理工具"` |
| `/feature-launch` | 功能发布工作流 | `/feature-launch "用户注册流程"` |
| `/ompm` | 命名空间分发器 | `/ompm quick-prd "暗黑模式"` 或 `/ompm help` |

## Subagent 架构

系统采用 **Skills + Subagents 混合架构**：

### Skills vs Subagents

| 特性 | Skills | Subagents |
|:-----|:-------|:----------|
| 上下文 | 主对话共享 | 独立隔离 |
| 模型选择 | 继承主对话 | 可指定 (haiku/sonnet/opus) |
| 工具限制 | 无限制 | 可配置 allowlist/denylist |
| 持久记忆 | 无 | 支持跨会话知识积累 |
| 适用场景 | 提示词注入、频繁交互 | 高容量输出、需要隔离 |

### 8 个 Subagents

| Subagent | 层级 | 模型 | 功能 |
|:---------|:-----|:-----|:-----|
| `market-researcher` | Perception | haiku | 市场规模、行业趋势 |
| `competitive-analyst` | Perception | sonnet | 竞品功能对比、GitHub 代码分析 |
| `user-interviewer` | Perception | sonnet | 用户画像、访谈设计 |
| `data-monitor` | Perception | haiku | 指标监控、异常检测 |
| `process-optimizer` | Design | sonnet | 流程优化、只读分析 |
| `impact-analyst` | Validation | sonnet | 上线效果分析 |
| `feedback-collector` | Validation | haiku | 反馈汇总、主题分类 |
| `pm-orchestrator` | Workflows | inherit | 完整 PM 周期编排，支持并行执行 |

### 记忆系统

每个 Subagent 拥有独立的记忆目录 `.claude/agent-memory/<name>/`，用于跨会话积累知识。

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

## 实现状态 (v0.6.0)

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
| `prd-gen` | 0.2.1 | ✅ |
| `prototype-design` | 0.2.0 | ✅ |
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

## 测试

运行测试脚本验证 Skills 基本结构：

```bash
bash tests/test-skills.sh
```

测试验证：
- SKILL.md 文件存在
- YAML frontmatter 格式正确
- 必需字段 (name, description) 完整

手动测试示例：
- "分析一下淘宝和京东的个人中心功能" → 触发 `competitive-analysis`
- "写一个暗色主题功能的 PRD" → 触发 `prd-gen`
- "快速 PRD：用户中心改版，对比淘宝和京东" → 触发 `/quick-prd` 命令
