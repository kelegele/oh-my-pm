---
name: ompm
description: 'Oh-My-PM 全系统前门与全局意图路由：理解用户想做什么，路由到最合适的 skill 或 workflow 并一句话说明理由。当用户提出产品管理相关需求但不确定该用哪个能力时使用；也覆盖广义入口请求，如"产品经理工作入口"、"下一步该做什么"、"帮我规划产品工作"、"我要写 PRD"、"分析竞品"、"复盘"等。 Also triggers on: PM work entry point, what should I do next, help me plan product work, route my PM request.'
layer: workflow
input-from: user
output-to: clarify-requirements,competitive-analysis,market-research,product-strategy,prd-gen,prototype-design,feedback-synthesis,retrospective,quick-prd,full-pm-cycle,feature-launch
---

# OMPM 意图路由（全局前门）

Oh-My-PM 的全局入口：理解你想做什么，路由到最合适的 skill 或 workflow。

本 skill 是意图路由逻辑的唯一权威；Claude Code 的 `/ompm` 命令（`commands/ompm.md`）只是激活本 skill 的 shim。

## 路由判定

按以下优先级处理输入：

### 1. Help Detection

**如果输入是 `help` 或 `?`，输出下方「能力图」，然后结束。**

### 2. Workflow 直派（兼容用法）

如果输入的第一个词是 workflow 名（`quick-prd` / `full-pm-cycle` / `feature-launch`），将剩余内容原样传给该 workflow 执行。

| 用法 | 示例 |
|:-----|:-----|
| `quick-prd "功能描述" [竞品...]` | `ompm quick-prd "用户改版" 淘宝 京东` |
| `full-pm-cycle "产品名" [type]` | `ompm full-pm-cycle "新项目管理工具"` |
| `feature-launch "功能名" [日期]` | `ompm feature-launch "注册流程" 2026-05-01` |

在 Claude Code 中以上用法对应 `/ompm <workflow> ...`；直接命令（不带 `/ompm` 前缀）等效：`/quick-prd`、`/full-pm-cycle`、`/feature-launch`。

### 3. 意图路由（无参或自然语言输入）

无输入、或输入是一段自然语言需求描述时，执行意图路由：

**Step 1 — 读取上下文**：
- 当前对话上下文（用户刚才在讨论什么、已经做过什么）
- `docs/product/.ompm/current-workflow.json`（如存在）— 进行中工作流的阶段与状态
- `docs/product/` 下已有产物（PRD、定位、竞品分析、发布计划等，确认存在性即可）

**Step 2 — 判断"当前最有价值的下一步"**：
- 有进行中的工作流 → 继续该工作流的下一阶段（按 `current_stage` 推断）
- 需求描述模糊、关键信息缺失 → 先 `clarify-requirements`
- 已有竞品/市场研究但无策略 → `product-strategy`
- 已有 PRD 但尚未发布 → `feature-launch`
- 明确要 PRD → 要竞品上下文用 `quick-prd`，直接写用 `prd-gen`
- 上线后话题（数据、反馈、下一步做什么） → `retrospective` / `feedback-synthesis`
- 都不匹配 → 按下方能力图给出 2-3 个候选，让用户选择

**Step 3 — 路由并用一句话说明理由**，然后激活对应 skill / workflow。例如：

> 你已有竞品分析和定位文档，但还没有 PRD —— 最有价值的下一步是生成 PRD，启动 `quick-prd`。

---

## 能力图（Help 输出）

按你的目标选择入口；skill 均支持自然语言直接触发（如"帮我分析竞品"）。

### 我要写 PRD

| 场景 | 入口 |
|:-----|:-----|
| 快速 PRD + 竞品对比 | `quick-prd "功能描述" [竞品...]` |
| 直接生成 PRD（上下文已齐） | `prd-gen` skill |
| 需求还说不清，先梳理 | `clarify-requirements` skill |

### 我要了解竞品 / 市场 / 用户

| 场景 | 入口 |
|:-----|:-----|
| 竞品功能对比、差异化机会 | `competitive-analysis` skill |
| 市场趋势、行业报告、用户研究 | `market-research` skill |

### 我要定策略

| 场景 | 入口 |
|:-----|:-----|
| 定位、价值主张、优先级、路线图 | `product-strategy` skill |

### 我要做原型

| 场景 | 入口 |
|:-----|:-----|
| HTML 交互原型验证设计 | `prototype-design` skill |

### 我要规划 0-1 产品

| 场景 | 入口 |
|:-----|:-----|
| 完整 PM 周期（研究→策略→PRD→发布→复盘） | `full-pm-cycle "产品名"` |

### 我要发版

| 场景 | 入口 |
|:-----|:-----|
| 从 PRD 到上线的发布协调 | `feature-launch "功能名"` |

### 我要复盘

| 场景 | 入口 |
|:-----|:-----|
| 上线效果分析 + 下轮迭代计划 | `retrospective` skill |
| 汇总多渠道用户反馈 | `feedback-synthesis` skill |
