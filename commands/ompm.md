---
description: Oh-My-PM 产品管理工作流命名空间
category: product-management
argument-hint: "<workflow> [args...] | help | ?"
---

# Oh-My-PM Workflow Dispatcher

Product management workflow namespace for oh-my-pm.

## Your Input

$ARGUMENTS

## Help Detection

**If first argument is "help" or "?", display the following help:**

---

# Oh-My-PM Commands Help

## Available Workflows

| Command | Description | Usage Example |
|:--------|:-------------|:--------------|
| `quick-prd` | PRD with competitive analysis | `/ompm quick-prd "用户改版" 淘宝 京东` |
| `full-pm-cycle` | Complete product lifecycle (0-1) | `/ompm full-pm-cycle "新项目管理工具"` |
| `feature-launch` | Feature launch coordination | `/ompm feature-launch "注册流程"` |

## Direct Commands (without /ompm prefix)

| Command | Description |
|:--------|:-------------|
| `/quick-prd` | Same as `/ompm quick-prd` |
| `/full-pm-cycle` | Same as `/ompm full-pm-cycle` |
| `/feature-launch` | Same as `/ompm feature-launch` |

## Standalone Skills

以下 skill 可独立使用，无需工作流编排：

| Skill | Layer | 说明 |
|:------|:------|:-----|
| `competitive-analysis` | 感知 | 竞品功能对比分析 |
| `market-intelligence` | 感知 | 市场趋势与行业报告 |
| `user-research` | 感知 | 用户研究与画像 |
| `data-monitoring` | 感知 | 指标监控与异常检测 |
| `clarify-requirements` | 感知 | 需求澄清与信息收集 |
| `product-positioning` | 策略 | 产品定位与价值主张 |
| `roadmap-planning` | 策略 | 路线图规划 |
| `prioritization` | 策略 | 优先级排序 |
| `prd-gen` | 设计 | PRD 生成 |
| `prototype-design` | 设计 | 原型设计 |
| `process-optimization` | 设计 | 流程优化 |
| `requirement-review` | 交付 | 需求评审 |
| `project-coordination` | 交付 | 项目协调 |
| `release-management` | 交付 | 发布管理 |
| `impact-analysis` | 验证 | 效果分析 |
| `feedback-synthesis` | 验证 | 反馈综合 |
| `iteration-planning` | 验证 | 迭代规划 |

使用示例：直接描述需求，如 "帮我分析竞品"、"为 X 写 PRD"。

## Help

- `/ompm help` - Show this help message
- `/ompm ?` - Show this help message

---

## Dispatch (for non-help arguments)

First argument = workflow name, remaining = workflow arguments.
