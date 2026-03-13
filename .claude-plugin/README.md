# Oh-My-PM Plugin for Claude Code

> 面向产品经理的 AI Agent 工作流系统 — 完整产品管理闭环

## 插件概述

Oh-My-PM 是一套基于 **Claude Code Skill** 插件的产品经理工作流系统。通过 **20 个专业 Skills** + **8 个 Subagents** + **4 个 Commands**，实现从需求感知到价值验证的完整产品管理闭环。

### 核心特性

| 特性 | 说明 |
|:-----|:-----|
| **五层工作流架构** | 需求感知 → 策略规划 → 方案设计 → 交付协调 → 价值验证 |
| **场景驱动 PRD** | 迭代更新/新功能/0-1 产品，基于行业最佳实践 |
| **Figma 原型集成** | PRD 后自动生成 Figma 原型图 |
| **Subagent 记忆系统** | 8 个独立 Subagent，支持跨会话知识积累 |
| **人机协作模式** | Autopilot / Copilot / Manual 灵活切换 |

## 安装

```bash
# 克隆仓库
git clone https://github.com/kelegele/oh-my-pm.git
cd oh-my-pm

# 通过 --plugin-dir 加载
claude --plugin-dir /path/to/oh-my-pm
```

> **注意**：Skills 通过自然语言自动触发，无需手动配置。

---

# 全部 Skills (20 个)

## 📊 需求感知层 (Perception) - 4 个

| Skill | 功能描述 | 触发示例 |
|:-----|:---------|:---------|
| **competitive-analysis** | 竞品功能对比分析，生成对比矩阵和差异化建议 | "分析竞品"、"对比淘宝和京东" |
| **market-intelligence** | 市场情报收集，识别行业趋势和市场机会 | "市场分析"、"AI 写助手市场规模" |
| **user-research** | 用户研究与画像创建，设计访谈脚本 | "用户访谈"、"创建目标用户画像" |
| **data-monitoring** | 产品指标监控与异常检测，建立数据基线 | "监控指标"、"DAU 突然下降" |

## 🎯 策略规划层 (Strategy) - 3 个

| Skill | 功能描述 | 触发示例 |
|:-----|:---------|:---------|
| **product-positioning** | 产品定位与差异化策略，撰写定位声明 | "产品定位"、"我们的差异化优势" |
| **roadmap-planning** | 产品路线图规划，定义里程碑和时间表 | "产品路线图"、"Q2 版本规划" |
| **prioritization** | 需求优先级排序 (RICE/MoSCoW 框架) | "优先级排序"、"这些需求怎么排" |

## 🎨 方案设计层 (Design) - 4 个

| Skill | 功能描述 | 触发示例 |
|:-----|:---------|:---------|
| **prd-gen** | 结构化 PRD 生成，支持三种场景识别 | "写 PRD"、"生成需求文档" |
| **figma-prototype** | Figma 原型图生成，支持迭代/新产品两种模式 | "生成原型"、"创建 Figma 设计" |
| **prototype-design** | 原型设计与交互流程规划 | "设计原型"、"UI 流程设计" |
| **process-optimization** | 业务流程分析与优化建议 | "流程优化"、"如何提效" |

## 🚢 交付协调层 (Delivery) - 3 个

| Skill | 功能描述 | 触发示例 |
|:-----|:---------|:---------|
| **requirement-review** | 需求评审会议组织，干系人对齐 | "需求评审"、"PRD 评审会议" |
| **project-coordination** | 项目进度跟踪与风险管理 | "项目状态"、"进度更新" |
| **release-management** | 发布计划制定与上线检查清单 | "发布计划"、"上线检查" |

## 📈 价值验证层 (Validation) - 3 个

| Skill | 功能描述 | 触发示例 |
|:-----|:---------|:---------|
| **impact-analysis** | 上线效果分析，目标达成度评估 | "效果分析"、"上线复盘" |
| **feedback-synthesis** | 用户反馈汇总与主题分析 | "用户反馈"、"分析 App Store 评论" |
| **iteration-planning** | 基于数据的迭代规划 | "迭代规划"、"Sprint 排期" |

## 🔄 工作流编排器 (Workflows) - 3 个

| Workflow | 功能描述 | 触发示例 |
|:---------|:---------|:---------|
| **quick-prd** | 竞品分析 + PRD 一体化工作流 | "快速 PRD"、"带竞品分析的需求" |
| **full-pm-cycle** | 完整产品管理周期 (0-1 产品) | "完整产品规划"、"规划新工具" |
| **feature-launch** | 功能发布端到端工作流 | "功能发布"、"发布协调" |

---

# 全部 Subagents (8 个)

## 📊 感知层 Subagents (4 个)

| Subagent | 模型 | 功能描述 | 触发示例 |
|:---------|:-----|:---------|:---------|
| **market-researcher** | haiku | 市场研究专家，工作树隔离 | "分析 AI 市场规模"、"行业趋势" |
| **competitive-analyst** | sonnet | 竞品分析专家，支持 GitHub 代码分析 | "竞品分析"、"对比 Notion 和飞书" |
| **user-interviewer** | sonnet | 用户研究专家，维护用户研究记忆 | "创建用户画像"、"用户访谈" |
| **data-monitor** | haiku | 数据监控专家，后台持续运行 | "监控指标"、"数据看板异常" |

## 🎨 设计层 Subagents (1 个)

| Subagent | 模型 | 功能描述 | 触发示例 |
|:---------|:-----|:---------|:---------|
| **process-optimizer** | sonnet | 流程优化专家，只读模式分析 | "流程优化"、"提效方案" |

## 📈 验证层 Subagents (2 个)

| Subagent | 模型 | 功能描述 | 触发示例 |
|:---------|:-----|:---------|:---------|
| **impact-analyst** | sonnet | 效果分析专家 | "上线效果"、"如何表现" |
| **feedback-collector** | haiku | 反馈汇总专家 | "用户反馈"、"用户说什么" |

## 🔄 工作流 Subagents (1 个)

| Subagent | 功能描述 | 触发示例 |
|:---------|:---------|:---------|
| **pm-orchestrator** | 协调完整 PM 周期，支持并行执行 | "完整产品规划"、"0-1 产品" |

### Subagent 记忆系统

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

---

# 全部 Commands (4 个)

## 快速工作流命令

| Command | 功能描述 | 使用示例 |
|:--------|:---------|:---------|
| **/quick-prd** | 快速生成带竞品分析的 PRD | `/quick-prd "用户改版" 淘宝 京东` |
| **/full-pm-cycle** | 完整产品管理周期 (0-1) | `/full-pm-cycle "新项目管理工具"` |
| **/feature-launch** | 功能发布工作流 | `/feature-launch "用户注册流程"` |
| **/ompm** | 命名空间分发器 | `/ompm quick-prd "..."` 或 `/ompm help` |

## 调用方式

### 直接调用
```bash
/quick-prd "用户个人中心改版" 淘宝 京东
/full-pm-cycle "新项目管理工具"
/feature-launch "用户注册流程"
```

### 命名空间调用
```bash
/ompm quick-prd "暗黑模式"
/ompm full-pm-cycle "AI 助手功能"
/ompm feature-launch "购物车改版"
/ompm help  # 显示帮助信息
```

---

# 使用方式

## Commands（直接调用）

4 个工作流 Commands 可直接调用：

```bash
/quick-prd "用户改版" 淘宝 京东
/full-pm-cycle "新项目管理工具"
/feature-launch "用户注册流程"

# 命名空间调用
/ompm quick-prd "暗黑模式"
/ompm full-pm-cycle "AI 助手功能"
/ompm help
```

## Skills（自然语言触发）

20 个 Skills 通过自然语言自动触发：

```bash
# 直接对话，系统自动识别并调用相应 Skill
"帮我分析一下 Notion 和飞书文档的竞品差异"    # → competitive-analysis
"写一个用户个人中心改版的 PRD"                # → prd-gen
"快速生成一个带竞品分析的需求文档"              # → quick-prd workflow
"分析我们上周发布的功能效果"                    # → impact-analysis
"我们的产品应该如何定位"                      # → product-positioning
```

> **注意**：Skills 不支持 `/skill-name` 格式的显式调用，只能通过自然语言或工作流触发。

---

# 人机协作模式

| 模式 | 描述 | 适用场景 |
|:-----|:-----|:---------|
| **autopilot** | AI 自动执行，人工仅审阅 | 数据监控、报告生成 |
| **copilot** | AI 建议，人工决策确认 | PRD 生成、方案设计 |
| **manual** | 人工主导，AI 辅助 | 战略决策、创意工作 |

---

# PRD 生成的三种场景

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 功能描述 + UI 状态 + 迭代目标 | 截图 / HTML / 链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 context/ 读取 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

**核心原则**：不随意 YY，基于行业最佳实践输出。

---

# Figma 原型生成

PRD 生成后可自动生成 Figma 原型图：

### 两种模式

| 模式 | 要求 | 说明 |
|:-----|:-----|:-----|
| **迭代更新** | 当前 UI 截图/HTML/链接 | 匹配现有风格，标注修改点 |
| **新功能/新产品** | 设计参考/组件库 | 基于参考生成，严禁凭空想象 |

### 修改标注

- 🟢 绿色 = 新增
- 🟡 黄色 = 修改
- 🔴 红色 = 删除

---

# 版本历史

### v0.4.0 (2026-03-13)
- Figma MCP 集成
- 20 个 Skills (新增 figma-prototype)
- Commands 支持 (4 个命令)
- 双调用模式 (直接 + 命名空间)

### v0.3.0 (2026-03-12)
- Subagent 混合架构
- 8 个 Subagents + 记忆系统

### v0.2.0 (2026-03-12)
- 完整五层架构 (19 Skills)
- 三个工作流编排器

### v0.1.0 (2026-03-11)
- MVP 版本 (4 Skills)

---

# 开源协议

[MIT License](../LICENSE)

---

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)
