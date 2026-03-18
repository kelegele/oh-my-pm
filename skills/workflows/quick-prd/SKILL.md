---
name: quick-prd
description: 在一个工作流中生成包含竞品分析的完整 PRD。当用户需要带竞品上下文的 PRD、想要快速记录功能、说"写一个带竞品对比的 PRD"、或需要综合的产品需求文档时使用。当用户提到创建 PRD 并附带竞品研究，或说"分析竞品并写需求"、"快速为 X 写 PRD"时激活。支持 HTML 原型和 Pencil 设计稿两种输出格式。
layer: workflow
input-from: user
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.8.0
---

# Quick PRD Workflow

Generate a complete PRD with competitive analysis in one workflow. Supports **HTML 原型**和 **Pencil 设计稿**两种输出格式。

## What This Workflow Does

Orchestrates multiple skills to produce a complete PRD with competitive context. First analyzes competitors (if provided), then generates PRD incorporating those insights. Finally, creates prototype in user-selected format (HTML/Pencil/Both).

## Workflow Architecture

本工作流采用 **Plan-and-Execute 模式**组织，确保完整的阶段定义、状态追踪和质量门控。

### 五层对应阶段

| Stage ID | 名称 | 对应层 | 说明 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | 初始化 | 创建工作流状态文件 |
| S1 | Perception | 需求感知 | 市场研究、用户画像、竞品分析 |
| S2 | Strategy | 策略规划 | 产品定位、路线图规划、优先级排序 |
| S3 | Design | 方案设计 | PRD 生成、原型设计 |
| S4 | Delivery | 交付协调 | 需求评审、项目计划、发布管理 |
| S5 | Validation | 价值验证 | 效果分析、反馈综合、迭代规划 |

---

## Workflow Stages

| Stage ID | 名称 | 质量门控 | 下阶段 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | - | S1 | Perception |
| S1 | Perception | 市场研究完成 | S2 | Strategy |
| S2 | Strategy | 定位完成 | S3 | Design |
| S3 | Design | PRD 完整 | S4 | Delivery |
| S3 | Design | 原型验证 | S5 | Validation |
| S4 | Delivery | 需求评审 | S5 | Validation |

**阶段执行顺序**：S0 → S1 → S2 → S3 → S4 → S5

---

## Stage 0: Setup

**目标**：初始化工作流状态和上下文目录

**活动**：
- 创建 `context/workflow-state/` 目录用于工作流快照
- 初始化 `context/current-workflow.json` 当前状态文件

**输出**：
- `context/workflow-state/` 目录
- `context/current-workflow.json` 空模板

**质量门控**：
- ✅ 目录结构创建完成
- ✅ 状态模板初始化完成

---

## Stage 1: Perception

**目标**：完成需求感知层的数据收集和分析

**活动**：
1. 竞品分析 - `competitive-analysis` skill
2. 市场研究 - `market-intelligence` skill
3. 用户研究 - `user-research` skill

**技能调用**：
- Step 1.1: 调用 `/competitive-analysis`
- Step 1.2: 调用 `/market-intelligence`
- Step 1.3: 调用 `/user-research`

**输出**：
- `context/competitive-analysis/{feature-name}-{date}.json` + `.md`
- `context/market-analysis.json`
- `context/user-research.json`
- `context/user-personas.json`

**质量门控**：
- ✅ 竞品分析完成 - 2+ 个竞品功能对比
- ✅ 市场研究完成 - 市场规模、趋势、机会点
- ✅ 用户画像完成 - 2+ 个用户角色定义
- **质量门控通过** - 进入 Strategy 阶段

**状态更新**：
```json
{
  "workflow_id": "wf-{{timestamp}}",
  "workflow_name": "quick-prd",
  "status": "in_progress",
  "current_layer": "perception",
  "current_skill": "competitive-analysis",
  "current_stage": "S1",
  "completed_stages": ["S0"],
  "mode": "copilot"
  "started_at": "{{ISO_8601}}",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 2: Strategy

**目标**：完成策略规划层的工作

**活动**：
1. 产品定位 - `product-positioning` skill
2. 路线图规划 - `roadmap-planning` skill
3. 优先级排序 - `prioritization` skill

**技能调用**：
- Step 2.1: 调用 `/product-positioning`
- Step 2.2: 调用 `/roadmap-planning`
- Step 2.3: 调用 `/prioritization`

**输出**：
- `context/positioning.md`
- `context/roadmap.md`
- `context/prioritization.json`

**质量门控**：
- ✅ 产品定位完成 - 价值主张清晰、差异化策略明确
- ✅ 路线图完成 - 12 个月里程碑规划
- ✅ 优先级排序完成 - RICE/MoSCoW 框架应用
- **质量门控通过** - 进入 Design 阶段

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1"],
  "current_layer": "strategy",
  "current_skill": "prioritization",
  "current_stage": "S2",
  "status": "in_progress",
  "mode": "copilot",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 3: Design

**目标**：完成方案设计层的 PRD 生成和原型创建

**活动**：
1. PRD 生成 - `prd-gen` skill
2. 原型设计 - `prototype-design` skill（HTML/Pencil/Both）

**技能调用**：
- Step 3.1: 调用 `/prd-gen`
- Step 3.2: 调用 `/prototype-design`

**输出**：
- `context/prd/{feature-name}-{date}-v{version}.md`
- `context/prototypes/{feature-name}.html`（如选择）
- `context/prototypes/{feature-name}.pen`（如选择）
- `context/prototypes/{feature-name}-preview.png`（Pencil 预览图）

**原型格式选择**：

在 PRD 生成后，询问用户选择原型输出格式：

| Option | Description | 输出位置 |
|:-------|-------------|:-----------|
| **HTML 原型** | 可在浏览器直接预览、演示交互 | `context/prototypes/{name}.html` |
| **Pencil 设计稿** | 结构化设计数据、专业设计工具、可导出代码 | `context/prototypes/{name}.pen` |
| **两者都生成** | 同时生成 HTML 和 Pencil 两种格式 | 两者 |

**质量门控**：
- ✅ PRD 完整（9 章节 + 行业基准）
- ✅ 原型已创建（HTML 或 Pencil）
- ✅ **Pencil 格式：文件包含 version 和 children 字段**
- ✅ **Pencil 格式：生成预览截图**
- ✅ **Pencil 格式：可在 Pencil 应用中打开**
- **质量门控通过** - 进入 Delivery 阶段

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1", "S2"],
  "current_layer": "design",
  "current_skill": "prototype-design",
  "current_stage": "S3",
  "status": "in_progress",
  "mode": "copilot",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 4: Delivery

**目标**：完成交付协调层的工作

**活动**：
1. 需求评审 - `requirement-review` skill
2. 项目计划 - `project-coordination` skill
3. 发布管理 - `release-management` skill

**技能调用**：
- Step 4.1: 调用 `/requirement-review`
- Step 4.2: 调用 `/project-coordination`
- Step 4.3: 调用 `/release-management`

**输出**：
- `context/review-notes/[feature]-review.md`
- `context/project-plan.md`
- `context/release-plan.md`

**质量门控**：
- ✅ 需求评审完成 - 干系人对齐、签字确认
- ✅ 项目计划完成 - 任务分配、时间线确认
- ✅ 发布准备完成 - 代码冻结、发布包就绪
- **质量门控通过** - 进入 Validation 阶段

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1", "S2", "S3"],
  "current_layer": "delivery",
  "current_skill": "release-management",
  "current_stage": "S4",
  "status": "in_progress",
  "mode": "copilot",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 5: Validation

**目标**：完成价值验证层的数据收集和分析

**活动**：
1. 效果分析 - `impact-analysis` skill
2. 反馈综合 - `feedback-synthesis` skill
3. 迭代规划 - `iteration-planning` skill

**技能调用**：
- Step 5.1: 调用 `/impact-analysis`
- Step 5.2: 调用 `/feedback-synthesis`
- Step 5.3: 调用 `/iteration-planning`

**输出**：
- `context/impact-analysis/{feature-name}-{date}.json`
- `context/feedback-synthesis/{feature-name}-{date}.json`
- `context/iteration-plan.json`

**质量门控**：
- ✅ 效果分析完成 - 目标达成度分析、关键指标收集
- ✅ 反馈综合完成 - 用户反馈收集、主题分析、改进建议
- ✅ 迭代规划完成 - 下一轮迭代计划制定
- **工作流完成** - 全部 5 个阶段完成

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1", "S2", "S3", "S4"],
  "current_layer": "validation",
  "current_skill": "iteration-planning",
  "current_stage": "S5",
  "status": "completed",
  "mode": "copilot",
  "updated_at": "{{ISO_8601}}"
}
```

---

## 工作流状态管理

### 状态字段

```json
{
  "workflow_id": "唯一的工作流ID",
  "workflow_name": "工作流名称",
  "status": "in_progress | completed | blocked",
  "current_layer": "perception | strategy | design | delivery | validation",
  "current_skill": "当前执行的 Skill",
  "current_stage": "当前阶段 (S0-S5)",
  "completed_stages": "已完成的阶段列表",
  "mode": "协作模式 (autopilot | copilot | manual)",
  "started_at": "ISO 8601 时间戳",
  "updated_at": "最后更新时间 (ISO 8601)"
}
```

---

## 协作模式 (Collaboration Modes)

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:---------|
| `autopilot` | AI 自动执行 | 快速验证、演示、数据监控 |
| `copilot` | AI 建议、人工确认 | PRD 生成、需求评审、项目计划 |
| `manual` | 人工主导、AI 辅助 | 战略决策、创意发散、危机处理 |

---

## 质量门控 (Quality Gates)

每个阶段完成后必须满足对应的质量标准才能进入下一阶段：

### Perception 层质量门控

```yaml
perception_gates:
  S1_to_S2:
    - market_research_complete:
        - 市场研究完成
        - 竞品列表确定
        - 关键玩家识别
    - user_research_complete:
        - 用户访谈完成
        - 用户画像创建
        - 痛点识别
    - competitive_analysis_complete:
        - 竞品分析完成
        - 功能对比矩阵
        - 差异化识别
```

### Strategy 层质量门控

```yaml
strategy_gates:
  S2_to_S3:
    - positioning_complete:
        - 定位声明创建
        - 价值主张明确
        - 差异化策略制定
    - roadmap_complete:
        - 里程碑规划完成
        - 时间线设定
    - prioritization_complete:
        - RICE 评分完成
        - 优先级列表确定
```

### Design 层质量门控

```yaml
design_gates:
  S3_to_S4:
    - prd_complete:
        - PRD 完整（9 章）
        - 用户故事映射
        - 验收标准定义
    - prototype_validated:
        - 原型已创建
        - 交互功能验证
        - 设计一致性检查
        - Pencil 格式：文件包含 version 和 children
        - Pencil 格式：可在 Pencil 应用中打开
```

### Delivery 层质量门控

```yaml
delivery_gates:
  S4_to_S5:
    - requirement_review_complete:
        - 需求评审完成
        - 干系人对齐
        - 签字确认
    - project_plan_complete:
        - 任务分配完成
        - 时间线确认
    - release_ready:
        - 代码冻结
        - 发布包就绪
```

### Validation 层质量门控

```yaml
validation_gates:
  S5_complete:
    - impact_analysis_complete:
        - 目标达成度分析
        - 关键指标收集
    - feedback_synthesis_complete:
        - 反馈收集完成
        - 主题分析完成
    - iteration_planning_complete:
        - 下一轮迭代计划制定
```

---

## 上下文集成

**读取**：
- `context/current-workflow.json` - 当前工作流状态
- `context/prd/*.md` - PRD 文档
- `context/competitive-analysis/*.json` - 竞品分析数据
- `context/prototypes/*.html` - HTML 原型
- `context/prototypes/*.pen` - Pencil 设计稿

**写入**：
- `context/workflow-state/{{workflow_id}}.json` - 工作流快照（按日期）
- `context/review-notes/*.md` - 评审记录
- `context/project-plan/*.md` - 项目计划
- `context/release-plan/*.md` - 发布计划
- `context/impact-analysis/*.json` - 效果分析
- `context/feedback-synthesis/*.json` - 反馈综合
- `context/iteration-plan.json` - 迭代计划

---

## 示例：工作流执行轨迹

```json
{
  "workflow_id": "wf-20260317-001",
  "workflow_name": "quick-prd",
  "status": "completed",
  "completed_stages": ["S0", "S1", "S2", "S3", "S4", "S5"],
  "execution_trace": [
    {
      "stage": "S1",
      "skill": "competitive-analysis",
      "started_at": "2026-03-17T10:00:00Z",
      "completed_at": "2026-03-17T10:02:00Z",
      "outputs": ["competitor-list.json"]
    },
    {
      "stage": "S2",
      "skill": "prioritization",
      "started_at": "2026-03-17T10:03:00Z",
      "completed_at": "2026-03-17T10:05:00Z",
      "outputs": ["prioritization.json"]
    },
    {
      "stage": "S3",
      "skill": "prd-gen",
      "started_at": "2026-03-17T10:06:00Z",
      "completed_at": "2026-03-17T10:08:00Z",
      "outputs": ["prd-final.md", "prototype.html"]
    },
    {
      "stage": "S4",
      "skill": "requirement-review",
      "started_at": "2026-03-17T10:10:00Z",
      "completed_at": "2026-03-17T10:15:00Z",
      "outputs": ["review-notes.md", "project-plan.md"]
    },
    {
      "stage": "S5",
      "skill": "iteration-planning",
      "started_at": "2026-03-17T10:18:00Z",
      "completed_at": "2026-03-17T10:20:00Z",
      "outputs": ["iteration-plan.json"]
    }
  ],
  "mode": "copilot",
  "started_at": "2026-03-17T10:00:00Z",
  "updated_at": "2026-03-17T10:20:00Z"
}
```
