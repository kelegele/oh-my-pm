# Oh-My-PM

<div align="center">

> 面向产品经理的 AI Agent 工作流系统 — 通过 Claude Code Subagent 插件实现

[![Claude Code](https://img.shields.io/badge/Claude-Code-forest?logo=anthropic)](https://claude.ai/code)
[![License](https://img.shields.io/github/license/kelegele/oh-my-pm)](LICENSE)
[![Version](https://img.shields.io/github/v/release/kelegele/oh-my-pm)](https://github.com/kelegele/oh-my-pm/releases)

**五层架构 · 8 个 Subagents · 19 个专业 Skills · 完整产品闭环**

[快速开始](#快速开始) • [Subagents](#subagents-架构) • [Skills](#全部-skills) • [使用指南](#使用指南) • [贡献](#贡献指南)

</div>

---

## 简介

Oh-My-PM 是一套基于 **Claude Code Skill** 插件的产品经理工作流系统。它不构建独立的 SaaS 平台，而是通过 AI Agent 插件和工作流编排，实现产品管理任务的自动化与增强。

### 核心特性

| 特性 | 说明 |
|:-----|:-----|
| **五层工作流架构** | 从需求感知到价值验证的完整闭环 |
| **场景驱动 PRD** | 迭代更新/新功能/0-1 产品，拒绝随意 YY |
| **行业基准校验** | 自动对标最佳实践，确保方案专业度 |
| **人机协作模式** | Autopilot / Copilot / Manual 灵活切换 |

---

## 快速开始

### 前置要求

- [Claude Code](https://claude.ai/code) CLI 工具
- 将此仓库克隆到本地项目目录

### 安装

#### 方式一：克隆到本地

```bash
git clone https://github.com/kelegele/oh-my-pm.git
cd oh-my-pm
```

#### 方式二：作为 Claude Code 插件安装

```bash
# 克隆到 Claude Code 插件目录
mkdir -p ~/.claude/plugins
git clone https://github.com/kelegele/oh-my-pm.git ~/.claude/plugins/oh-my-pm

# 或创建符号链接（如果已有项目仓库）
ln -s /path/to/oh-my-pm ~/.claude/plugins/oh-my-pm
```

查看 [.claude-plugin](.claude-plugin/) 目录了解插件配置详情。

### 使用

#### 方式一：作为插件目录加载（推荐）

```bash
# 在项目目录下启动 Claude Code，自动加载插件
cd /path/to/oh-my-pm
claude

# 或指定插件目录
claude --plugin-dir /path/to/oh-my-pm
```

#### 方式二：直接对话触发

在 Claude Code 中直接对话即可触发相关 Skill：

```bash
# 示例对话
"帮我分析一下 Notion 和飞书文档的竞品差异"
"写一个用户个人中心改版的 PRD"
"快速生成一个带竞品分析的需求文档"
"分析我们上周发布的功能效果"
```

#### 方式三：显式调用 Skill

```bash
# 使用 / 前缀显式调用特定 Skill
/competitive-analysis 分析 Notion vs 飞书
/prd-gen 生成用户中心改版需求文档
/full-pm-cycle 规划一个新的项目管理工具
```

---

## 五层架构

```
┌─────────────────────────────────────────────────────────────┐
│  第一层：需求感知 (Perception)     4 Skills                  │
│  市场情报 · 用户研究 · 竞品分析 · 数据监控                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第二层：策略规划 (Strategy)       3 Skills                  │
│  产品定位 · 路线图规划 · 优先级排序                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第三层：方案设计 (Design)         3 Skills                  │
│  PRD 生成 · 原型设计 · 流程优化                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第四层：交付协调 (Delivery)       3 Skills                  │
│  需求评审 · 项目协调 · 发布管理                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第五层：价值验证 (Validation)     3 Skills                  │
│  效果分析 · 反馈综合 · 迭代规划 ──→ 反馈闭环                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Subagents 架构 (v0.3.0)

### 什么是 Subagents？

Subagents 是专门的 AI 代理，运行在独立的上下文中，具有自定义系统提示、特定工具访问和独立权限。当 Claude 遇到匹配 subagent 描述的任务时，会委托给该 subagent 处理。

### Subagents vs Skills

| 特性 | Skills | Subagents |
|:-----|:-------|:----------|
| **上下文** | 主对话共享 | 独立隔离 |
| **模型选择** | 继承主对话 | 可指定 (haiku/sonnet/opus) |
| **工具限制** | 无限制 | 可配置 allowlist/denylist |
| **持久记忆** | 无 | 支持跨会话积累 |
| **适用场景** | 简单提示词注入 | 高容量输出隔离 |

### 8 个 Subagents

#### 📊 Perception 层 (4 个)

| Subagent | 模型 | 特性 | 触发示例 |
|:---------|:-----|:-----|:---------|
| `market-researcher` | haiku | worktree 隔离 | "分析 X 市场"、"行业趋势" |
| `competitive-analyst` | sonnet | GitHub 代码分析 | "竞品分析"、"对比 XX 和 YY" |
| `user-interviewer` | sonnet | 用户研究记忆 | "创建用户画像"、"用户访谈" |
| `data-monitor` | haiku | background 后台 | "监控指标"、"数据看板" |

#### 🎨 Design 层 (1 个)

| Subagent | 模型 | 特性 | 触发示例 |
|:---------|:-----|:-----|:---------|
| `process-optimizer` | sonnet | 只读模式 | "流程优化"、"提效方案" |

#### 📈 Validation 层 (2 个)

| Subagent | 模型 | 特性 | 触发示例 |
|:---------|:-----|:-----|:---------|
| `impact-analyst` | sonnet | 效果分析 | "上线效果"、"如何表现" |
| `feedback-collector` | haiku | 反馈汇总 | "用户反馈"、"用户说什么" |

#### 🔄 Workflows (1 个)

| Subagent | 功能 | 触发示例 |
|:---------|:-----|:---------|
| `pm-orchestrator` | 协调完整 PM 周期，支持并行执行 | "完整产品规划"、"0-1 产品" |

### 记忆系统

每个 Subagent 都有独立的记忆目录 (`.claude/agent-memory/`)，用于跨会话积累知识：

```
.claude/agent-memory/
├── market-researcher/    # 市场数据积累
├── competitive-analyst/  # 竞品知识库
├── user-interviewer/     # 用户研究模式
├── data-monitor/         # 指标基线
├── process-optimizer/    # 流程优化知识
├── impact-analyst/       # 效果分析框架
├── feedback-collector/   # 反馈主题模式
└── pm-orchestrator/      # 工作流最佳实践
```

### 使用方式

Subagents 由 Claude Code 自动识别并调用，无需显式触发：

```bash
# 自动识别并委托给 market-researcher
"分析 AI 写助手的市场规模"

# 自动识别并委托给 competitive-analyst
"对比 ClickUp 和 Asana 的功能差异"

# 自动识别并委托给 pm-orchestrator
"为新的项目管理工具做完整产品规划"
```

---

## 全部 Skills

### 📊 需求感知层 (Perception)

| Skill | 功能 | 触发示例 |
|:-----|:-----|:---------|
| `competitive-analysis` | 竞品功能对比分析 | "分析竞品"、"对比 XX 和 YY" |
| `market-intelligence` | 市场情报收集与分析 | "市场分析"、"行业趋势" |
| `user-research` | 用户研究与人设创建 | "用户访谈"、"创建用户画像" |
| `data-monitoring` | 产品指标监控与异常检测 | "监控指标"、"数据看板" |

### 🎯 策略规划层 (Strategy)

| Skill | 功能 | 触发示例 |
|:-----|:-----|:---------|
| `product-positioning` | 产品定位与差异化策略 | "产品定位"、"差异化策略" |
| `roadmap-planning` | 产品路线图规划 | "产品路线图"、"版本规划" |
| `prioritization` | 优先级排序 (RICE/MoSCoW) | "优先级排序"、"需求优先级" |

### 🎨 方案设计层 (Design)

| Skill | 功能 | 触发示例 |
|:-----|:-----|:---------|
| `prd-gen` | 结构化 PRD 生成 (场景驱动) | "写 PRD"、"需求文档" |
| `prototype-design` | 原型设计与交互流程 | "设计原型"、"UI 流程" |
| `process-optimization` | 业务流程优化 | "流程优化"、"提效方案" |

### 🚢 交付协调层 (Delivery)

| Skill | 功能 | 触发示例 |
|:-----|:-----|:---------|
| `requirement-review` | 需求评审与干系人对齐 | "需求评审"、"评审会议" |
| `project-coordination` | 项目进度与风险管理 | "项目状态"、"进度跟踪" |
| `release-management` | 发布管理与上线检查 | "发布计划"、"上线检查" |

### 📈 价值验证层 (Validation)

| Skill | 功能 | 触发示例 |
|:-----|:-----|:---------|
| `impact-analysis` | 上线效果分析与目标对比 | "效果分析"、"上线复盘" |
| `feedback-synthesis` | 用户反馈汇总与分析 | "反馈分析"、"用户反馈" |
| `iteration-planning` | 基于数据的迭代规划 | "迭代规划"、"版本排期" |

### 🔄 工作流编排器 (Workflows)

| Workflow | 功能 | 触发示例 |
|:---------|:-----|:---------|
| `quick-prd` | 竞品分析 + PRD 一体化 | "快速 PRD"、"带竞品分析的需求" |
| `full-pm-cycle` | 完整产品周期 (0-1) | "完整产品规划"、"0-1 产品" |
| `feature-launch` | 功能发布工作流 | "功能发布"、"发布协调" |

---

## PRD 生成的三种场景

`/prd-gen` 支持智能场景识别：

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 功能描述 + UI 状态 + 迭代目标 | 截图 / HTML / 链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 context/ 读取 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

**核心原则**：不随意 YY，基于行业最佳实践输出。

---

## 使用指南

### 人机协作模式

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:---------|
| `autopilot` | AI 自动执行，人工仅审阅 | 数据监控、报告生成 |
| `copilot` | AI 建议，人工决策确认 | PRD 生成、方案设计 |
| `manual` | 人工主导，AI 辅助 | 战略决策、创意工作 |

### 目录结构

```
oh-my-pm/
├── .claude/
│   ├── agents/            # Subagent 定义 (8 个)
│   │   ├── perception/    # 市场研究、竞品分析、用户研究、数据监控
│   │   ├── design/        # 流程优化
│   │   ├── validation/    # 效果分析、反馈汇总
│   │   └── workflows/     # PM 编排器
│   └── agent-memory/      # Subagent 记忆系统
├── skills/               # Skill 插件目录 (19 个)
│   ├── perception/       # 需求感知层 (4)
│   ├── strategy/         # 策略规划层 (3)
│   ├── design/           # 方案设计层 (3)
│   ├── delivery/         # 交付协调层 (3)
│   ├── validation/       # 价值验证层 (3)
│   └── workflows/        # 工作流编排器 (3)
├── context/              # 上下文传递目录
├── docs/                 # 设计文档
├── tests/                # 测试脚本
└── CLAUDE.md             # 项目配置
```

---

## 开发路线图

| 版本 | 目标 | 状态 |
|:-----|:-----|:-----|
| v0.1.0 | MVP (4 Skills) | ✅ |
| v0.2.0 | 完整五层架构 (19 Skills) | ✅ |
| v0.3.0 | Subagent 混合架构 (8 Subagents + 记忆系统) | ✅ |
| v0.4.0 | 工作流优化与模板库 | 🔄 |
| v1.0.0 | 企业版与集成能力 | ⏳ |

查看 [Project Board](https://github.com/users/kelegele/projects/4) 了解完整规划。

---

## 贡献指南

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 许可证

[MIT License](LICENSE)

---

<div align="center">

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)

</div>
