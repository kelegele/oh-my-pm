# Oh-My-PM Plugin for Claude Code

> 面向产品经理的 AI Agent 工作流系统 — 完整产品管理闭环

## 插件概述

Oh-My-PM 是一套基于 **Claude Code Skill** 插件的产品经理工作流系统。它不构建独立的 SaaS 平台，而是通过 AI Agent 插件和工作流编排，实现产品管理任务的自动化与增强。

## 安装

### 方式一：克隆到本地

```bash
# 克隆仓库到本地项目目录
git clone https://github.com/kelegele/oh-my-pm.git

# 或克隆到 Claude Code 插件目录
mkdir -p ~/.claude/plugins
git clone https://github.com/kelegele/oh-my-pm.git ~/.claude/plugins/oh-my-pm
```

### 方式二：符号链接

```bash
# 如果已有项目仓库，创建符号链接
ln -s /path/to/oh-my-pm ~/.claude/plugins/oh-my-pm
```

## 架构概览

```
┌─────────────────────────────────────────────────────────────┐
│  第一层：需求感知 (Perception)     4 Skills                  │
│  market-intelligence · user-research · competitive-analysis │
│  data-monitoring                                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第二层：策略规划 (Strategy)       3 Skills                  │
│  product-positioning · roadmap-planning · prioritization     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第三层：方案设计 (Design)         3 Skills                  │
│  prd-gen · prototype-design · process-optimization           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第四层：交付协调 (Delivery)       3 Skills                  │
│  requirement-review · project-coordination · release-mgmt    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  第五层：价值验证 (Validation)     3 Skills                  │
│  impact-analysis · feedback-synthesis · iteration-planning   │
└─────────────────────────────────────────────────────────────┘
```

## 可用 Skills

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

## 使用方式

### 直接对话触发

在 Claude Code 中直接对话，系统会自动识别并调用相应 Skill：

```bash
# 示例对话
"帮我分析一下 Notion 和飞书文档的竞品差异"
"写一个用户个人中心改版的 PRD"
"快速生成一个带竞品分析的需求文档"
"分析我们上周发布的功能效果"
```

### 显式调用 Skill

使用 `/` 前缀显式调用特定 Skill：

```bash
/competitive-analysis 分析 Notion vs 飞书
/prd-gen 生成用户中心改版需求文档
/full-pm-cycle 规划一个新的项目管理工具
```

## 人机协作模式

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:---------|
| `autopilot` | AI 自动执行，人工仅审阅 | 数据监控、报告生成 |
| `copilot` | AI 建议，人工决策确认 | PRD 生成、方案设计 |
| `manual` | 人工主导，AI 辅助 | 战略决策、创意工作 |

## 上下文文件

系统通过 `context/` 目录在 Skills 之间传递数据：

```
context/
├── current-workflow.json      # 当前工作流状态
├── market-analysis.json       # 市场分析结果
├── user-research.json         # 用户研究结果
├── competitive-analysis/      # 竞品分析文件
├── positioning.md             # 产品定位声明
├── roadmap.md                 # 产品路线图
├── prioritization.json        # 优先级排序结果
├── prd/                       # PRD 文档
├── impact-analysis.json       # 效果分析结果
└── feedback-synthesis.json    # 反馈汇总结果
```

## PRD 生成的三种场景

`/prd-gen` 支持智能场景识别：

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 功能描述 + UI 状态 + 迭代目标 | 截图 / HTML / 链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 context/ 读取 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

## 版本历史

### v0.2.0 (2026-03-12)
- 完整五层架构 (19 Skills)
- 三个工作流编排器
- 场景驱动 PRD 生成

### v0.1.0 (2026-03-11)
- MVP 版本 (4 Skills)
- 基础上下文传递

## 开源协议

[MIT License](../LICENSE)

---

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)
