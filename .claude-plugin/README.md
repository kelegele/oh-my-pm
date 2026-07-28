# Oh-My-PM Plugin for Claude Code / Codex

> 面向产品经理的 AI Agent 工作流系统 — 完整产品管理闭环

## 插件概述

Oh-My-PM 是一套基于 **Skills 插件**的产品经理工作流系统，可安装到 Claude Code 和 Codex。通过 **20 个专业 Skills**（17 个领域 Skills + 3 个工作流编排）+ **8 个 Subagents** + **4 个 Commands**，实现从需求感知到价值验证的完整产品管理闭环。

当前版本：**0.9.4**（权威版本源见 `plugin.json`）

### 核心特性

| 特性 | 说明 |
|:-----|:-----|
| **五层工作流架构** | 需求感知 → 策略规划 → 方案设计 → 交付协调 → 价值验证 |
| **Plan-and-Execute 模式** | 完整的阶段定义、状态追踪和质量门控（Stage Gates） |
| **Subagent 记忆系统** | 8 个独立 Subagent，支持跨会话知识积累 |
| **HTML 原型输出** | 原型设计直接生成 HTML，无需外部设计工具 |

---

## 快速开始

### 方式一：直接使用 Commands（推荐新手）

```bash
# 快速 PRD（最常用）
/quick-prd "用户个人中心改版" 淘宝 京东

# 完整产品规划（0-1 产品）
/full-pm-cycle "新项目管理工具"

# 功能发布
/feature-launch "用户注册流程"
```

### 方式二：自然语言调用 Skills

直接对话，系统自动识别并调用相应 Skill：

```bash
"帮我分析一下 Notion 和飞书文档的竞品差异"    # → competitive-analysis
"写一个用户个人中心改版的 PRD"                # → prd-gen
"分析我们上周发布的功能效果"                    # → impact-analysis
```

---

## 建议使用流程

### 流程一：快速 PRD（最常用）

**适用场景**：功能迭代改版、新增功能模块、需要快速输出 PRD

**使用指令**：`/quick-prd "需求描述" [竞品...]`

**流程说明**：
```
场景识别 → 竞品分析（可选）→ 策略确认门控 → PRD 生成
```

**调用的 Skills 和 Subagents**：

| 步骤 | 调用 Skill | 调用 Subagent | 说明 |
|:-----|:----------|:--------------|:-----|
| 1. 场景识别 | `quick-prd` | - | 自动识别迭代/新功能/0-1产品场景 |
| 2. 竞品分析 | `competitive-analysis` | `competitive-analyst` | 对比竞品功能（可选） |
| 3. PRD 生成 | `prd-gen` | - | 生成结构化 PRD 文档 |

**使用示例**：
```bash
# 带竞品分析
/quick-prd "用户个人中心改版" 淘宝 京东

# 不带竞品分析
/quick-prd "暗黑模式功能"
```

---

### 流程二：完整产品规划（0-1）

**适用场景**：新产品从 0 到 1、完整产品战略规划、需要全流程分析

**使用指令**：`/full-pm-cycle "产品名称"`

**流程说明**：
```
市场研究 → 用户研究 → 竞品分析 → 产品定位
    ↓
路线图规划 → 优先级排序
    ↓
PRD 生成 → 原型设计
    ↓
需求评审 → 项目协调 → 发布管理
    ↓
效果分析 → 反馈汇总 → 迭代规划
```

**调用的 Skills 和 Subagents**：

| 阶段 | 调用 Skills | 调用 Subagents |
|:-----|:-----------|:--------------|
| **感知层** | `competitive-analysis`, `user-research`, `market-intelligence` | `competitive-analyst`, `user-interviewer`, `market-researcher` |
| **策略层** | `product-positioning`, `roadmap-planning`, `prioritization` | - |
| **设计层** | `prd-gen`, `prototype-design` | - |
| **交付层** | `requirement-review`, `project-coordination`, `release-management` | - |
| **验证层** | `impact-analysis`, `feedback-synthesis`, `iteration-planning` | `impact-analyst`, `feedback-collector` |

**使用示例**：
```bash
/full-pm-cycle "新项目管理工具"
```

---

### 流程三：功能发布

**适用场景**：功能即将上线、需要发布协调、上线后效果评估

**使用指令**：`/feature-launch "功能名称"`

**流程说明**：
```
PRD 完善 → 需求评审 → 项目规划
    ↓
发布计划 → 上线执行
    ↓
效果分析 → 反馈汇总
```

**调用的 Skills 和 Subagents**：

| 阶段 | 调用 Skills | 调用 Subagents |
|:-----|:-----------|:--------------|
| **准备阶段** | `requirement-review`, `project-coordination` | - |
| **发布阶段** | `release-management` | - |
| **验证阶段** | `impact-analysis`, `feedback-synthesis` | `impact-analyst`, `feedback-collector` |

**使用示例**：
```bash
/feature-launch "用户注册流程"
```

---

## 全部 Skills (20 个)

### 可独立使用的领域 Skills (17 个)

以下 Skills 可单独调用，无需依赖其他 Skills，适合单点任务：

#### 📊 需求感知层 (Perception) - 5 个

| Skill | 可独立使用 | 功能描述 | 适用场景 |
|:-----|:----------:|:---------|:---------|
| **competitive-analysis** | ✅ | 竞品功能对比分析，生成对比矩阵和差异化建议 | 需要了解竞品功能、做差异化分析 |
| **market-intelligence** | ✅ | 市场情报收集，识别行业趋势和市场机会 | 评估市场规模、分析行业趋势 |
| **user-research** | ✅ | 用户研究与画像创建，设计访谈脚本 | 创建用户画像、设计访谈问题 |
| **data-monitoring** | ✅ | 产品指标监控与异常检测，建立数据基线 | 监控 DAU/转化率、分析数据异常 |
| **clarify-requirements** | ✅ | 需求澄清，系统性识别缺失信息并逐步确认 | 需求描述不完整、生成 PRD 前先梳理需求 |

**触发示例**：
- "分析淘宝和京东的个人中心功能"
- "AI 写作助手的市场规模有多大"
- "帮我创建目标用户画像"
- "DAU 突然下降了，帮我分析"
- "帮我梳理一下需求，看看还缺什么信息"

---

#### 🎯 策略规划层 (Strategy) - 3 个

| Skill | 可独立使用 | 功能描述 | 适用场景 |
|:-----|:----------:|:---------|:---------|
| **product-positioning** | ✅ | 产品定位与差异化策略，撰写定位声明 | 明确产品定位、梳理差异化优势 |
| **roadmap-planning** | ✅ | 产品路线图规划，定义里程碑和时间表 | 制定产品路线图、版本规划 |
| **prioritization** | ✅ | 需求优先级排序 (RICE/MoSCoW 框架) | 对需求池进行优先级排序 |

**触发示例**：
- "我们的产品应该如何定位"
- "帮我规划 Q2 的产品路线图"
- "这些需求怎么排优先级"

---

#### 🎨 方案设计层 (Design) - 3 个

| Skill | 可独立使用 | 功能描述 | 适用场景 |
|:-----|:----------:|:---------|:---------|
| **prd-gen** | ✅ | 结构化 PRD 生成，支持三种场景识别 | 快速生成 PRD 文档 |
| **prototype-design** | ✅ | 交互式 HTML 原型设计，验证设计方案 | 创建原型、设计用户流程 |
| **process-optimization** | ✅ | 业务流程分析与优化建议 | 优化业务流程、提升效率 |

**触发示例**：
- "写一个用户改版的 PRD"
- "设计这个功能的交互原型"
- "优化我们的代码审查流程"

---

#### 🚢 交付协调层 (Delivery) - 3 个

| Skill | 可独立使用 | 功能描述 | 适用场景 |
|:-----|:----------:|:---------|:---------|
| **requirement-review** | ✅ | 需求评审会议组织，干系人对齐 | 组织需求评审会议 |
| **project-coordination** | ✅ | 项目进度跟踪与风险管理 | 跟踪项目进度、识别风险 |
| **release-management** | ✅ | 发布计划制定与上线检查清单 | 制定发布计划、准备上线检查 |

**触发示例**：
- "组织 PRD 评审会议"
- "项目现在的状态怎么样"
- "准备发布计划"

---

#### 📈 价值验证层 (Validation) - 3 个

| Skill | 可独立使用 | 功能描述 | 适用场景 |
|:-----|:----------:|:---------|:---------|
| **impact-analysis** | ✅ | 上线效果分析，目标达成度评估 | 分析功能上线效果 |
| **feedback-synthesis** | ✅ | 用户反馈汇总与主题分析 | 汇总分析用户反馈 |
| **iteration-planning** | ✅ | 基于数据的迭代规划 | 规划下一个迭代 |

**触发示例**：
- "分析上周上线的功能效果"
- "用户对我们有什么反馈"
- "规划下一个 Sprint"

---

### 工作流编排 Skills (3 个)

以下 Skills 编排多个 Skills 和 Subagents，适合完整场景，不需要手动调用单个 Skill：

| Workflow | 编排内容 | 调用的 Subagents | 适用场景 |
|:---------|:---------|:----------------|:---------|
| **quick-prd** | 竞品分析 + PRD 生成（含策略确认门控） | `competitive-analyst` | 快速输出带竞品上下文的 PRD |
| **full-pm-cycle** | 完整五层：感知→策略→设计→交付→验证 | 全部 8 个 Subagents | 新产品从 0 到 1 规划 |
| **feature-launch** | PRD 完善 + 评审 + 发布 + 效果分析 | `impact-analyst`, `feedback-collector` | 功能发布端到端协调 |

**使用建议**：
- 日常 PRD 任务用 `quick-prd`
- 新产品规划用 `full-pm-cycle`
- 功能上线用 `feature-launch`

---

## 全部 Subagents (8 个)

Subagents 是独立运行的 AI 代理，支持隔离执行和记忆积累，会被 Skills 自动调用。

### 📊 感知层 Subagents (4 个)

| Subagent | 模型 | 被 Skill 调用 | 功能描述 |
|:---------|:-----|:-------------|:---------|
| **market-researcher** | haiku | `market-intelligence` | 市场研究专家，分析市场规模和趋势 |
| **competitive-analyst** | sonnet | `competitive-analysis` | 竞品分析专家，支持 GitHub 代码分析 |
| **user-interviewer** | sonnet | `user-research` | 用户研究专家，创建用户画像 |
| **data-monitor** | haiku | `data-monitoring` | 数据监控专家，后台持续运行 |

### 🎨 设计层 Subagents (1 个)

| Subagent | 模型 | 被 Skill 调用 | 功能描述 |
|:---------|:-----|:-------------|:---------|
| **process-optimizer** | sonnet | `process-optimization` | 流程优化专家，只读模式分析 |

### 📈 验证层 Subagents (2 个)

| Subagent | 模型 | 被 Skill 调用 | 功能描述 |
|:---------|:-----|:-------------|:---------|
| **impact-analyst** | sonnet | `impact-analysis` | 效果分析专家 |
| **feedback-collector** | haiku | `feedback-synthesis` | 反馈汇总专家 |

### 🔄 工作流 Subagents (1 个)

| Subagent | 被 Skill 调用 | 功能描述 |
|:---------|:-------------|:---------|
| **pm-orchestrator** | `full-pm-cycle` | 协调完整 PM 周期，支持并行执行 |

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

## 全部 Commands (4 个)

### 快速工作流命令

| Command | 调用 Workflow | 功能描述 | 使用示例 |
|:--------|:-------------|:---------|:---------|
| **/quick-prd** | `quick-prd` | 快速生成带竞品分析的 PRD | `/quick-prd "用户改版" 淘宝 京东` |
| **/full-pm-cycle** | `full-pm-cycle` | 完整产品管理周期 (0-1) | `/full-pm-cycle "新项目管理工具"` |
| **/feature-launch** | `feature-launch` | 功能发布工作流 | `/feature-launch "用户注册流程"` |
| **/ompm** | - | 命名空间分发器 | `/ompm quick-prd "..."` 或 `/ompm help` |

### 调用方式

#### 直接调用
```bash
/quick-prd "用户个人中心改版" 淘宝 京东
/full-pm-cycle "新项目管理工具"
/feature-launch "用户注册流程"
```

#### 命名空间调用
```bash
/ompm quick-prd "暗黑模式"
/ompm full-pm-cycle "AI 助手功能"
/ompm feature-launch "购物车改版"
/ompm help  # 显示帮助信息
```

---

## 上下文文件约定

Skills 之间通过机器可读的中间产物传递上下文，统一采用扁平式 **`docs/product/.ompm/<name>.json`** 命名；人类可读文档（PRD、定位、路线图等）放在 `docs/product/` 下：

| 文件 | 产出层 | 流向 |
|:-----|:------|:-----|
| `.ompm/competitive-analysis.json` | 感知 | → prd-gen, positioning |
| `.ompm/market-analysis.json` | 感知 | → positioning |
| `.ompm/user-research.json` | 感知 | → positioning |
| `.ompm/clarification-result.json` | 感知 | → prd-gen |
| `.ompm/prioritization.json` | 策略 | → design, delivery |
| `.ompm/impact-analysis.json` | 验证 | → iteration-planning |
| `.ompm/feedback-synthesis.json` | 验证 | → iteration-planning |
| `.ompm/iteration-plan.json` | 验证 | → 下一周期 |
| `.ompm/current-workflow.json` | 全部 | 工作流状态追踪 |

---

## 安装

```bash
# 从 GitHub 安装
npx skills add kelegele/oh-my-pm -a claude-code   # Claude Code
npx skills add kelegele/oh-my-pm -a codex          # Codex

# 从本地仓库安装
npx skills add . -a claude-code
npx skills add . -a codex
```

> **注意**：Skills 通过自然语言自动触发，无需手动配置。

---

# PRD 生成的三种场景

| 场景 | 必需信息 | UI 提取方式 |
|:-----|:---------|:-----------|
| **迭代更新** | 功能描述 + UI 状态 + 迭代目标 | 截图 / HTML / 链接 |
| **新功能** | 产品架构 + 设计规范 + 入口位置 | 从 docs/product/ 读取 |
| **0-1 新产品** | 产品背景 + 资源约束 + 参考产品 | 用户输入 + 竞品分析 |

**核心原则**：不随意 YY，基于行业最佳实践输出。

---

# 原型设计（prototype-design）

直接生成 **HTML 原型**，支持两种模式：

| 模式 | 要求 | 说明 |
|:-----|:-----|:-----|
| **迭代模式** | 当前 UI 截图/HTML/链接 | 匹配现有风格，标注修改点 |
| **新产品模式** | 设计参考/组件库 | 基于参考生成，严禁凭空想象 |

### 修改标注

- 🟢 绿色 = 新增
- 🟡 黄色 = 修改
- 🔴 红色 = 删除

---

# 版本历史

当前版本 **0.9.4**，完整版本历史见 [CHANGELOG.md](../CHANGELOG.md)。

---

# 开源协议

[MIT License](../LICENSE)

---

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)
