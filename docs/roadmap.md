# Oh-My-PM 项目路线图

## 版本历史

### v0.8.0 - Plan-and-Execute 架构 (当前)

**目标**: 统一工作流架构，引入 Pencil MCP 集成

**已完成**:
- ✅ Plan-and-Execute 工作流架构文档 (`docs/workflow-architecture.md`)
- ✅ Pencil MCP 集成 (`skills/design/pencil-design/SKILL.md`)
- ✅ 统一阶段标识 (S0-S5)
- ✅ 统一质量门控定义
- ✅ 工作流状态追踪字段

---

### v0.7.0 - Pencil MCP 集成

**已完成**:
- ✅ `pencil-design` skill - 使用 Pencil MCP 生成 .pen 设计文件
- ✅ 关键词更新 (pencil, pen)
- ✅ 专业设计能力集成

---

### v0.6.0 - HTML 原型生成

**已完成**:
- ✅ HTML 原型生成系统
- ✅ `templates/prototype/` 目录
- ✅ 三种保真度模板 (wireframe/mockup/interactive)
- ✅ `prototype-design` skill 增强
- ✅ 移除 Figma 依赖

---

### v0.5.1 - Commands 集成

**已完成**:
- ✅ 3 个 workflow commands (quick-prd, full-pm-cycle, feature-launch)
- ✅ 1 个 namespace dispatcher (ompm)
- ✅ 双调用模式支持 (直接调用 + 命名空间)

---

### v0.3.0 - Subagent 混合架构

**已完成**:
- ✅ 8 个专业化 Subagents
- ✅ 独立记忆系统 (`.claude/agent-memory/`)
- ✅ Skills + Subagents 混合架构
- ✅ Subagent 配置文档 (`docs/subagent-architecture.md`)

---

### v0.2.0 - 完整五层架构

**已完成**:
- ✅ 全部 16 个层级 Skills
- ✅ 3 个工作流编排器
- ✅ 五层架构完整实现

---

### v0.1.0 - MVP

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

## 当前状态 (v0.8.0)

### 组件统计

| 组件类型 | 数量 | 状态 |
|:---------|:-----:|:-----|
| **Skills** | 20 | ✅ 完成 |
| - Perception Layer | 4 | ✅ |
| - Strategy Layer | 3 | ✅ |
| - Design Layer | 4 | ✅ |
| - Delivery Layer | 3 | ✅ |
| - Validation Layer | 3 | ✅ |
| - Workflows | 3 | ✅ |
| **Subagents** | 8 | ✅ 完成 |
| **Commands** | 4 | ✅ 完成 |

### 功能特性

| 特性 | 状态 | 版本 |
|:-----|:-----|:-----|
| 五层工作流架构 | ✅ | v0.2.0 |
| 场景驱动 PRD | ✅ | v0.3.0 |
| HTML 原型生成 | ✅ | v0.6.0 |
| Pencil MCP 集成 | ✅ | v0.7.0 |
| Subagent 记忆系统 | ✅ | v0.3.0 |
| Commands 集成 | ✅ | v0.5.1 |
| Plan-and-Execute 架构 | ✅ | v0.8.0 |
| 质量门控系统 | ✅ | v0.8.0 |

---

## 未来规划

### v1.0.0 - 企业版与集成能力

**目标**: 企业级功能增强

**计划新增**:
- [ ] Jira/Linear API 集成
- [ ] Mixpanel/Amplitude 数据分析集成
- [ ] 多 Agent 协作 (模拟产品评审会)
- [ ] 预测性分析 (提前识别项目风险)
- [ ] 个性化适配 (学习个人工作风格)

---

## 里程碑

| 里程碑 | 目标 | 状态 |
|:------|:-----|:-----|
| M1 | MVP 发布 | ✅ 2026-03 |
| M2 | 完整五层架构 | ✅ 2026-03 |
| M3 | Subagent 混合架构 | ✅ 2026-03 |
| M4 | Commands 集成 | ✅ 2026-03 |
| M5 | HTML 原型生成 | ✅ 2026-03 |
| M6 | Pencil MCP 集成 | ✅ 2026-03 |
| M7 | Plan-and-Execute 架构 | ✅ 2026-03 |
| M8 | 企业版功能 (v1.0) | ⏳ 待规划 |

---

## Skill 完整清单

### Perception Layer (需求感知层)

| Skill | 版本 | 文件 |
|:-----|:-----|:-----|
| competitive-analysis | 0.1.0 | skills/perception/competitive-analysis/SKILL.md |
| market-intelligence | 0.1.0 | skills/perception/market-intelligence/SKILL.md |
| user-research | 0.1.0 | skills/perception/user-research/SKILL.md |
| data-monitoring | 0.1.0 | skills/perception/data-monitoring/SKILL.md |

### Strategy Layer (策略规划层)

| Skill | 版本 | 文件 |
|:-----|:-----|:-----|
| product-positioning | 0.1.0 | skills/strategy/product-positioning/SKILL.md |
| roadmap-planning | 0.1.0 | skills/strategy/roadmap-planning/SKILL.md |
| prioritization | 0.1.0 | skills/strategy/prioritization/SKILL.md |

### Design Layer (方案设计层)

| Skill | 版本 | 文件 |
|:-----|:-----|:-----|
| prd-gen | 0.3.0 | skills/design/prd-gen/SKILL.md |
| prototype-design | 0.6.0 | skills/design/prototype-design/SKILL.md |
| pencil-design | 0.1.0 | skills/design/pencil-design/SKILL.md |
| process-optimization | 0.1.0 | skills/design/process-optimization/SKILL.md |

### Delivery Layer (交付协调层)

| Skill | 版本 | 文件 |
|:-----|:-----|:-----|
| requirement-review | 0.1.0 | skills/delivery/requirement-review/SKILL.md |
| project-coordination | 0.1.0 | skills/delivery/project-coordination/SKILL.md |
| release-management | 0.1.0 | skills/delivery/release-management/SKILL.md |

### Validation Layer (价值验证层)

| Skill | 版本 | 文件 |
|:-----|:-----|:-----|
| impact-analysis | 0.1.0 | skills/validation/impact-analysis/SKILL.md |
| feedback-synthesis | 0.1.0 | skills/validation/feedback-synthesis/SKILL.md |
| iteration-planning | 0.1.0 | skills/validation/iteration-planning/SKILL.md |

### Workflows Layer (工作流编排层)

| Workflow | 版本 | 文件 |
|:--------|:-----|:-----|
| quick-prd | 0.2.0 | skills/workflows/quick-prd/SKILL.md |
| full-pm-cycle | 0.1.0 | skills/workflows/full-pm-cycle/SKILL.md |
| feature-launch | 0.1.0 | skills/workflows/feature-launch/SKILL.md |

---

## Subagents 完整清单

| Subagent | 层级 | 模型 | 文件 |
|:---------|:-----|:-----|:-----|
| market-researcher | Perception | haiku | agents/perception/market-researcher.md |
| competitive-analyst | Perception | sonnet | agents/perception/competitive-analyst.md |
| user-interviewer | Perception | sonnet | agents/perception/user-interviewer.md |
| data-monitor | Perception | haiku | agents/perception/data-monitor.md |
| process-optimizer | Design | sonnet | agents/design/process-optimizer.md |
| impact-analyst | Validation | sonnet | agents/validation/impact-analyst.md |
| feedback-collector | Validation | haiku | agents/validation/feedback-collector.md |
| pm-orchestrator | Workflows | inherit | agents/workflows/pm-orchestrator.md |

---

## Commands 完整清单

| Command | 文件 | 描述 |
|:--------|:-----|:-----|
| quick-prd | commands/quick-prd.md | 快速生成带竞品分析的 PRD |
| full-pm-cycle | commands/full-pm-cycle.md | 完整产品管理周期 (0-1) |
| feature-launch | commands/feature-launch.md | 功能发布工作流 |
| ompm | commands/ompm.md | 命名空间分发器 |

---

## 技术债务

- [ ] Skill 触发率自动化测试
- [ ] Context Schema 验证
- [ ] Skill 性能监控
- [ ] 错误处理机制完善
- [ ] Skill 版本管理自动化

---

## 依赖项目

- [Claude Code](https://claude.ai/code) - 宿主环境
- [Pencil MCP](https://github.com/anysphere/mcp-server-pencilmcp) - 专业设计稿生成
- [anthropics/skills](https://github.com/anthropics/skills) - Skill 参考实现
