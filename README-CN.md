# Oh-My-PM

<div align="center">

> 面向产品经理的 AI Agent 工作流系统

[![License](https://img.shields.io/github/license/kelegele/oh-my-pm)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue)](https://github.com/kelegele/oh-my-pm/releases)
[![Skills](https://img.shields.io/badge/Skills-11-blue)](skills/)
[![Agents](https://img.shields.io/badge/Agents-6-purple)](agents/)

**三层主线 + 验证辅助 · 6 个 Subagents · 11 个专业 Skills · 完整产品闭环**

[快速开始](#快速开始) • [全部 Skills](#全部-skills) • [Subagents](#subagents-架构) • [English](README.md)

</div>

---

## 简介

Oh-My-PM 是一套面向产品经理的 AI Agent 工作流系统，以 **Claude Code Skill 插件**形式交付。不造 SaaS 平台，而是通过 AI Agent 插件和工作流编排，实现产品管理任务的自动化与增强。

### 核心特性

| 特性 | 说明 |
|:-----|:-----|
| **三层主线 + 验证辅助** | 感知 → 策略 → 设计为主线，验证技能形成反馈闭环 |
| **场景驱动 PRD** | 迭代更新 / 新功能 / 0-1 产品——拒绝随意 YY |
| **行业基准校验** | 自动对标最佳实践，确保方案专业度 |
| **HTML 原型生成** | PRD 后直接生成可交互 HTML 原型 |
| **按需安装** | 单个 Skill 独立安装，用哪个装哪个 |

---

## 快速开始

### 前置要求

- [Claude Code](https://claude.ai/code) 或 [OpenAI Codex](https://github.com/openai/codex) CLI 工具

### 安装 (Claude Code)

```bash
# 安装全部 11 个 skills
npx skills add kelegele/oh-my-pm -a claude-code

# 安装单个 skill
npx skills add kelegele/oh-my-pm --skill prd-gen -a claude-code

# 安装多个 skills
npx skills add kelegele/oh-my-pm --skill prd-gen --skill competitive-analysis -a claude-code

# 查看可安装的 skills
npx skills add kelegele/oh-my-pm --list
```

### 安装 (Codex)

```bash
# 安装全部 skills
npx skills add kelegele/oh-my-pm -a codex

# 安装单个 skill
npx skills add kelegele/oh-my-pm --skill prd-gen -a codex

# 查看可安装的 skills
npx skills add kelegele/oh-my-pm --list
```

### 使用

#### Commands（直接调用）

```bash
/quick-prd "用户个人中心改版" 淘宝 京东
/full-pm-cycle "新项目管理工具"
/feature-launch "用户注册流程"

/ompm help  # 显示所有可用命令和 skills
```

`/ompm` 同时也是**全局意图路由**：无参数或输入自然语言需求时，会读取当前上下文和 `docs/product/.ompm/current-workflow.json`，推荐当前最有价值的下一步。

#### Skills（自然语言触发）

11 个 Skills 通过自然语言自动触发：

```bash
"帮我分析一下 Notion 和飞书文档的竞品差异"    # → competitive-analysis
"写一个用户个人中心改版的 PRD"                # → prd-gen
"这个功能上线后效果如何"                      # → retrospective
"我们的产品应该如何定位"                      # → product-strategy
```

---

## 三层主线 + 验证辅助

主线为 **感知 → 策略 → 设计**；验证技能辅助形成反馈闭环。原交付层已并入：PRD 预审成为 `prd-gen` 尾门，发布 checklist / 灰度策略并入 `feature-launch`。顶层由 3 个工作流编排器（`quick-prd` / `full-pm-cycle` / `feature-launch`）串接。

```
┌─────────────────────────────────────────────────────────────┐
│  主线 ①：需求感知 (Perception)           3 Skills            │
│  竞品分析 · 市场研究（市场 + 用户） · 需求澄清               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  主线 ②：策略规划 (Strategy)             1 Skill             │
│  产品策略（定位 · 优先级 · 路线图）                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  主线 ③：方案设计 (Design)               2 Skills            │
│  PRD 生成（含预审尾门） · 原型设计                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
   辅助：价值验证 (Validation)           2 Skills
   复盘（效果分析 + 迭代规划） · 反馈综合 ──→ 反馈闭环
└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
```

---

## 全部 Skills

### 📊 需求感知层 (Perception)

| Skill | 安装 | 功能 | 触发示例 |
|:-----|:-----|:-----|:---------|
| `competitive-analysis` | `--skill competitive-analysis` | 竞品功能对比分析，识别战略机会 | "分析竞品"、"对比 XX 和 YY" |
| `market-research` | `--skill market-research` | 市场趋势、行业分析与用户研究/画像 | "市场分析"、"行业趋势"、"用户研究" |
| `clarify-requirements` | `--skill clarify-requirements` | 需求澄清与信息缺口分析 | "梳理需求"、"还缺什么信息" |

### 🎯 策略规划层 (Strategy)

| Skill | 安装 | 功能 | 触发示例 |
|:-----|:-----|:-----|:---------|
| `product-strategy` | `--skill product-strategy` | 定位、优先级 (RICE / MoSCoW) 与路线图一体规划 | "产品定位"、"需求优先级"、"产品路线图" |

### 🎨 方案设计层 (Design)

| Skill | 安装 | 功能 | 触发示例 |
|:-----|:-----|:-----|:---------|
| `prd-gen` | `--skill prd-gen` | 结构化 PRD 生成（场景驱动，含预审尾门） | "写 PRD"、"需求文档" |
| `prototype-design` | `--skill prototype-design` | HTML 原型生成（迭代 + 新产品模式） | "设计原型"、"HTML 原型" |

### 📈 价值验证层 (Validation)

| Skill | 安装 | 功能 | 触发示例 |
|:-----|:-----|:-----|:---------|
| `retrospective` | `--skill retrospective` | 上线效果复盘 + 下轮迭代规划 | "效果分析"、"上线复盘"、"迭代规划" |
| `feedback-synthesis` | `--skill feedback-synthesis` | 用户反馈汇总与分析 | "反馈分析"、"用户反馈" |

### 🔄 工作流编排器 (Workflows)

| Workflow | 安装 | 功能 | 触发示例 |
|:---------|:-----|:-----|:---------|
| `quick-prd` | `--skill quick-prd` | full-pm-cycle 薄预设：竞品分析 + PRD 一体化 | "快速 PRD"、"带竞品分析的需求" |
| `full-pm-cycle` | `--skill full-pm-cycle` | 完整产品周期 (0-1) | "完整产品规划"、"0-1 产品" |
| `feature-launch` | `--skill feature-launch` | 功能发布工作流（发布 checklist + 灰度策略） | "功能发布"、"发布协调" |

---

## PRD 生成的三种场景

`prd-gen` 支持智能场景识别：

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 功能描述 + UI 状态 + 迭代目标 | 截图 / HTML / 链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 docs/product/ 读取 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

**核心原则**：不随意 YY，基于行业最佳实践输出。

---

## Subagents 架构

### 什么是 Subagents？

Subagents 是专门的 AI 代理，运行在独立上下文中，具有自定义系统提示、特定工具访问和独立权限。当 Claude 遇到匹配 subagent 描述的任务时，会委托给该 subagent 处理。

### Subagents vs Skills

| 特性 | Skills | Subagents |
|:-----|:-------|:----------|
| **上下文** | 主对话共享 | 独立隔离 |
| **模型选择** | 继承主对话 | 可指定 (haiku / sonnet / opus) |
| **工具限制** | 无限制 | 可配置 allowlist / denylist |
| **持久记忆** | 无 | 支持跨会话积累 |
| **适用场景** | 简单提示词注入 | 高容量输出隔离 |

### 6 个 Subagents

| Subagent | 模型 | 特性 | 触发示例 |
|:---------|:-----|:-----|:---------|
| `market-researcher` | haiku | worktree 隔离 | "分析 X 市场"、"行业趋势" |
| `competitive-analyst` | sonnet | GitHub 代码分析 | "竞品分析"、"对比 XX 和 YY" |
| `user-interviewer` | sonnet | 用户研究记忆 | "创建用户画像"、"用户访谈" |
| `impact-analyst` | sonnet | 效果分析 | "上线效果"、"如何表现" |
| `feedback-collector` | haiku | 反馈汇总 | "用户反馈"、"用户说什么" |
| `pm-orchestrator` | — | 协调完整 PM 周期，支持并行执行 | "完整产品规划"、"0-1 产品" |

### 记忆系统

每个 Subagent 有独立的记忆目录 (`.claude/agent-memory/`)，用于跨会话积累知识。

---

## 使用指南

### 目录结构

```
oh-my-pm/
├── agents/                    # Subagent 定义 (6)
│   ├── perception/            # 市场研究、竞品分析、用户研究
│   ├── validation/            # 效果分析、反馈汇总
│   └── workflows/             # PM 编排器
├── skills/                    # Skill 插件目录 (11)
│   ├── competitive-analysis/  # layer: perception
│   ├── market-research/       # layer: perception
│   ├── clarify-requirements/  # layer: perception
│   ├── product-strategy/      # layer: strategy
│   ├── prd-gen/               # layer: design
│   ├── prototype-design/      # layer: design
│   ├── retrospective/         # layer: validation
│   ├── feedback-synthesis/    # layer: validation
│   ├── quick-prd/             # layer: workflow
│   ├── full-pm-cycle/         # layer: workflow
│   └── feature-launch/        # layer: workflow
├── commands/                  # CLI 命令定义 (4)
├── docs/product/                   # 上下文传递目录
├── templates/prototype/       # HTML 原型模板
├── .claude-plugin/            # 插件配置
└── docs/                      # 设计文档
```

---

## 开发路线图

| 版本 | 目标 | 状态 |
|:-----|:-----|:-----|
| v0.1.0 | MVP (4 Skills) | ✅ |
| v0.2.0 | 完整五层架构 (19 Skills) | ✅ |
| v0.3.0 | Subagent 混合架构 (8 Subagents + 记忆系统) | ✅ |
| v0.4.0 | Commands 集成 (19 Skills + 4 Commands) | ✅ |
| v0.5.1 | 移除 Figma 依赖，切换 HTML 原型 | ✅ |
| v0.6.0 | HTML 原型生成（迭代 + 新产品模式） | ✅ |
| v0.9.0 | 扁平化 Skill 目录，支持按需安装单个 Skill | ✅ |
| v0.9.3 | 修复 context 传递契约（统一扁平 .ompm 模型）+ 文档版本同步 | ✅ |
| v1.0.0 | 简化架构：三层主线 + 验证辅助（11 Skills / 6 Subagents） | ✅ |

---

## License

[MIT License](LICENSE)
