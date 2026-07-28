# Oh-My-PM 代码地图

> 项目结构和组件快速导航指南（v1.0.0：三层主线（感知 → 策略 → 设计）+ 验证辅助）

---

## 目录结构概览

```
oh-my-pm/
├── skills/                    # 核心 Skills (11个，扁平结构)
│   ├── competitive-analysis/
│   ├── market-research/
│   ├── clarify-requirements/
│   ├── product-strategy/
│   ├── prd-gen/
│   ├── prototype-design/
│   ├── retrospective/
│   ├── feedback-synthesis/
│   ├── quick-prd/
│   ├── full-pm-cycle/
│   └── feature-launch/
├── agents/                    # Subagents 定义 (6个)
│   ├── perception/           # 感知层 Subagents (3)
│   ├── validation/           # 验证层 Subagents (2)
│   └── workflows/            # 编排器 Subagents (1)
├── commands/                  # CLI 命令定义 (4个)
├── .claude-plugin/             # 插件配置
├── .claude/agent-memory/       # Subagent 记忆存储
├── docs/product/                   # 工作流上下文文件
├── templates/                 # HTML 原型模板
├── docs/                      # 项目文档
├── tests/                      # 测试脚本
└── *.md                      # 根配置文件
```

---

## Skills 组件地图

### Perception Layer (需求感知层 · 主线 ①)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **competitive-analysis** | `skills/competitive-analysis/SKILL.md` | 分析竞品, 对比, 竞品分析 | 竞品列表 | `docs/product/.ompm/competitive-analysis.json` |
| **market-research** | `skills/market-research/SKILL.md` | 市场分析, 行业趋势, 用户研究, 用户画像 | 行业信息 / 访谈数据 | `docs/product/.ompm/market-analysis.json` + `.ompm/user-research.json` |
| **clarify-requirements** | `skills/clarify-requirements/SKILL.md` | 梳理需求, 需求澄清, 还缺什么信息 | 需求描述 | `docs/product/.ompm/clarification-result.json` |

### Strategy Layer (策略规划层 · 主线 ②)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **product-strategy** | `skills/product-strategy/SKILL.md` | 产品定位, 差异化, 优先级, RICE, 路线图 | 感知层输出 | `docs/product/positioning.md` + `roadmap.md` + `.ompm/prioritization.json` |

### Design Layer (方案设计层 · 主线 ③)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **prd-gen** | `skills/prd-gen/SKILL.md` | 写 PRD, 需求文档, 产品需求 | 需求描述 | `docs/product/prd/*.md`（尾门内置需求预审） |
| **prototype-design** | `skills/prototype-design/SKILL.md` | 创建原型, 设计这个功能, UI 原型 | PRD 文档 | `docs/product/prototypes/*.html` |

### Validation Layer (价值验证层 · 辅助闭环)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **retrospective** | `skills/retrospective/SKILL.md` | 效果分析, 上线复盘, 迭代规划, sprint planning | 埋点数据 + 反馈 | `docs/product/.ompm/impact-analysis.json` + `.ompm/iteration-plan.json` |
| **feedback-synthesis** | `skills/feedback-synthesis/SKILL.md` | 反馈分析, 用户反馈, 反馈汇总 | 反馈数据 | `docs/product/.ompm/feedback-synthesis.json` |

### Workflows Layer (工作流编排层)

| Workflow | 文件路径 | 触发关键词 | 调用的 Skills |
|:--------|:----------|:----------|:-------------|
| **quick-prd** | `skills/quick-prd/SKILL.md` | 快速 PRD, 带竞品分析的 PRD | competitive-analysis → prd-gen（full-pm-cycle 薄预设） |
| **full-pm-cycle** | `skills/full-pm-cycle/SKILL.md` | 完整产品规划, 0-1 产品, 产品全周期 | 全部 8 个领域 Skills |
| **feature-launch** | `skills/feature-launch/SKILL.md` | 功能发布, 发布协调, 发布工作流 | prd-gen（预审尾门）→ 发布 checklist/灰度策略 → retrospective → feedback-synthesis |

> 交付能力不再独立成层：PRD 预审并入 `prd-gen` 尾门，发布 checklist / 灰度策略并入 `feature-launch`。

---

## Subagents 组件地图

| Subagent | 文件路径 | 层级 | 模型 | 记忆目录 | 调用方 |
|:---------|:----------|:-----|:-----|:----------|:---------|
| **market-researcher** | `agents/perception/market-researcher.md` | Perception | haiku | `.claude/agent-memory/market-researcher/` | market-research |
| **competitive-analyst** | `agents/perception/competitive-analyst.md` | Perception | sonnet | `.claude/agent-memory/competitive-analyst/` | competitive-analysis |
| **user-interviewer** | `agents/perception/user-interviewer.md` | Perception | sonnet | `.claude/agent-memory/user-interviewer/` | market-research |
| **impact-analyst** | `agents/validation/impact-analyst.md` | Validation | sonnet | `.claude/agent-memory/impact-analyst/` | retrospective |
| **feedback-collector** | `agents/validation/feedback-collector.md` | Validation | haiku | `.claude/agent-memory/feedback-collector/` | feedback-synthesis |
| **pm-orchestrator** | `agents/workflows/pm-orchestrator.md` | Workflows | inherit | `.claude/agent-memory/pm-orchestrator/` | full-pm-cycle |

---

## Commands 组件地图

| Command | 文件路径 | 参数格式 | 调用的 Workflow |
|:--------|:----------|:---------|:----------------|
| **/quick-prd** | `commands/quick-prd.md` | `<功能描述> [竞品...]` | skills/quick-prd/SKILL.md |
| **/full-pm-cycle** | `commands/full-pm-cycle.md` | `<产品名称> [type]` | skills/full-pm-cycle/SKILL.md |
| **/feature-launch** | `commands/feature-launch.md` | `<功能名称> [日期]` | skills/feature-launch/SKILL.md |
| **/ompm** | `commands/ompm.md` | 自然语言 / `<命令> [参数...]` / `help` / `?` | 全局意图路由：无参/自然语言时读上下文 + current-workflow.json 推荐下一步；workflow 名直派到以上 3 个 workflow |

---

## Context 文件地图

| 文件 | 格式 | 用途 | 读写 Skills |
|:-----|:-----|:-----|:-----------|
| `docs/product/.ompm/competitive-analysis.json` | JSON | 竞品分析结果 | competitive-analysis → prd-gen / product-strategy |
| `docs/product/.ompm/market-analysis.json` | JSON | 市场分析数据 | market-research → product-strategy |
| `docs/product/.ompm/user-research.json` | JSON | 用户研究数据（含 personas） | market-research → product-strategy |
| `docs/product/.ompm/clarification-result.json` | JSON | 需求澄清结果 | clarify-requirements → prd-gen |
| `docs/product/.ompm/prioritization.json` | JSON | 优先级排序结果 | product-strategy → prd-gen / feature-launch |
| `docs/product/positioning.md` | Markdown | 产品定位 | product-strategy |
| `docs/product/roadmap.md` | Markdown | 产品路线图 | product-strategy |
| `docs/product/.ompm/prd-draft.md` | Markdown | PRD 文档草稿 | prd-gen |
| `docs/product/prd/<日期>-<名称>.md` | Markdown | 版本化 PRD 文档 | prd-gen |
| `docs/product/prototypes/*.html` | HTML | HTML 原型文件 | 推荐使用 HTML 直接生成原型 |
| `docs/product/.ompm/current-workflow.json` | JSON | 工作流状态追踪 | 全部 workflows（/ompm 路由也读取） |
| `docs/product/.ompm/impact-analysis.json` | JSON | 效果分析数据 | retrospective |
| `docs/product/.ompm/feedback-synthesis.json` | JSON | 反馈综合结果 | feedback-synthesis → retrospective |
| `docs/product/.ompm/iteration-plan.json` | JSON | 迭代计划 | retrospective |

---

## Template 文件地图

| 目录/文件 | 用途 |
|:----------|:-----|
| `templates/prototype/wireframe.html` | 低保真原型模板 |
| `templates/prototype/mockup.html` | 中保真原型模板 |
| `templates/prototype/interactive.html` | 高保真交互原型模板 |

---

## Plugin 配置文件

| 文件 | 用途 |
|:-----|:-----|
| `.claude-plugin/plugin.json` | 插件元数据、Skills/Agents/Commands 声明 |
| `.claude-plugin/skills.yaml` | Skills 清单（YAML 格式） |
| `.claude-plugin/agents.yaml` | Agents 清单（YAML 格式） |
| `.claude-plugin/marketplace.json` | Marketplace 发布配置 |

---

## 文档文件地图

| 文件 | 内容 |
|:-----|:-----|
| `CLAUDE.md` | 项目配置指南（Claude Code 主文件） |
| `README.md` | 项目说明、快速开始、组件清单 |
| `CONTRIBUTING.md` | 贡献指南、Skill 编写规范 |
| `CHANGELOG.md` | 版本变更记录 |
| `docs/architecture/workflow-architecture.md` | Plan-and-Execute 工作流架构规范 |
| `docs/architecture/subagent-architecture.md` | Subagent 架构说明 |
| `docs/memory/project-memory.md` | 项目记忆、技术决策、教训 |
| `docs/planning/roadmap.md` | 项目路线图、里程碑 |
| `docs/guides/testing-guide.md` | 测试指南、测试用例 |

---

## 三层主线 + 验证辅助数据流

```
┌─────────────────────────────────────────────────┐
│  Perception Layer (需求感知 · 主线 ①)            │
│  skills/ (3 Skills)                             │
│  agents/perception/ (3 Subagents)               │
│  输出: .ompm/market-analysis.json 等            │
└─────────────────────────────────────────────────┘
                       ↓ docs/product/
┌─────────────────────────────────────────────────┐
│  Strategy Layer (策略规划 · 主线 ②)              │
│  skills/ (1 Skill)                              │
│  输入: .ompm/*.json from Perception             │
│  输出: positioning.md, roadmap.md,              │
│        .ompm/prioritization.json                │
└─────────────────────────────────────────────────┘
                       ↓ docs/product/
┌─────────────────────────────────────────────────┐
│  Design Layer (方案设计 · 主线 ③)                │
│  skills/ (2 Skills)                             │
│  输入: 策略输出 from Strategy                    │
│  输出: prd/*.md, prototypes/*.html              │
│  注: PRD 预审并入 prd-gen 尾门；                 │
│      发布 checklist/灰度策略并入 feature-launch  │
└─────────────────────────────────────────────────┘
                       ↓ docs/product/
┌─────────────────────────────────────────────────┐
│  Validation Layer (价值验证 · 辅助闭环)          │
│  skills/ (2 Skills)                             │
│  agents/validation/ (2 Subagents)               │
│  输出: .ompm/impact-analysis.json 等            │
└─────────────────────────────────────────────────┘
                       ↓ docs/product/
                  (反馈回环到 Perception)
```

---

## 快速导航

### 我想...

- ...写 PRD → `skills/prd-gen/SKILL.md` 或使用 `/quick-prd`
- ...分析竞品 → `skills/competitive-analysis/SKILL.md`
- ...做市场 / 用户研究 → `skills/market-research/SKILL.md`
- ...定策略（定位 / 优先级 / 路线图） → `skills/product-strategy/SKILL.md`
- ...生成原型 → 直接使用 HTML 生成，无需特殊技能
- ...做完整产品规划 → `/full-pm-cycle` 或 `skills/full-pm-cycle/SKILL.md`
- ...发布功能 → `/feature-launch` 或 `skills/feature-launch/SKILL.md`
- ...不知道下一步做什么 → `/ompm`（全局意图路由）
- ...查看 Subagent 记忆 → `.claude/agent-memory/<name>/MEMORY.md`

### 查找...

- **所有 Skills**: `skills.yaml` 或 `.claude-plugin/plugin.json`
- **所有 Subagents**: `agents.yaml` 或 `.claude-plugin/plugin.json`
- **所有 Commands**: `commands/` 目录
- **Context 文件**: `docs/product/` 目录
- **文档**: `docs/` 目录

---

## 版本信息

- **当前版本**: v1.0.0
- **最后更新**: 2026-07-28
- **组件总数**: 11 Skills + 6 Subagents + 4 Commands

### 最近变更 (v1.0.0)

- 架构简化：五层 → 三层主线（感知 → 策略 → 设计）+ 验证辅助；交付层取消（PRD 预审并入 prd-gen 尾门，发布 checklist/灰度策略并入 feature-launch）
- Skill 合并：market-intelligence + user-research → market-research；positioning + prioritization + roadmap → product-strategy；impact-analysis + iteration-planning → retrospective
- 删除 data-monitoring / process-optimization / requirement-review / project-coordination / release-management；Subagent 8 → 6（删除 data-monitor、process-optimizer）
- `/ompm` 升级为全局意图路由（无参/自然语言时读上下文 + current-workflow.json 推荐下一步）

### v0.9.4

- 补齐缺失组件索引（clarify-requirements / prototype-design / quick-prd）
- 五层架构数据流图更新为扁平 `.ompm/<name>.json` 命名

### v0.9.3

- 统一 context 传递契约为扁平 .ompm 模型
- 修复文档版本号与组件计数漂移
- test-skills 全量覆盖 + frontmatter 校验 + context 契约回归守卫

### v0.9.1

- 恢复 `prototype-design` Skill（HTML-only，移除 Pencil 集成）
- Design 层恢复为 3 个 Skills: prd-gen + prototype-design + process-optimization
