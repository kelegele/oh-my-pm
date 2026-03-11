# Oh-My-PM 项目路线图

## 版本规划

### v0.1.0 - MVP (当前)

**目标**: 验证核心工作流

**已完成**:
- ✅ 4 个核心 Skills
  - `competitive-analysis` - 竞品分析
  - `prd-gen` - PRD 生成
  - `iteration-planning` - 迭代规划
  - `quick-prd` - 快速 PRD 工作流
- ✅ 基础 Context 文件系统
- ✅ 测试框架
- ✅ GitHub 仓库建立

---

### v0.2.0 - Design Layer Expansion

**目标**: 完善设计层能力

**计划新增**:
- [ ] `prototype-design` - 原型设计辅助
- [ ] `process-optimization` - 流程优化

**依赖技能**: 原型工具集成 (Figma API)

---

### v0.3.0 - Perception Layer

**目标**: 实现需求感知能力

**计划新增**:
- [ ] `market-intelligence` - 市场情报收集
- [ ] `user-research` - 用户研究分析
- [ ] `data-monitoring` - 数据监控告警

**依赖技能**: 数据源接入 (Google Trends, App Annie)

---

### v0.4.0 - Strategy Layer

**目标**: 实现策略规划能力

**计划新增**:
- [ ] `product-positioning` - 产品定位
- [ ] `roadmap-planning` - 路线图规划
- [ ] `prioritization` - 优先级排序

**依赖技能**: RICE/MoSCoW 优先级框架

---

### v0.5.0 - Delivery Layer

**目标**: 实现交付协调能力

**计划新增**:
- [ ] `requirement-review` - 需求评审
- [ ] `project-coordination` - 项目协调
- [ ] `release-management` - 发布管理

**依赖技能**: Jira/Linear API 集成

---

### v0.6.0 - Validation Layer Expansion

**目标**: 完善价值验证能力

**计划新增**:
- [ ] `impact-analysis` - 影响分析
- [ ] `feedback-synthesis` - 反馈汇总

**依赖技能**: 分析平台接入 (Mixpanel, Amplitude)

---

### v1.0.0 - Full Cycle

**目标**: 完整的产品管理工作流

**新增**:
- [ ] `full-pm-cycle` - 完整工作流编排器
- [ ] 16 个 Skills 全部完成
- [ ] 完整的反馈闭环

---

## 里程碑

| 里程碑 | 目标 | 预计完成 |
|:------|:-----|:---------|
| M1 | MVP 发布 | ✅ 2026-03 |
| M2 | 设计层完成 | 🔄 2026-04 |
| M3 | 感知层完成 | ⏳ 2026-05 |
| M4 | 策略层完成 | ⏳ 2026-06 |
| M5 | 交付层完成 | ⏳ 2026-07 |
| M6 | 验证层完成 | ⏳ 2026-08 |
| M7 | v1.0 发布 | ⏳ 2026-09 |

---

## Skill 状态矩阵

### 已完成 ✅

| Skill | 层级 | 版本 |
|:-----|:-----|:-----|
| competitive-analysis | Perception | 0.1.0 |
| prd-gen | Design | 0.1.0 |
| iteration-planning | Validation | 0.1.0 |
| quick-prd | Workflow | 0.1.0 |

### 进行中 🔄

| Skill | 层级 | 负责人 | 状态 |
|:-----|:-----|:-------|:-----|
| prototype-design | Design | - | Planning |
| process-optimization | Design | - | Planning |

### 待规划 ⏳

| Skill | 层级 | 优先级 |
|:-----|:-----|:-------|
| market-intelligence | Perception | P1 |
| user-research | Perception | P1 |
| data-monitoring | Perception | P2 |
| product-positioning | Strategy | P1 |
| roadmap-planning | Strategy | P1 |
| prioritization | Strategy | P2 |
| requirement-review | Delivery | P1 |
| project-coordination | Delivery | P1 |
| release-management | Delivery | P2 |
| impact-analysis | Validation | P1 |
| feedback-synthesis | Validation | P1 |
| full-pm-cycle | Workflow | P0 |

---

## 技术债务

- [ ] 添加 Skill 触发率自动化测试
- [ ] 实现 Context Schema 验证
- [ ] 添加 Skill 性能监控
- [ ] 完善错误处理机制
- [ ] 添加 Skill 版本管理

---

## 依赖项目

- [Claude Code](https://claude.ai/code) - 宿主环境
- [anthropics/skills](https://github.com/anthropics/skills) - Skill 参考实现
