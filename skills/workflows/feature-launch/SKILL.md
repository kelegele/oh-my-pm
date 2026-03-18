---
name: feature-launch
description: 编排从 PRD 到上线后分析的完整功能发布工作流。采用 Plan-and-Execute 模式，包含完整的阶段定义、状态追踪和质量门控。当准备发布功能、协调功能发布，或用户说"发布这个功能"、"功能发布计划"、"从 PRD 到上线"时使用。
layer: workflow
input-from: prd-gen
output-to: impact-analysis,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.8.0
---

# Feature Launch Workflow

完整的从 PRD 到上线后分析的功能发布工作流，采用 **Plan-and-Execute 模式**。

## What This Workflow Does

Orchestrates end-to-end feature launch process spanning:
- **Design**: PRD finalization, prototype validation
- **Delivery**: Requirement review, project coordination, release management
- **Validation**: Impact analysis, feedback synthesis

---

## Workflow Architecture

本工作流采用 **Plan-and-Execute 模式**组织，确保完整的阶段定义、状态追踪和质量门控。

### 五层对应阶段

| Stage ID | 名称 | 对应层 | 说明 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | 初始化 | 创建工作流状态文件 |
| S1 | Design | 方案设计 | PRD 定稿、原型验证 |
| S2 | Delivery | 交付协调 | 需求评审、项目计划、发布管理 |
| S3 | Validation | 价值验证 | 效果分析、反馈综合 |

---

## Workflow Stages

| Stage ID | 名称 | 质量门控 | 下阶段 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | - | S1 | Design |
| S1 | Design | PRD 定稿 + 原型验证 | S2 | Delivery |
| S2 | Delivery | 发布完成 | S3 | Validation |
| S3 | Validation | 效果评估 | 完成 |

**阶段执行顺序**：S0 → S1 → S2 → S3

---

## Stage 0: Setup

**目标**：初始化工作流状态和上下文目录

**活动**：
- 创建 `context/launch-{feature-name}/` 目录用于发布产物
- 初始化 `context/current-workflow.json` 当前状态文件

**输出**：
- `context/launch-{feature-name}/` 目录
- `context/current-workflow.json` 空模板

**质量门控**：
- ✅ 目录结构创建完成
- ✅ 状态模板初始化完成

---

## Stage 1: Design (方案设计)

**目标**：完成方案设计层的 PRD 定稿和原型验证

**活动**：
1. PRD 生成 - `prd-gen` skill（最终版本）
2. 原型设计 - `prototype-design` skill（验证）

**技能调用**：
- Step 1.1: 调用 `/prd-gen` 生成最终 PRD
- Step 1.2: 调用 `/prototype-design` 验证或创建原型

**输出**：
- `context/prd/{feature-name}-final-v{version}.md`
- `context/prototypes/{feature-name}.html`（如选择）
- `context/prototypes/{feature-name}.pen`（如选择）

**质量门控**：
- ✅ PRD 完整（8 章，不含项目计划）
- ✅ 原型已验证
- ✅ **Pencil 格式：.pen 文件格式正确（包含 version）**
- ✅ **Pencil 格式：可在 Pencil 应用中打开**
- **质量门控通过** - 进入 Delivery 阶段

**状态更新**：
```json
{
  "workflow_id": "wf-{{timestamp}}",
  "workflow_name": "feature-launch",
  "status": "in_progress",
  "current_layer": "design",
  "current_skill": "prototype-design",
  "current_stage": "S1",
  "completed_stages": ["S0"],
  "mode": "copilot",
  "started_at": "{{ISO_8601}}",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 2: Delivery (交付协调)

**目标**：完成交付协调层的工作

**活动**：
1. 需求评审 - `requirement-review` skill
2. 项目计划 - `project-coordination` skill
3. 发布管理 - `release-management` skill

**技能调用**：
- Step 2.1: 调用 `/requirement-review`
- Step 2.2: 调用 `/project-coordination`
- Step 2.3: 调用 `/release-management`

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
  "completed_stages": ["S0", "S1"],
  "current_layer": "delivery",
  "current_skill": "release-management",
  "current_stage": "S2",
  "status": "in_progress",
  "mode": "copilot",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 3: Validation (价值验证)

**目标**：完成价值验证层的数据收集和分析

**活动**：
1. 效果分析 - `impact-analysis` skill
2. 反馈综合 - `feedback-synthesis` skill

**技能调用**：
- Step 3.1: 调用 `/impact-analysis`
- Step 3.2: 调用 `/feedback-synthesis`

**输出**：
- `context/impact-analysis/{feature-name}-{date}.json`
- `context/feedback-synthesis/{feature-name}-{date}.json`
- `context/post-launch-report.md`

**质量门控**：
- ✅ 效果分析完成 - 目标达成度分析、关键指标收集
- ✅ 反馈综合完成 - 用户反馈收集、主题分析、改进建议
- **工作流完成** - 全部 4 个阶段完成

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1", "S2"],
  "current_layer": "validation",
  "current_skill": "feedback-synthesis",
  "current_stage": "S3",
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
  "current_layer": "design | delivery | validation",
  "current_skill": "当前执行的 Skill",
  "current_stage": "当前阶段 (S0-S3)",
  "completed_stages": "已完成的阶段列表",
  "mode": "协作模式 (autopilot | copilot | manual)",
  "feature_name": "功能名称",
  "launch_date": "目标发布日期",
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

### Design 层质量门控

```yaml
design_gates:
  S1_to_S2:
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
  S2_to_S3:
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
  S3_complete:
    - impact_analysis_complete:
        - 目标达成度分析
        - 关键指标收集
    - feedback_synthesis_complete:
        - 反馈收集完成
        - 主题分析完成
```

---

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:----------|
| `feature_name` | string | Yes | 发布功能的名称 |
| `prd_ref` | string | Yes | 现有 PRD 的引用 |
| `launch_date` | string | No | 目标发布日期 |
| `scope` | string | No | 发布范围 (beta, phased, full) |

---

## 上下文集成

**读取**：
- `context/prd/*.md` - 待发布的 PRD
- `context/design/` - 原型和规范
- `context/current-workflow.json` - 当前工作流状态

**写入**：
- `context/launch-{feature}/` - 所有发布产物
- `context/workflow-state/{{workflow_id}}.json` - 工作流快照
- `context/review-notes/*.md` - 评审记录
- `context/project-plan/*.md` - 项目计划
- `context/release-plan/*.md` - 发布计划
- `context/impact-analysis/*.json` - 效果分析
- `context/feedback-synthesis/*.json` - 反馈综合

---

## Stage Details

### Stage 1: Design Finalization (T-4 to T-3 weeks)

**Checklist**:
- [ ] PRD 包括所有完整章节
- [ ] 成功指标定义且可测量
- [ ] 边界情况已识别
- [ ] 原型已创建并审查
- [ ] 用户测试完成（如适用）

**Decision Points**:
- 功能范围确认？
- 时间线现实吗？
- 资源可用吗？

**Stage Output**: 准备评审的 PRD + 已验证的原型

### Stage 2: Preparation (T-3 to T-1 weeks)

**Requirement Review Meeting**:
1. 提前 48 小时分发 PRD 和原型
2. 走查需求
3. 讨论关注点和边界情况
4. 记录决策
5. 获得签字

**Project Planning**:
1. 分解为任务
2. 分配负责人和估算
3. 识别依赖
4. 规划风险
5. 建立状态报告

**Checklist**:
- [ ] 干系人受邀参加评审
- [ ] 项目计划包含任务和负责人
- [ ] 风险登记册已创建
- [ ] 沟通计划已准备

**Stage Output**: 已批准的需求 + 项目计划

### Stage 3: Release (T-1 week to T+1 day)

**Pre-Release (T-7 to T-1 days)**:
- [ ] 代码完成并审查
- [ ] QA 测试完成
- [ ] 性能测试完成
- [ ] 安全审查完成
- [ ] 发布说明已起草
- [ ] 沟通材料已准备
- [ ] 支持团队已简报

**Release Day (T-day)**:
- [ ] 部署到预发布，冒烟测试
- [ ] 部署到生产
- [ ] 生产环境冒烟测试
- [ ] 启用功能（或逐步放量）
- [ ] 密切监控指标
- [ ] 准备回滚

**Post-Release (T+1 day)**:
- [ ] 验证所有系统
- [ ] 发送公告
- [ ] 监控支持渠道
- [ ] 检查指标

**Stage Output**: 功能上线且稳定

### Stage 4: Validation (T+1 to T+14 days)

**Immediate (T+1 to T+7 days)**:
- 监控错误率和性能
- 跟踪采用指标
- 快速响应问题
- 收集初始反馈

**Analysis (T+7 to T+14 days)**:
- 对比成功指标
- 分析用户反馈
- 识别改进点
- 记录学习

**Checklist**:
- [ ] 效果分析完成
- [ ] 反馈已综合
- [ ] 成功/失败已确定
- [ ] 后续步骤已识别

**Stage Output**: 效果报告 + 建议

---

## Launch Strategies

| Strategy | When to Use | Pros | Cons |
|:---|:---|:---|:---|
| **Big Bang** | 小改动、低风险 | 简单、信息清晰 | 风险高、回滚困难 |
| **Phased Rollout** | 大功能、高风险 | 可控、早期学习 | 完整上线时间长 |
| **Feature Flag** | 非常风险、复杂 | 瞬间回滚 | 基础设施复杂 |
| **Beta Release** | 需验证、反馈 | 早期获得反馈 | 信息泄露、支持负担 |

---

## Output Structure

### Final Deliverables

1. **Launch Package** (pre-launch)
   - 最终版 PRD
   - 已验证的原型
   - 项目计划
   - 发布计划

2. **Release Package** (at launch)
   - 发布说明
   - 沟通材料
   - 支持文档

3. **Post-Launch Package** (after launch)
   - 效果分析报告
   - 反馈综合
   - 经验总结
   - 建议

---

## Risk Management

常见发布风险和缓解措施：

| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| Critical bug | Medium | High | 彻底 QA、回滚计划 |
| Low adoption | High | High | 内部测试、营销推动 |
| Performance issues | Low | High | 负载测试、渐进发布 |
| Negative feedback | Medium | Medium | Beta 测试、支持准备 |
| Scope creep | Medium | Medium | 严格变更流程 |

---

## 示例：工作流执行轨迹

```json
{
  "workflow_id": "wf-20260317-002",
  "workflow_name": "feature-launch",
  "status": "completed",
  "completed_stages": ["S0", "S1", "S2", "S3"],
  "execution_trace": [
    {
      "stage": "S1",
      "skill": "prd-gen",
      "started_at": "2026-03-17T10:00:00Z",
      "completed_at": "2026-03-17T10:05:00Z",
      "outputs": ["prd-final.md"]
    },
    {
      "stage": "S1",
      "skill": "prototype-design",
      "started_at": "2026-03-17T10:06:00Z",
      "completed_at": "2026-03-17T10:10:00Z",
      "outputs": ["prototype.html"]
    },
    {
      "stage": "S2",
      "skill": "requirement-review",
      "started_at": "2026-03-17T10:15:00Z",
      "completed_at": "2026-03-17T10:25:00Z",
      "outputs": ["review-notes.md"]
    },
    {
      "stage": "S2",
      "skill": "release-management",
      "started_at": "2026-03-17T10:30:00Z",
      "completed_at": "2026-03-17T10:40:00Z",
      "outputs": ["release-plan.md"]
    },
    {
      "stage": "S3",
      "skill": "impact-analysis",
      "started_at": "2026-03-17T10:45:00Z",
      "completed_at": "2026-03-17T10:50:00Z",
      "outputs": ["impact.json"]
    }
  ],
  "mode": "copilot",
  "started_at": "2026-03-17T10:00:00Z",
  "updated_at": "2026-03-17T10:50:00Z"
}
```
