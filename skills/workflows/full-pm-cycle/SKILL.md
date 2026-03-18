---
name: full-pm-cycle
description: 编排从市场研究到上线后分析的完整产品管理周期。用于综合产品规划、0-1 产品开发，或当用户说"完整产品计划"、"完整 PM 周期"、"从研究到上线"时使用。支持 HTML 原型和 Pencil 设计稿两种输出格式。采用 Plan-and-Execute 模式，包含完整的阶段定义、状态追踪和质量门控。
layer: workflow
input-from: user
output-to: iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.8.0
---

# Full PM Cycle Workflow

完整的从市场研究到上线后分析的产品管理周期，采用 **Plan-and-Execute 模式**。支持 **HTML 原型**和 **Pencil 设计稿**两种输出格式。

## What This Workflow Does

Orchestrates complete product management lifecycle across all five layers:
- **Perception**: Market research, user research, competitive analysis
- **Strategy**: Positioning, roadmap, prioritization
- **Design**: PRD generation, prototype design (HTML/Pencil/Both)
- **Delivery**: Requirement review, project coordination, release management
- **Validation**: Impact analysis, feedback synthesis

---

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
| S4 | Delivery | 发布完成 | S5 | Validation |

**阶段执行顺序**：S0 → S1 → S2 → S3 → S4 → S5

---

## Stage 0: Setup

**目标**：初始化工作流状态和上下文目录

**活动**：
- 创建 `context/workflow-state/` 目录用于工作流快照
- 创建 `context/product-package/` 目录用于完整产品包
- 初始化 `context/current-workflow.json` 当前状态文件

**输出**：
- `context/workflow-state/` 目录
- `context/product-package/` 目录
- `context/current-workflow.json` 空模板

**质量门控**：
- ✅ 目录结构创建完成
- ✅ 状态模板初始化完成

---

## Stage 1: Perception

**目标**：完成需求感知层的数据收集和分析

**活动**：
1. 市场研究 - `market-intelligence` skill
2. 用户研究 - `user-research` skill
3. 竞品分析 - `competitive-analysis` skill

**技能调用**：
- Step 1.1: 调用 `/market-intelligence`
- Step 1.2: 调用 `/user-research`
- Step 1.3: 调用 `/competitive-analysis`

**输出**：
- `context/market-analysis.json`
- `context/user-research.json`
- `context/user-personas.json`
- `context/competitive-analysis/{feature-name}-{date}.json` + `.md`

**质量门控**：
- ✅ 市场研究完成 - 市场规模、趋势、机会点
- ✅ 用户画像完成 - 2+ 个用户角色定义
- ✅ 竞品分析完成 - 3+ 个竞品功能对比
- **质量门控通过** - 进入 Strategy 阶段

**状态更新**：
```json
{
  "workflow_id": "wf-{{timestamp}}",
  "workflow_name": "full-pm-cycle",
  "status": "in_progress",
  "current_layer": "perception",
  "current_skill": "competitive-analysis",
  "current_stage": "S1",
  "completed_stages": ["S0"],
  "mode": "copilot",
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

**原型格式选择**：

在 PRD 生成后，询问用户选择原型输出格式：

| Option | Description | 输出位置 |
|:-------|-------------|:-----------|
| **HTML 原型** | 可在浏览器直接预览、演示交互 | `context/prototypes/{name}.html` |
| **Pencil 设计稿** | 结构化设计数据、专业设计工具、可导出代码 | `context/prototypes/{name}.pen` |
| **两者都生成** | 同时生成 HTML 和 Pencil 两种格式 | 两者 |

**输出**：
- `context/prd/{feature-name}-{date}-v{version}.md`
- `context/prototypes/{feature-name}.html`（如选择）
- `context/prototypes/{feature-name}.pen`（如选择）
- `context/prototypes/{feature-name}-preview.png`（Pencil 预览图）

**质量门控**：
- ✅ PRD 完整（8 章节，不含项目计划）
- ✅ 原型已创建（HTML 或 Pencil）
- ✅ **Pencil 格式：.pen 文件包含 version 和 children 字段**
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
- `context/project-plan-[feature].md`
- `context/release-plan-[feature].md`

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
- `context/post-launch-report.md`

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
  "product_name": "产品名称",
  "product_type": "new-product | new-feature | pivot",
  "started_at": "ISO 8601 时间戳",
  "updated_at": "最后更新时间 (ISO 8601)",
  "outputs": {
    "market_analysis": "文件路径",
    "user_research": "文件路径",
    "competitive_analysis": "文件路径",
    "positioning": "文件路径",
    "roadmap": "文件路径",
    "prioritization": "文件路径",
    "prd": "文件路径",
    "prototype": "文件路径",
    "review_notes": "文件路径",
    "project_plan": "文件路径",
    "release_plan": "文件路径",
    "impact_analysis": "文件路径",
    "feedback_synthesis": "文件路径",
    "iteration_plan": "文件路径"
  }
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
        - 市场规模估算
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
        - PRD 完整（8 章，不含项目计划）
        - 用户故事映射
        - 验收标准定义
    - prototype_validated:
        - 原型已创建
        - 交互功能验证
        - 设计一致性检查
        - Pencil 格式：.pen 文件包含 version 和 children
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
        - 上线检查清单完成
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

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:----------|
| `product_name` | string | Yes | 产品或功能名称 |
| `product_type` | string | Yes | `new-product` (0-1), `new-feature` (1-N), `pivot` |
| `scope` | string | No | 产品范围 (默认: "full product") |
| `timeframe` | string | No | 规划时间范围 (默认: "12 months") |

---

## 上下文集成

**读取**：
- `context/current-workflow.json` - 当前工作流状态
- 用户输入和现有上下文
- 之前工作流的输出（如恢复）

**写入**：
- `context/workflow-state/{{workflow_id}}.json` - 工作流快照
- `context/product-package/` - 完整产品包目录
  - `market-analysis.json`
  - `user-research.json`
  - `user-personas.json`
  - `competitive-analysis/`
  - `positioning.md`
  - `roadmap.md`
  - `prioritization.json`
  - `prd/`
  - `prototypes/`
  - `review-notes/`
  - `project-plan.md`
  - `release-plan.md`
  - `impact-analysis.json`
  - `feedback-synthesis.json`
  - `iteration-plan.json`

---

## 自定义选项

### Fast Track Mode

跳过已有数据的阶段：
- 已有市场/用户研究 → 从 Strategy 开始
- 定位已完成 → 从 Design 开始
- PRD 已批准 → 从 Delivery 开始

### Deep Dive Mode

在特定阶段投入更多时间：
- 扩展市场研究，包含分析师报告
- 综合用户访谈计划
- 详细财务建模

### Parallel Execution

某些阶段可以并行执行：
- 用户研究和竞品分析
- PRD 评审时进行原型设计

---

## 示例：工作流执行轨迹

```json
{
  "workflow_id": "wf-20260317-003",
  "workflow_name": "full-pm-cycle",
  "status": "completed",
  "completed_stages": ["S0", "S1", "S2", "S3", "S4", "S5"],
  "execution_trace": [
    {
      "stage": "S1",
      "skill": "market-intelligence",
      "started_at": "2026-03-17T10:00:00Z",
      "completed_at": "2026-03-17T10:05:00Z",
      "outputs": ["market-analysis.json"]
    },
    {
      "stage": "S1",
      "skill": "competitive-analysis",
      "started_at": "2026-03-17T10:06:00Z",
      "completed_at": "2026-03-17T10:10:00Z",
      "outputs": ["competitive-analysis.json"]
    },
    {
      "stage": "S2",
      "skill": "product-positioning",
      "started_at": "2026-03-17T10:15:00Z",
      "completed_at": "2026-03-17T10:20:00Z",
      "outputs": ["positioning.md"]
    },
    {
      "stage": "S3",
      "skill": "prd-gen",
      "started_at": "2026-03-17T10:25:00Z",
      "completed_at": "2026-03-17T10:30:00Z",
      "outputs": ["prd-final.md"]
    },
    {
      "stage": "S4",
      "skill": "requirement-review",
      "started_at": "2026-03-17T10:35:00Z",
      "completed_at": "2026-03-17T10:45:00Z",
      "outputs": ["review-notes.md"]
    },
    {
      "stage": "S5",
      "skill": "impact-analysis",
      "started_at": "2026-03-17T10:50:00Z",
      "completed_at": "2026-03-17T11:00:00Z",
      "outputs": ["impact-analysis.json"]
    }
  ],
  "mode": "copilot",
  "started_at": "2026-03-17T10:00:00Z",
  "updated_at": "2026-03-17T11:00:00Z"
}
```

---

## 输出结构

### 最终交付物

完成工作流后，将获得：

1. **市场情报包**
   - 市场规模、趋势、关键玩家
   - 增长预测和机会分析

2. **用户研究包**
   - 用户画像和档案
   - 用户旅程图
   - 痛点和需求分析

3. **竞品分析**
   - 功能对比矩阵
   - 竞争定位
   - 差异化机会

4. **策略包**
   - 定位声明和价值主张
   - 12 个月路线图
   - 优先级功能清单

5. **设计包**
   - 包含用户故事的完整 PRD
   - 交互式原型（HTML/Pencil/Both）
   - 设计规格说明

6. **交付计划**
   - 项目时间表和里程碑
   - 资源分配
   - 发布计划

7. **测量计划**
   - 成功指标和 KPI
   - 效果分析框架
   - 反馈收集计划
