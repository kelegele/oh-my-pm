---
name: feature-launch
description: 编排从 PRD 到上线后分析的完整功能发布工作流。采用 Plan-and-Execute 模式，包含完整的阶段定义、状态追踪和质量门控。当准备发布功能、协调功能发布，或用户说"发布这个功能"、"功能发布计划"、"从 PRD 到上线"时使用。
layer: workflow
input-from: prd-gen
output-to: retrospective
---

# Feature Launch Workflow

完整的从 PRD 到上线后分析的功能发布工作流，采用 **Plan-and-Execute 模式**。

## What This Workflow Does

Orchestrates end-to-end feature launch process spanning:
- **Design**: PRD finalization, prototype validation
- **Delivery**: PRD 预审尾门（prd-gen）、发布策略与上线 checklist（本工作流内置）
- **Validation**: Retrospective (impact + next iteration), feedback synthesis

---

## Workflow Architecture

本工作流采用 **Plan-and-Execute 模式**组织，确保完整的阶段定义、状态追踪和质量门控。

### 五层对应阶段

| Stage ID | 名称 | 对应层 | 说明 |
|:---------|:-----|:---------|:----------|
| S0 | Setup | 初始化 | 创建工作流状态文件 |
| S1 | Design | 方案设计 | PRD 定稿、原型验证 |
| S2 | Delivery | 交付协调 | PRD 预审尾门、发布策略与上线 checklist |
| S3 | Validation | 价值验证 | 复盘、反馈综合 |

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
- 创建 `docs/product/launch-{feature-name}/` 目录用于发布产物
- 初始化 `docs/product/.ompm/current-workflow.json` 当前状态文件

**输出**：
- `docs/product/launch-{feature-name}/` 目录
- `docs/product/.ompm/current-workflow.json` 空模板

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
- Step 1.1: 调用 prd-gen 技能生成最终 PRD
- Step 1.2: 调用 prototype-design 技能验证或创建原型

**输出**：
- `docs/product/prd/{feature-name}-final-v{version}.md`
- `docs/product/prototypes/{feature-name}.html`（如选择）

**质量门控**：
- ✅ PRD 完整（9 章）
- ✅ 原型已验证


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
  "started_at": "{{ISO_8601}}",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 2: Delivery (交付协调)

**目标**：完成交付协调层的 PRD 预审与发布准备

**活动**：
1. PRD 预审尾门 - `prd-gen` skill 的预审尾门（需求评审、干系人对齐）
2. 发布计划 - 本工作流内置的发布策略与 checklist（任务分解、时间线、上线检查项，见下文 Launch Strategies 与 Release Checklist）

**技能调用**：
- Step 2.1: 运行 prd-gen 预审尾门，完成需求评审与干系人对齐
- Step 2.2: 执行本工作流的发布策略与 checklist，制定发布计划

**输出**：
- `docs/product/review-notes/[feature]-review.md`
- `docs/product/project-plan-[feature].md`
- `docs/product/release-plan-[feature].md`

**质量门控**：
- ✅ PRD 预审尾门通过 - 干系人对齐、签字确认
- ✅ 任务与时间线确认 - 任务分配、排期就绪
- ✅ 发布准备完成 - 代码冻结、发布包就绪
- **质量门控通过** - 进入 Validation 阶段

**状态更新**：
```json
{
  "completed_stages": ["S0", "S1"],
  "current_layer": "delivery",
  "current_skill": "feature-launch",
  "current_stage": "S2",
  "status": "in_progress",
  "updated_at": "{{ISO_8601}}"
}
```

---

## Stage 3: Validation (价值验证)

**目标**：完成价值验证层的数据收集和分析

**活动**：
1. 复盘 - `retrospective` skill（效果分析 + 迭代建议）
2. 反馈综合 - `feedback-synthesis` skill

**技能调用**：
- Step 3.1: 调用 retrospective 技能
- Step 3.2: 调用 feedback-synthesis 技能

**输出**：
- `docs/product/.ompm/impact-analysis.json`
- `docs/product/.ompm/feedback-synthesis.json`
- `docs/product/post-launch-report.md`

**质量门控**：
- ✅ 复盘完成 - 目标达成度分析、关键指标收集、迭代方向明确
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
  "feature_name": "功能名称",
  "launch_date": "目标发布日期",
  "started_at": "ISO 8601 时间戳",
  "updated_at": "最后更新时间 (ISO 8601)"
}
```

---

## 质量门控 (Quality Gates)

每个阶段完成后必须满足对应的质量标准才能进入下一阶段：

### Design 层质量门控

```yaml
design_gates:
  S1_to_S2:
    - prd_complete:
        - PRD 完整（9 章）
        - 用户故事映射
        - 验收标准定义
    - prototype_validated:
        - 原型已创建
        - 交互功能验证
        - 设计一致性检查
```

### Delivery 层质量门控

```yaml
delivery_gates:
  S2_to_S3:
    - prd_pre_review_passed:
        - prd-gen 预审尾门通过
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
    - retrospective_complete:
        - 目标达成度分析
        - 关键指标收集
        - 迭代建议产出
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
- `docs/product/prd/*.md` - 待发布的 PRD
- `docs/product/design/` - 原型和规范
- `docs/product/.ompm/current-workflow.json` - 当前工作流状态

**写入**：
- `docs/product/launch-{feature}/` - 所有发布产物
- `docs/product/.ompm/workflow-state/{{workflow_id}}.json` - 工作流快照
- `docs/product/review-notes/*.md` - 评审记录
- `docs/product/project-plan/*.md` - 项目计划
- `docs/product/release-plan/*.md` - 发布计划
- `docs/product/.ompm/impact-analysis.json` - 效果分析
- `docs/product/.ompm/feedback-synthesis.json` - 反馈综合

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

**PRD 预审尾门（prd-gen）**:
1. 提前 48 小时分发 PRD 和原型
2. 走查需求
3. 讨论关注点和边界情况
4. 记录决策
5. 获得签字

**发布计划（本工作流内置）**:
1. 分解为任务
2. 分配负责人和估算
3. 识别依赖
4. 规划风险
5. 建立状态报告

**Checklist**:
- [ ] 干系人受邀参加预审
- [ ] 发布计划包含任务和负责人
- [ ] 风险登记册已创建
- [ ] 沟通计划已准备

**Stage Output**: 已批准的需求 + 发布计划

### Stage 3: Release (T-1 week to T+1 day)

**Pre-Release Checklist (T-7 to T-1 days)**:

工程：
- [ ] 代码完成并审查，测试通过（unit / integration / e2e）
- [ ] 无未解决的关键 bug；性能测试与安全审查完成
- [ ] 数据库迁移与回滚方案已准备

质量：
- [ ] QA 测试完成，验收标准全部满足
- [ ] 边界情况、兼容性、无障碍已验证

产品：
- [ ] PRD 需求逐条验证，成功指标与埋点已就绪
- [ ] 功能开关（feature flag）已配置（如采用）

文档与沟通：
- [ ] 发布说明已起草，用户 / API 文档已更新
- [ ] 公告与应用内通知已准备
- [ ] 支持团队已简报，销售 / 客服与干系人已同步

合规（如适用）：
- [ ] 隐私与合规审查完成

**Release Day (T-day)**:
- [ ] 部署到预发布，冒烟测试
- [ ] 部署到生产
- [ ] 生产环境冒烟测试
- [ ] 启用功能（或按灰度放量计划逐步放量）
- [ ] 密切监控指标（对照上线后 24 小时监控基线）
- [ ] 准备回滚（对照回滚计划）

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
- [ ] 复盘完成（效果分析 + 迭代建议）
- [ ] 反馈已综合
- [ ] 成功/失败已确定
- [ ] 后续步骤已识别

**Stage Output**: 复盘报告 + 建议

---

## Launch Strategies

| Strategy | When to Use | Pros | Cons |
|:---|:---|:---|:---|
| **Big Bang** | 小改动、低风险 | 简单、信息清晰 | 风险高、回滚困难 |
| **Phased Rollout** | 大功能、高风险 | 可控、早期学习 | 完整上线时间长 |
| **Feature Flag** | 非常风险、复杂 | 瞬间回滚 | 基础设施复杂 |
| **Beta Release** | 需验证、反馈 | 早期获得反馈 | 信息泄露、支持负担 |

### 灰度放量计划（Phased Rollout / Feature Flag）

采用 Phased Rollout 或 Feature Flag 时，按阶段放量，每阶段设观察期与放量条件：

| 阶段 | 范围 | 观察期 | 放量条件 | 状态 |
|:-----|:-----|:-------|:---------|:-----|
| 1 | 内部用户 / 白名单 | 1 天 | 无 P0 问题、核心指标无异常 | ⏳ |
| 2 | 5%–10% 目标用户 | 1–3 天 | 错误率低于阈值、无集中负面反馈 | ⏳ |
| 3 | 50% | 2–3 天 | 指标稳定 | ⏳ |
| 4 | 100% 全量 | — | — | ⏳ |

### 回滚计划

| 触发条件 | 动作 | 负责人 |
|:---------|:-----|:-------|
| 发现关键 bug | 回滚到上一版本 / 关闭 feature flag | DevOps |
| 错误率超阈值（如 > 5%） | 回滚并排查 | DevOps |
| 性能劣化 | 回滚或扩容 | DevOps |

### 上线后 24 小时监控基线

| 指标 | 目标 | 告警阈值 | 负责人 |
|:-----|:-----|:---------|:-------|
| 错误率 | < 0.5% | > 1% | 工程 |
| 延迟 (p95) | < 500ms | > 1s | 工程 |
| 核心转化 | 不低于基线 | 下跌 > 10% | PM |
| 支持工单 | 正常水位 | > 2 倍基线 | 支持 |

### 发布类型与准备周期

| 类型 | 说明 | 准备时间 | 风险级别 |
|:-----|:-----|:---------|:---------|
| **Hotfix** | 紧急生产修复 | 数小时 | 高 |
| **Patch** | 仅缺陷修复 | 数天 | 低 |
| **Minor** | 新功能、向后兼容 | 1–2 周 | 中 |
| **Major** | 破坏性变更、重大功能 | 1–2 月 | 高 |

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
   - 复盘分析报告
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
      "skill": "prd-gen",
      "started_at": "2026-03-17T10:15:00Z",
      "completed_at": "2026-03-17T10:25:00Z",
      "outputs": ["review-notes.md"]
    },
    {
      "stage": "S2",
      "skill": "feature-launch",
      "started_at": "2026-03-17T10:30:00Z",
      "completed_at": "2026-03-17T10:40:00Z",
      "outputs": ["release-plan.md"]
    },
    {
      "stage": "S3",
      "skill": "retrospective",
      "started_at": "2026-03-17T10:45:00Z",
      "completed_at": "2026-03-17T10:50:00Z",
      "outputs": ["impact-analysis.json"]
    }
  ],
  "started_at": "2026-03-17T10:00:00Z",
  "updated_at": "2026-03-17T10:50:00Z"
}
```
