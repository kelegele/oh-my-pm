# Oh-My-PM 项目路线图

## 版本历史

### v1.3.0 - P2 吸收收尾 (当前)

**已完成**:
- ✅ prd-gen 模板懒加载（SKILL.md 662→375 行，模板拆至 `references/` 随目录安装）
- ✅ ompm 新手引导模式（教程→立即首次实战）
- ✅ 证据纪律第 4 条「可追溯」（5 个产出型 skill 逐字内联）
- ✅ Step 1.5 问题体检补第三类陷阱（相关当因果）
- ✅ evals codex 路径实测通过

---

### v1.2.0 - 对标吸收

**已完成**:
- ✅ 访谈工艺升级（clarify-requirements / prd-gen）：阶段进度前缀、对话规则、Step 1.5 问题体检、按就绪度分别生成
- ✅ ompm 模式 B 任务后导航（导航地图 + 统一承接话术 + 空对话引导 + 边界情况）
- ✅ 跨 skill 交接契约（8 个领域 skill 统一收尾块）
- ✅ 状态模型记录已否决方向（rejected_directions）；retrospective 已否决方向回顾
- ✅ product-strategy 优先级方法按上下文选择并说明理由

---

### v1.1.0 - 可移植性改造

**已完成**:
- ✅ `npx skills add` 任意 agent（codex/cursor/copilot…）安装 12 个 Skills 即获全能力（路由、证据纪律、执行画像）
- ✅ `ompm` 全局意图路由移植为第 12 个 Skill（唯一权威），command 变为激活它的 shim
- ✅ 4 个 Skill 新增 Execution Profile 跨宿主契约（模型建议/工具姿态/记忆文件），`agents/*.md` 为其 Claude Code 实现
- ✅ Skill 体工具名去硬编码（能力描述为主、宿主示例为辅）

---

### v1.0.0 - 简化重构

**已完成**:
- ✅ 五层架构简化为三层主线（感知→策略→设计）+ 验证辅助，Skills 20 → 11
- ✅ Skill 合并：market-intelligence+user-research→market-research；positioning+prioritization+roadmap→product-strategy；impact-analysis+iteration-planning→retrospective
- ✅ 取消交付层：PRD 预审并入 prd-gen 尾门，发布 checklist/灰度并入 feature-launch；删除 data-monitoring/process-optimization/project-coordination
- ✅ Subagents 8 → 6（删除 data-monitor、process-optimizer）；全局证据纪律内联 5 个产出型 Skill

---

### v0.10.0 - 行为测试与可执行契约

**已完成**:
- ✅ Evals 行为测试体系（`evals/`，`claude -p` headless 真实模型断言）
- ✅ 可执行上下文契约：`contracts/*.schema.json`（9 份）+ 最小示例 + `validate_contracts.py` / `validate-context.sh`
- ✅ quick-prd 薄预设化：编排逻辑收敛到 full-pm-cycle（`mode: quick` + S2.5 策略确认硬门控）
- ✅ 删除 Skill 级版本号，plugin.json 成为唯一版本源

---

### v0.9.4 - 契约统一修复

**已完成**:
- ✅ `agents/` 上下文路径统一为扁平 `.ompm/<name>.json` 契约
- ✅ 版本号同步：marketplace.json / agents.yaml 对齐 plugin.json；skills.yaml layer 统一为单数 `workflow`
- ✅ 修复多处 Skill/Agent 文案笔误与过期内容；契约守卫扩展扫描 `agents/` 目录

---

### v0.9.3 - Context 契约修复与文档同步

**已完成**:
- ✅ 统一 context 传递契约为扁平 .ompm 模型（移除 dated/nested 写入与 personas 文件名分裂）
- ✅ 修复文档版本号与组件计数漂移（plugin/AGENTS/README/roadmap/CODEMAPS/subagent-architecture）
- ✅ test-skills 全量覆盖 + frontmatter 校验 + context 契约回归守卫

---

### v0.8.0 - Plan-and-Execute 架构


**已完成**:
- ✅ Plan-and-Execute 工作流架构文档 (`docs/architecture/workflow-architecture.md`)
- ✅ 统一阶段标识 (S0-S5)
- ✅ 统一质量门控定义
- ✅ 工作流状态追踪字段

---


**已完成**:
- ✅ 关键词更新 (pencil, pen)
- ✅ 专业设计能力集成

---

### v0.6.0 - HTML 原型生成

**已完成**:
- ✅ HTML 原型生成系统
- ✅ `templates/prototype/` 目录
- ✅ 三种保真度模板 (wireframe/mockup/interactive)
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
- ✅ Subagent 配置文档 (`docs/architecture/subagent-architecture.md`)

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

## 当前状态 (v1.1.0)

### 组件统计

| 组件类型 | 数量 | 状态 |
|:---------|:-----:|:-----|
| **Skills** | 12 | ✅ 完成 |
| - Perception Layer | 3 | ✅ |
| - Strategy Layer | 1 | ✅ |
| - Design Layer | 2 | ✅ |
| - Validation Layer | 2 | ✅ |
| - Workflows（含 ompm 路由） | 4 | ✅ |
| **Subagents** | 6 | ✅ 完成 |
| **Commands** | 4 | ✅ 完成 |

（交付层已于 v1.0.0 取消：PRD 预审 → prd-gen 尾门，发布 checklist/灰度 → feature-launch。）

### 功能特性

| 特性 | 状态 | 版本 |
|:-----|:-----|:-----|
| 五层工作流架构 | ✅ | v0.2.0 |
| 场景驱动 PRD | ✅ | v0.3.0 |
| HTML 原型生成 | ✅ | v0.6.0 |
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
| M7 | Plan-and-Execute 架构 | ✅ 2026-03 |
| M8 | 企业版功能 (v1.0) | ⏳ 待规划 |

---

## Skill 完整清单

> Skill 级版本号已于 v0.10.0 移除，`plugin.json` 为唯一版本源。当前共 12 个 Skills。

| Skill | Layer | 文件路径 |
|:------|:------|:---------|
| clarify-requirements | perception | skills/clarify-requirements/SKILL.md |
| competitive-analysis | perception | skills/competitive-analysis/SKILL.md |
| market-research | perception | skills/market-research/SKILL.md |
| product-strategy | strategy | skills/product-strategy/SKILL.md |
| prd-gen | design | skills/prd-gen/SKILL.md |
| prototype-design | design | skills/prototype-design/SKILL.md |
| feedback-synthesis | validation | skills/feedback-synthesis/SKILL.md |
| retrospective | validation | skills/retrospective/SKILL.md |
| ompm | workflow | skills/ompm/SKILL.md |
| quick-prd | workflow | skills/quick-prd/SKILL.md |
| full-pm-cycle | workflow | skills/full-pm-cycle/SKILL.md |
| feature-launch | workflow | skills/feature-launch/SKILL.md |

---

## Subagents 完整清单

| Subagent | 层级 | 模型 | 文件 |
|:---------|:-----|:-----|:-----|
| market-researcher | Perception | haiku | agents/perception/market-researcher.md |
| competitive-analyst | Perception | sonnet | agents/perception/competitive-analyst.md |
| user-interviewer | Perception | sonnet | agents/perception/user-interviewer.md |
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
- [anthropics/skills](https://github.com/anthropics/skills) - Skill 参考实现
