# Oh-My-PM

> 面向产品经理的 AI Agent 工作流系统 — 通过 Claude Code Skill 插件实现

[![Claude Code](https://img.shields.io/badge/Claude-Code-forest?logo=anthropic)](https://claude.ai/code)
[![License](https://img.shields.io/github/license/kelegele/oh-my-pm)](LICENSE)
[![Version](https://img.shields.io/github/v/release/kelegele/oh-my-pm)](https://github.com/kelegele/oh-my-pm/releases)

## 简介

Oh-My-PM 是一套基于 **Claude Code Skill** 插件的产品经理工作流系统。它不构建独立的 SaaS 平台，而是通过 AI Agent 插件和工作流编排，实现产品管理任务的自动化与增强。

### 核心特性

- **五层工作流架构** — 从需求感知到价值验证的完整闭环
- **场景驱动 PRD 生成** — 迭代更新/新功能/0-1 产品，拒绝随意 YY
- **行业基准校验** — 自动对标最佳实践，确保方案专业度
- **人机协作模式** — Autopilot / Copilot / Manual 灵活切换

## 快速开始

### 前置要求

- [Claude Code](https://claude.ai/code) CLI 工具
- 将此仓库克隆到本地项目目录

### 安装

```bash
git clone https://github.com/kelegele/oh-my-pm.git
cd oh-my-pm
```

### 使用

在 Claude Code 中直接对话即可触发相关 Skill：

```bash
# 示例对话
"帮我分析一下 Notion 和飞书文档的竞品差异"
"写一个用户个人中心改版的 PRD，这是当前页面截图..."
"快速生成一个带竞品分析的需求文档"
```

## 五层架构

```
┌─────────────────────────────────────────────────┐
│  第一层：需求感知 (Perception)                   │
│  market-intelligence | user-research           │
│  competitive-analysis | data-monitoring         │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  第二层：策略规划 (Strategy)                     │
│  product-positioning | roadmap-planning        │
│  prioritization                                 │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  第三层：方案设计 (Design)                       │
│  prd-gen | prototype-design                     │
│  process-optimization                           │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  第四层：交付协调 (Delivery)                     │
│  requirement-review | project-coordination     │
│  release-management                             │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  第五层：价值验证 (Validation)                   │
│  impact-analysis | feedback-synthesis          │
│  iteration-planning ──→ 反馈闭环                │
└─────────────────────────────────────────────────┘
```

## 核心 Skills

### MVP 已实现 (v0.1.0)

| Skill | 功能 | 触发方式 |
|:-----|:-----|:---------|
| `/competitive-analysis` | 竞品功能对比分析 | "分析竞品"、"对比 XX 和 YY" |
| `/prd-gen` | 结构化 PRD 生成 | "写 PRD"、"需求文档" |
| `/iteration-planning` | 基于反馈的迭代规划 | "迭代规划"、"版本排期" |
| `/quick-prd` | 竞品分析 + PRD 一体化工作流 | "快速 PRD"、"带竞品分析的需求" |

### 规划中 (v0.2.0+)

- **Perception**: `market-intelligence`, `user-research`, `data-monitoring`
- **Strategy**: `product-positioning`, `roadmap-planning`, `prioritization`
- **Design**: `prototype-design`, `process-optimization`
- **Delivery**: `requirement-review`, `project-coordination`, `release-management`
- **Validation**: `impact-analysis`, `feedback-synthesis`

## PRD 生成的三种场景

`/prd-gen` 和 `/quick-prd` 现在支持智能场景识别：

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 当前功能描述 + UI 状态 + 迭代目标 | 截图 / HTML 文件 / 在线链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 context/ 读取或用户输入 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

**核心原则**：不随意 YY，基于行业最佳实践输出。

## 目录结构

```
oh-my-pm/
├── skills/                      # Skill 插件目录
│   ├── perception/              # 需求感知层
│   ├── strategy/                # 策略规划层
│   ├── design/                  # 方案设计层
│   ├── delivery/                # 交付协调层
│   ├── validation/              # 价值验证层
│   └── workflows/               # 工作流编排器
├── context/                     # 上下文传递目录
│   ├── competitive-analysis/    # 竞品分析输出
│   ├── prd/                     # PRD 文档输出
│   └── current-workflow.json    # 工作流状态
├── docs/                        # 设计文档
├── tests/                       # 测试脚本
└── CLAUDE.md                    # 项目配置
```

## 人机协作模式

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:---------|
| `autopilot` | AI 自动执行，人工仅审阅 | 数据监控、报告生成 |
| `copilot` | AI 建议，人工决策确认 | PRD 生成、方案设计 |
| `manual` | 人工主导，AI 辅助 | 战略决策、创意工作 |

## 贡献指南

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 开发路线图

查看 [Project Board](https://github.com/users/kelegele/projects/4) 或 [docs/roadmap.md](docs/roadmap.md) 了解完整规划。

| 版本 | 目标 | 状态 |
|:-----|:-----|:-----|
| v0.1.0 | MVP (4 Skills) | ✅ |
| v0.2.0 | Design Layer 扩展 | 🔄 |
| v0.3.0 | Perception Layer | ⏳ |
| v0.4.0 | Strategy Layer | ⏳ |
| v0.5.0 | Delivery Layer | ⏳ |
| v0.6.0 | Validation Layer 扩展 | ⏳ |
| v1.0.0 | Full Cycle Workflow | ⏳ |

## 许可证

[MIT License](LICENSE)

---

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)
