# Oh-My-PM 代码地图

> 项目结构和组件快速导航指南

---

## 目录结构概览

```
oh-my-pm/
├── skills/                    # 核心 Skills (20个)
│   ├── perception/           # 需求感知层 (4)
│   ├── strategy/             # 策略规划层 (3)
│   ├── design/               # 方案设计层 (4)
│   ├── delivery/             # 交付协调层 (3)
│   ├── validation/           # 价值验证层 (3)
│   └── workflows/            # 工作流编排器 (3)
├── agents/                    # Subagents 定义 (8个)
│   ├── perception/           # 感知层 Subagents (4)
│   ├── design/               # 设计层 Subagents (1)
│   ├── validation/           # 验证层 Subagents (2)
│   └── workflows/            # 编排器 Subagents (1)
├── commands/                  # CLI 命令定义 (4个)
├── .claude-plugin/             # 插件配置
├── .claude/agent-memory/       # Subagent 记忆存储
├── context/                   # 工作流上下文文件
├── templates/                 # HTML 原型模板
├── docs/                      # 项目文档
├── tests/                      # 测试脚本
└── *.md                      # 根配置文件
```

---

## Skills 组件地图

### Perception Layer (需求感知层)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **competitive-analysis** | `skills/perception/competitive-analysis/SKILL.md` | 分析竞品, 对比, 竞品分析 | 竞品列表 | `context/competitive-analysis.json` |
| **market-intelligence** | `skills/perception/market-intelligence/SKILL.md` | 市场分析, 行业趋势, 市场研究 | 行业信息 | 市场洞察报告 |
| **user-research** | `skills/perception/user-research/SKILL.md` | 用户访谈, 用户画像, 用户研究 | 访谈数据 | `context/personas.json` |
| **data-monitoring** | `skills/perception/data-monitoring/SKILL.md` | 监控指标, 数据看板, 指标分析 | 指标数据 | 异常告警 |

### Strategy Layer (策略规划层)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **product-positioning** | `skills/strategy/product-positioning/SKILL.md` | 产品定位, 差异化, 价值主张 | 市场数据 | 定位声明 |
| **roadmap-planning** | `skills/strategy/roadmap-planning/SKILL.md` | 产品路线图, 版本规划, 路线图 | 需求池 | `context/roadmap.md` |
| **prioritization** | `skills/strategy/prioritization/SKILL.md` | 优先级排序, 需求优先级, RICE, MoSCoW | 需求列表 | 优先级矩阵 |

### Design Layer (方案设计层)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **prd-gen** | `skills/design/prd-gen/SKILL.md` | 写 PRD, 需求文档, 产品需求 | 需求描述 | `context/prd/*.md` |
| **prototype-design** | `skills/design/prototype-design/SKILL.md` | 设计原型, 原型, 交互设计, wireframe, HTML/Pencil 原型 | PRD | `context/prototypes/*.html`, `context/prototypes/*.pen` |
| **pencil-design** | `skills/design/pencil-design/SKILL.md` | Pencil, 设计稿, .pen, Pencil design, MCP 工具集成 | PRD | `context/prototypes/*.pen`, `context/prototypes/*-preview.png` |
| **process-optimization** | `skills/design/process-optimization/SKILL.md` | 流程优化, 提效, 流程改进 | 现有流程 | 优化建议 |

### Delivery Layer (交付协调层)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **requirement-review** | `skills/delivery/requirement-review/SKILL.md` | 需求评审, 评审会议, 需求对齐 | PRD 文档 | 评审报告 |
| **project-coordination** | `skills/delivery/project-coordination/SKILL.md` | 项目状态, 进度跟踪, 项目管理 | 项目计划 | 进度报告 |
| **release-management** | `skills/delivery/release-management/SKILL.md` | 发布计划, 上线检查, 发布管理, 上线 | 版本内容 | 发布计划 |

### Validation Layer (价值验证层)

| Skill | 文件路径 | 触发关键词 | 输入 | 输出 |
|:-----|:----------|:----------|:-----|:-----|
| **impact-analysis** | `skills/validation/impact-analysis/SKILL.md` | 效果分析, 上线复盘, 效果评估 | 埋点数据 | `context/impact.json` |
| **feedback-synthesis** | `skills/validation/feedback-synthesis/SKILL.md` | 反馈分析, 用户反馈, 反馈汇总 | 反馈数据 | 反馈分类 |
| **iteration-planning** | `skills/validation/iteration-planning/SKILL.md` | 迭代规划, 版本排期, sprint planning | 效果+反馈 | `context/iteration-plan.json` |

### Workflows Layer (工作流编排层)

| Workflow | 文件路径 | 触发关键词 | 调用的 Skills |
|:--------|:----------|:----------|:-------------|
| **quick-prd** | `skills/workflows/quick-prd/SKILL.md` | 快速 PRD, 带竞品分析的需求 | competitive-analysis → prd-gen → prototype-design |
| **full-pm-cycle** | `skills/workflows/full-pm-cycle/SKILL.md` | 完整产品规划, 0-1 产品, 产品全周期 | 全部 16 个 Skills |
| **feature-launch** | `skills/workflows/feature-launch/SKILL.md` | 功能发布, 发布协调, 发布工作流 | prd-gen → requirement-review → release-management → impact-analysis |

---

## Subagents 组件地图

| Subagent | 文件路径 | 层级 | 模型 | 记忆目录 | 调用方 |
|:---------|:----------|:-----|:-----|:----------|:---------|
| **market-researcher** | `agents/perception/market-researcher.md` | Perception | haiku | `.claude/agent-memory/market-researcher/` | market-intelligence |
| **competitive-analyst** | `agents/perception/competitive-analyst.md` | Perception | sonnet | `.claude/agent-memory/competitive-analyst/` | competitive-analysis |
| **user-interviewer** | `agents/perception/user-interviewer.md` | Perception | sonnet | `.claude/agent-memory/user-interviewer/` | user-research |
| **data-monitor** | `agents/perception/data-monitor.md` | Perception | haiku | `.claude/agent-memory/data-monitor/` | data-monitoring |
| **process-optimizer** | `agents/design/process-optimizer.md` | Design | sonnet | `.claude/agent-memory/process-optimizer/` | process-optimization |
| **impact-analyst** | `agents/validation/impact-analyst.md` | Validation | sonnet | `.claude/agent-memory/impact-analyst/` | impact-analysis |
| **feedback-collector** | `agents/validation/feedback-collector.md` | Validation | haiku | `.claude/agent-memory/feedback-collector/` | feedback-synthesis |
| **pm-orchestrator** | `agents/workflows/pm-orchestrator.md` | Workflows | inherit | `.claude/agent-memory/pm-orchestrator/` | full-pm-cycle |

---

## Commands 组件地图

| Command | 文件路径 | 参数格式 | 调用的 Workflow |
|:--------|:----------|:---------|:----------------|
| **/quick-prd** | `commands/quick-prd.md` | `<功能描述> [竞品...]` | skills/workflows/quick-prd/SKILL.md |
| **/full-pm-cycle** | `commands/full-pm-cycle.md` | `<产品名称> [type]` | skills/workflows/full-pm-cycle/SKILL.md |
| **/feature-launch** | `commands/feature-launch.md` | `<功能名称> [日期]` | skills/workflows/feature-launch/SKILL.md |
| **/ompm** | `commands/ompm.md` | `<命令> [参数...]` 或 `help` / `?` | 分发到以上 3 个 workflow |

---

## Context 文件地图

| 文件 | 格式 | 用途 | 读写 Skills |
|:-----|:-----|:-----|:-----------|
| `context/competitive-analysis.json` | JSON | 竞品分析结果 | competitive-analysis → prd-gen |
| `context/personas.json` | JSON | 用户画像数据 | user-research |
| `context/roadmap.md` | Markdown | 产品路线图 | roadmap-planning |
| `context/prd-draft.md` | Markdown | PRD 文档草稿 | prd-gen |
| `context/prd/<日期>-<名称>.md` | Markdown | 版本化 PRD 文档 | prd-gen |
| `context/prototypes/*.html` | HTML | HTML 原型文件 | prototype-design |
| `context/prototypes/*.pen` | .pen | Pencil 设计文件 | pencil-design |
| `context/current-workflow.json` | JSON | 工作流状态追踪 | 全部 workflows |
| `context/impact.json` | JSON | 效果分析数据 | impact-analysis |
| `context/iteration-plan.json` | JSON | 迭代计划 | iteration-planning |
| `context/market-analysis.json` | JSON | 市场分析数据 | market-intelligence |

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
| `docs/workflow-architecture.md` | Plan-and-Execute 工作流架构规范 |
| `docs/subagent-architecture.md` | Subagent 架构说明 |
| `docs/project-memory.md` | 项目记忆、技术决策、教训 |
| `docs/roadmap.md` | 项目路线图、里程碑 |
| `docs/testing-guide.md` | 测试指南、测试用例 |

---

## 五层架构数据流

```
┌─────────────────────────────────────────────────┐
│  Perception Layer (需求感知)                    │
│  skills/perception/ (4 Skills)                 │
│  agents/perception/ (4 Subagents)               │
│  输出: market_data, personas, competitive       │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Strategy Layer (策略规划)                      │
│  skills/strategy/ (3 Skills)                    │
│  输入: market_data from Perception            │
│  输出: positioning, roadmap, priorities        │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Design Layer (方案设计)                        │
│  skills/design/ (4 Skills)                      │
│  agents/design/ (1 Subagent)                    │
│  输入: priorities from Strategy               │
│  输出: prd, prototypes (html/pen)            │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Delivery Layer (交付协调)                      │
│  skills/delivery/ (3 Skills)                    │
│  输入: prd from Design                       │
│  输出: project_plan, release_notes           │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Validation Layer (价值验证)                    │
│  skills/validation/ (3 Skills)                  │
│  agents/validation/ (2 Subagents)                │
│  输入: project_plan from Delivery               │
│  输出: impact, feedback, iteration_plan     │
└─────────────────────────────────────────────────┘
                       ↓ context/
                  (反馈回环到 Perception)
```

---

## 快速导航

### 我想...

- ...写 PRD → `skills/design/prd-gen/SKILL.md` 或使用 `/quick-prd`
- ...分析竞品 → `skills/perception/competitive-analysis/SKILL.md`
- ...规划路线图 → `skills/strategy/roadmap-planning/SKILL.md`
- ...生成原型 → `skills/design/prototype-design/SKILL.md` (HTML) 或 `skills/design/pencil-design/SKILL.md` (Pencil)
- ...做完整产品规划 → `/full-pm-cycle` 或 `skills/workflows/full-pm-cycle/SKILL.md`
- ...发布功能 → `/feature-launch` 或 `skills/workflows/feature-launch/SKILL.md`
- ...查看 Subagent 记忆 → `.claude/agent-memory/<name>/MEMORY.md`

### 查找...

- **所有 Skills**: `skills.yaml` 或 `.claude-plugin/plugin.json`
- **所有 Subagents**: `agents.yaml` 或 `.claude-plugin/plugin.json`
- **所有 Commands**: `commands/` 目录
- **Context 文件**: `context/` 目录
- **文档**: `docs/` 目录

---

## 版本信息

- **当前版本**: v0.8.0
- **最后更新**: 2026-03-18
- **组件总数**: 20 Skills + 8 Subagents + 4 Commands

### 最近变更 (v0.8.0)

- 新增 `pencil-design` Skill（独立 Pencil MCP 设计）
- `prototype-design` Skill 更新：支持 Pencil 设计稿格式
- 所有工作流 Skills 更新：Design 层质量门控添加 Pencil 格式验证
- 新增 `context/prototypes/README.md`：Pencil 格式规范和使用说明
