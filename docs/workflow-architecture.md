# Oh-My-PM 工作流架构 (v0.8.0)

## 核心概念

Oh-My-PM 采用 **Plan-and-Execute 模式**组织工作流，确保每个工作流都具有完整的阶段定义、状态追踪和质量门控。

### Plan-and-Execute 模式架构

```
┌─────────────────────────────────────────────────────────┐
│                    PLANNER (规划器)                  │
│                      │  Think → Plan → Execute                  │
├──────────────────┤  ↓                 │
│                      │            Verify (验证器)              │
└──────────────────┴         │

核心原则：
1. 先思考再行动 - 明确规划再执行
2. 阶段化分解 - 将复杂任务分解为可控的步骤
3. 质量门控 - 每个阶段完成前必须满足质量标准
4. 反馈调整 - 根据执行结果动态调整计划
```

---

## 工作流阶段 (Stages)

每个工作流由以下阶段组成：

| Stage ID | 名称 | 描述 | 关键输出 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | 初始化工作流，创建追踪文件 | workflow_tracking.json |
| S1 | Perception | 需求感知层执行 | market_data.json, personas.json |
| S2 | Strategy | 策略规划层执行 | positioning.md, roadmap.md |
| S3 | Design | 方案设计层执行 | prd/*.md, prototypes/*.html, prototypes/*.pen |
| S4 | Delivery | 交付协调层执行 | project_plan.md, release_notes.md |
| S5 | Validation | 价值验证层执行 | impact.json, feedback.json |

---

## 状态机 (State Machine)

### 状态字段定义

```json
{
  "workflow_id": "唯一的工作流ID",
  "workflow_name": "工作流名称",
  "status": "执行状态 (in_progress | completed | blocked)",
  "current_layer": "当前所在层 (perception | strategy | design | delivery | validation)",
  "current_skill": "当前执行的 Skill",
  "current_stage": "当前阶段 (S0 | S1 | S2 | S3 | S4 | S5)",
  "completed_stages": "已完成的阶段列表",
  "mode": "协作模式 (autopilot | copilot | manual)",
  "started_at": "开始时间 (ISO 8601)",
  "updated_at": "最后更新时间 (ISO 8601)"
}
```

### 状态转换规则

| 当前状态 | 可转换到 |
|:---------|:---------|
| `in_progress` | `completed` (当前阶段完成) |
| `in_progress` | `blocked` (遇到阻塞) |
| `in_progress` | 任何阶段 | 可进入下一阶段 |

---

## 质量门控 (Quality Gates)

每个阶段必须有质量门控标准，完成后才能进入下一阶段。

### Perception 层质量标准

```yaml
gate_criteria:
  perception:
    market_research_complete:
      name: "市场研究完成"
      description: "完成 3+ 竞品的市场规模和趋势分析"
      metrics: ["market_size", "growth_rate", "key_players"]
    user_research_complete:
      name: "用户研究完成"
      description: "完成 3+ 用户访谈，创建 2+ 个用户画像"
      metrics: ["personas_created", "interviews_conducted", "pain_points_identified"]
    competitive_analysis_complete:
      name: "竞品分析完成"
      description: "完成 2+ 个竞品的功能对比分析"
      metrics: ["competitors_analyzed", "matrix_complete", "differentiation_identified"]
```

### Strategy 层质量标准

```yaml
gate_criteria:
  strategy:
    positioning_complete:
      name: "产品定位完成"
      description: "完成产品定位声明、价值主张和差异化策略"
      metrics: ["positioning_created", "value_proposition_clarity"]
    roadmap_complete:
      name: "路线图完成"
      description: "完成 12 个月的产品路线图规划"
      metrics: ["roadmap_created", "milestones_defined", "timeline_set"]
    prioritization_complete:
      name: "优先级排序完成"
      description: "使用 RICE 或 MoSCoW 框架完成需求优先级排序"
      metrics: ["priorities_assigned", "rice_scores_calculated", "moscow_decisions"]
```

### Design 层质量标准

```yaml
gate_criteria:
  design:
    prd_complete:
      name: "PRD 完整"
      description: "包含全部 9 章节的 PRD 文档"
      metrics: ["all_sections_complete", "user_stories_mapped", "acceptance_criteria"]
    prototype_validated:
      name: "原型验证完成"
      description: "HTML 或 Pencil 原型已创建并可预览"
      metrics: ["prototype_created", "usability_tested", "design_consistent"]
```

### Delivery 层质量标准

```yaml
gate_criteria:
  delivery:
    requirement_review_complete:
      name: "需求评审完成"
      description: "完成干系人需求评审会议并签字"
      metrics: ["review_held", "stakeholders_aligned", "signoff_obtained"]
    project_plan_complete:
      name: "项目计划完成"
      description: "完成详细的项目计划和任务分配"
      metrics: ["tasks_assigned", "timeline_confirmed", "resources_allocated"]
    release_ready:
      name: "发布准备完成"
      description: "代码已冻结，发布包已准备，上线检查清单完成"
      metrics: ["code_freeze", "release_package_ready", "checklist_complete"]
```

### Validation 层质量标准

```yaml
gate_criteria:
  validation:
    impact_analysis_complete:
      name: "效果分析完成"
      description: "上线后 7-14 天分析目标达成度"
      metrics: ["goals_achieved", "metrics_collected", "variance_analyzed"]
    feedback_synthesis_complete:
      name: "反馈综合完成"
      description: "收集并分析用户反馈，识别改进机会"
      metrics: ["feedback_collected", "themes_identified", "improvements_mapped"]
    iteration_planning_complete:
      name: "迭代规划完成"
      description: "基于效果分析和反馈，制定下一轮迭代计划"
      metrics: ["next_iteration_planned", "success_metrics_defined", "lessons_learned"]
```

---

## 工作流状态文件

### 文件位置

```
context/current-workflow.json  # 当前工作流状态
context/workflow-state/          # 工作流快照目录
```

### workflow_tracking.json 结构

```json
{
  "workflow_id": "当前工作流 ID",
  "workflow_name": "工作流名称",
  "status": "执行状态",
  "current_layer": "当前层",
  "current_skill": "当前 Skill",
  "current_stage": "当前阶段",
  "completed_stages": ["S0", "S1", ...],
  "mode": "协作模式",
  "started_at": "开始时间",
  "updated_at": "更新时间",

  "layer_outputs": {
    "perception": {
      "market_research": "文件路径",
      "user_research": "文件路径",
      "competitive_analysis": "文件路径"
    },
    "strategy": {
      "positioning": "文件路径",
      "roadmap": "文件路径",
      "prioritization": "文件路径"
    },
    "design": {
      "prd": "文件路径",
      "prototype": "文件路径"
    },
    "delivery": {
      "requirement_review": "文件路径",
      "project_plan": "文件路径",
      "release_ready": "文件路径"
    },
    "validation": {
      "impact_analysis": "文件路径",
      "feedback_synthesis": "文件路径"
      "iteration_planning": "文件路径"
    }
  }
}
```

---

## 质量标准应用

### quick-prd 工作流改造

需要将 quick-prd 改造为符合此架构：
- 添加 5 个阶段定义（Stage S0-S4）
- 添加阶段门控（Gate）
- 更新状态追踪字段
- 完善协作模式文档

### feature-launch 工作流改造

需要将 feature-launch 改造为符合此架构：
- 添加 5 个阶段定义
- 添加阶段门控
- 完善风险管理系统
- 完善发布策略

---

## 使用指南

### 在新工作流中引用阶段定义

使用统一的阶段标识：
- Stage S0: "setup" - 工作流初始化
- Stage S1: "perception" - 需求感知
- Stage S2: "strategy" - 策略规划
- Stage S3: "design" - 方案设计
- Stage S4: "delivery" - 交付协调
- Stage S5: "validation" - 价值验证

### 质量门控使用

每个阶段完成后必须调用对应的质量门控：
```yaml
stage_gates:
  S1_perception: ["market_research_complete", "user_research_complete", "competitive_analysis_complete"]
  S2_strategy: ["positioning_complete", "roadmap_complete", "prioritization_complete"]
  S3_design: ["prd_complete", "prototype_validated"]
  S4_delivery: ["requirement_review_complete", "project_plan_complete", "release_ready"]
  S5_validation: ["impact_analysis_complete", "feedback_synthesis_complete", "iteration_planning_complete"]
```

---

## 版本历史

### v0.8.0
- 统一工作流架构文档
- 新增 `docs/workflow-architecture.md`
- 定义工作流阶段、状态机和统一质量门控
