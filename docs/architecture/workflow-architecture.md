# Oh-My-PM 工作流架构 (v1.0.0)

Oh-My-PM 采用 **三层主线（感知 → 策略 → 设计）+ 验证辅助** 的架构 + **Plan-and-Execute 模式**，覆盖完整产品管理闭环。原交付层已取消：PRD 预审并入 `prd-gen` 尾门，发布 checklist / 灰度策略并入 `feature-launch`。

## 架构总览

```mermaid
graph TB
    subgraph L1["1. Perception 需求感知（主线）"]
        A1["market-research\n市场 + 用户研究"]
        A2["competitive-analysis\n竞品分析"]
        A3["clarify-requirements\n需求澄清"]
    end

    subgraph L2["2. Strategy 策略规划（主线）"]
        B1["product-strategy\n定位 · 优先级 · 路线图"]
    end

    subgraph L3["3. Design 方案设计（主线）"]
        C1["prd-gen\nPRD 生成（含预审尾门）"]
        C2["prototype-design\n原型设计"]
    end

    subgraph V["Validation 价值验证（辅助）"]
        E1["retrospective\n效果复盘 + 迭代规划"]
        E2["feedback-synthesis\n反馈综合"]
    end

    L1 -->|"docs/product/"| L2
    L2 -->|"docs/product/"| L3
    L3 -->|"docs/product/"| V
    V -.->|"反馈循环"| L1
```

## 用户对话流

用户通过 **自然语言** 或 **Command** 触发，系统自动识别并路由到对应 Skill。

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant SK as Skill Router
    participant CTX as docs/product/ 目录
    participant SA as Subagent

    U->>CC: "分析 Notion vs 飞书的差异"
    CC->>SK: 识别触发词 → competitive-analysis
    SK->>SA: 委托 competitive-analyst (Sonnet)
    SA->>SA: GitHub 代码分析 + 功能对比
    SA->>CTX: 写入 docs/product/.ompm/competitive-analysis.json
    SA-->>CC: 返回对比矩阵
    CC-->>U: 展示竞品分析结果

    U->>CC: "基于这个分析写 PRD"
    CC->>SK: 识别触发词 → prd-gen
    SK->>CTX: 读取 .ompm/competitive-analysis.json
    SK->>SK: 识别场景：迭代/新功能/0-1
    SK-->>CC: 生成 PRD 文档
    CC->>CTX: 写入 docs/product/prd/feature-name.md
    CC-->>U: 展示 PRD 内容

    U->>CC: "帮我设计原型"
    CC->>SK: 识别触发词 → prototype-design
    SK->>CTX: 读取 prd/*.md
    SK-->>CC: 生成 HTML 原型
    CC->>CTX: 写入 docs/product/prototypes/*.html
    CC-->>U: 返回 HTML 原型链接
```

## Command 工作流详解

4 个 Command 中，`/ompm` 是**全局意图路由**：无参数或自然语言输入时，读取当前对话上下文 + `docs/product/.ompm/current-workflow.json`，判断"当前最有价值的下一步"并说明理由；输入 workflow 名（`quick-prd` / `full-pm-cycle` / `feature-launch`）时直派到对应工作流，`/quick-prd` 等裸命令是等价的简写形式。

### /quick-prd — 竞品分析 + PRD

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant CA as competitive-analysis
    participant PG as prd-gen
    participant CTX as docs/product/

    U->>CC: /quick-prd "用户中心改版" 淘宝 京东
    CC->>CA: 启动竞品分析流程
    CA->>CA: 分析淘宝/京东用户中心功能
    CA->>CTX: 写入 .ompm/competitive-analysis.json
    CA-->>CC: 输出对比矩阵
    CC->>PG: 传入竞品分析结果 + 需求描述
    PG->>CTX: 读取 .ompm/competitive-analysis.json
    PG->>PG: 生成 8 章节 PRD
    PG->>CTX: 写入 prd/user-center-redesign.md
    PG-->>CC: 返回 PRD 文档
    CC-->>U: 展示 PRD 结果
```

### /full-pm-cycle — 完整产品管理周期

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant PM as pm-orchestrator (Sonnet)
    participant MR as market-researcher (Haiku)
    participant CA as competitive-analyst (Sonnet)
    participant UI as user-interviewer (Sonnet)
    participant PS as product-strategy
    participant PG as prd-gen
    participant PD as prototype-design
    participant CTX as docs/product/

    U->>CC: /full-pm-cycle "项目管理工具"
    CC->>PM: 启动完整 PM 周期编排

    Note over PM,CTX: 阶段 1: 需求感知 (并行执行)
    PM->>MR: market-researcher 分析市场
    PM->>CA: competitive-analyst 分析竞品
    PM->>UI: user-interviewer 创建画像
    MR->>CTX: 写入 .ompm/market-analysis.json
    CA->>CTX: 写入 .ompm/competitive-analysis.json
    UI->>CTX: 写入 .ompm/user-research.json

    Note over PM,CTX: 阶段 2: 策略规划
    PM->>PS: 基于感知层输出定策略
    PS->>CTX: 读取 market-analysis + competitive + user-research
    PS->>CTX: 写入 positioning.md → .ompm/prioritization.json → roadmap.md

    Note over PM,CTX: 阶段 3: 方案设计
    PM->>PG: 基于策略输出写 PRD（尾门含预审）
    PG->>CTX: 读取 positioning + roadmap + priorities
    PG->>CTX: 写入 prd/project-mgmt.md
    PM->>PD: 基于 PRD 生成原型
    PD->>CTX: 读取 prd/*.md → prototypes/*.html

    PM-->>CC: 完整周期完成，更新 .ompm/current-workflow.json
    CC-->>U: 展示完整产物清单
```

### /feature-launch — 功能发布工作流

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant PG as prd-gen (预审尾门)
    participant FL as feature-launch
    participant RT as retrospective
    participant FB as feedback-synthesis
    participant CTX as docs/product/

    U->>CC: /feature-launch "用户注册流程"
    CC->>PG: PRD 完善 + 预审尾门
    PG->>PG: 完整性检查 + 预审清单
    PG->>CTX: 更新 prd/[feature].md

    CC->>FL: 启动发布协调
    FL->>FL: 发布 checklist + 灰度策略
    FL->>CTX: 写入 release-plan-[feature].md

    Note over CC,CTX: 功能上线后 7-14 天
    CC->>RT: 启动效果复盘
    RT->>CTX: 读取目标指标
    RT->>CTX: 写入 .ompm/impact-analysis.json
    RT->>CTX: 写入 .ompm/iteration-plan.json

    CC->>FB: 启动反馈汇总
    FB->>CTX: 读取用户反馈
    FB->>CTX: 写入 .ompm/feedback-synthesis.json

    CC-->>U: 展示发布复盘报告
```

## 独立 Skill 使用流程

每个 Skill 可独立使用，不依赖工作流。

```mermaid
graph LR
    subgraph "触发方式"
        NL["自然语言\n\"帮我分析下市场趋势\""]
        CMD["Command\n/quick-prd \"需求\""]
    end

    subgraph "识别与路由"
        TRIGGER["触发词匹配"]
        ROUTER["Skill Router"]
    end

    subgraph "执行层"
        SKILL["Skill 执行"]
        SUBAGENT["Subagent 委托 (可选)"]
    end

    subgraph "输出"
        CTX["docs/product/ 文件写入"]
        RESP["对话响应"]
    end

    NL --> TRIGGER
    CMD --> TRIGGER
    TRIGGER --> ROUTER
    ROUTER -->|"需要深度分析"| SUBAGENT
    ROUTER -->|"直接执行"| SKILL
    SUBAGENT --> SKILL
    SKILL --> CTX
    SKILL --> RESP
```

## Subagent 委托架构

```mermaid
graph TB
    subgraph "Main Context (Claude Code)"
        MC["主对话上下文"]
    end

    subgraph "Subagent 委托"
        MR["market-researcher\nHaiku + worktree"]
        CA["competitive-analyst\nSonnet + GitHub"]
        UI["user-interviewer\nSonnet + memory"]
        IA["impact-analyst\nSonnet"]
        FC["feedback-collector\nHaiku"]
        PM["pm-orchestrator\nSonnet + parallel"]
    end

    subgraph "独立记忆"
        MEM1["market-researcher/MEMORY.md"]
        MEM2["competitive-analyst/MEMORY.md"]
        MEM3["user-interviewer/MEMORY.md"]
        MEM4["pm-orchestrator/MEMORY.md"]
    end

    MC -.->|"触发词匹配"| MR
    MC -.->|"触发词匹配"| CA
    MC -.->|"触发词匹配"| UI
    MC -.->|"触发词匹配"| IA
    MC -.->|"触发词匹配"| FC
    MC -.->|"触发词匹配"| PM

    MR --> MEM1
    CA --> MEM2
    UI --> MEM3
    PM --> MEM4
```

## Plan-and-Execute 模式

```mermaid
stateDiagram-v2
    [*] --> S0_Setup: 用户触发工作流
    S0_Setup --> S1_Perception: 创建 current-workflow.json
    S1_Perception --> S1_Quality: 执行感知层 Skills
    S1_Quality --> S2_Strategy: 质量门控通过
    S1_Quality --> S1_Perception: 需要补充数据

    S2_Strategy --> S2_Quality: 执行策略层 Skill
    S2_Quality --> S3_Design: 质量门控通过（策略确认硬门控）
    S2_Quality --> S2_Strategy: 需要调整策略

    S3_Design --> S3_Quality: 执行设计层 Skills（PRD 尾门含预审）
    S3_Quality --> S4_Validation: 质量门控通过
    S3_Quality --> S3_Design: PRD 需要修改

    S4_Validation --> S4_Quality: 执行验证层 Skills
    S4_Quality --> [*]: 完整周期完成
    S4_Quality --> S1_Perception: 反馈循环重启

    state S1_Quality <<choice>>
    state S2_Quality <<choice>>
    state S3_Quality <<choice>>
    state S4_Quality <<choice>>
```

### 阶段-层映射

| 阶段 | 层 | 执行内容 |
|:-----|:---|:---------|
| S0 Setup | — | 初始化 `current-workflow.json` |
| S1 Perception | 感知（主线 ①） | `market-research` · `competitive-analysis` · `clarify-requirements` |
| S2 Strategy | 策略（主线 ②） | `product-strategy`（策略确认硬门控） |
| S3 Design | 设计（主线 ③） | `prd-gen`（预审尾门） · `prototype-design` |
| S4 Validation | 验证（辅助） | `retrospective` · `feedback-synthesis` |

> 交付相关活动不再独立成阶段：PRD 预审是 `prd-gen` 的尾门（S3 内完成），发布 checklist / 灰度策略由 `feature-launch` 工作流承载。

## 质量门控标准

### Perception 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 市场与用户研究完成 | 市场规模和趋势分析 + 3+ 用户访谈、2+ 用户画像 | `market_size`, `growth_rate`, `personas_created`, `interviews_conducted` |
| 竞品分析完成 | 2+ 竞品功能对比 | `competitors_analyzed`, `matrix_complete` |

### Strategy 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 产品策略完成 | 定位声明 + RICE/MoSCoW 优先级排序 + 12 个月路线图 | `positioning_created`, `rice_scores_calculated`, `milestones_defined` |

### Design 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| PRD 完整并通过预审 | 8 章节 PRD 文档 + prd-gen 预审尾门通过 | `all_sections_complete`, `user_stories_mapped`, `prereview_passed` |
| 原型验证 | 原型生成 + 可用性确认 | `prototype_created`, `design_consistent` |

### Validation 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 效果复盘完成 | 上线 7-14 天目标达成分析 + 下轮迭代计划 | `goals_achieved`, `variance_analyzed`, `next_iteration_planned` |
| 反馈综合完成 | 用户反馈主题分析 | `themes_identified`, `improvements_mapped` |

> 交付相关检查不再独立设门：PRD 预审并入 Design 层 `prd-gen` 尾门；发布 checklist / 灰度策略检查由 `feature-launch` 工作流内部把关。

## 状态机

```mermaid
stateDiagram-v2
    [*] --> idle
    idle --> in_progress: 触发工作流/ Skill
    in_progress --> in_progress: 执行中 (切换层/Skill)
    in_progress --> blocked: 遇到阻塞
    blocked --> in_progress: 阻塞解除
    in_progress --> completed: 所有阶段完成
    completed --> idle: 等待下一次触发
```

## 版本历史

### v1.0.0
- 五层架构退役，改为三层主线（感知 → 策略 → 设计）+ 验证辅助；交付层取消（PRD 预审并入 prd-gen 尾门，发布 checklist/灰度策略并入 feature-launch）
- Skill 合并：market-intelligence + user-research → market-research；positioning + prioritization + roadmap → product-strategy；impact-analysis + iteration-planning → retrospective
- 删除 data-monitoring / process-optimization / requirement-review / project-coordination / release-management；Subagent 8 → 6（删除 data-monitor、process-optimizer）
- `/ompm` 升级为全局意图路由（无参/自然语言时读上下文 + current-workflow.json 推荐下一步）

### v0.9.4
- 上下文文件名统一为扁平 `.ompm/<name>.json` 契约（v0.9.3 起）
- 补充 `/ompm` 工作流调度器说明

### v0.8.0
- 新增 Mermaid 可视化工作流架构
- 新增完整对话流 sequence diagram
- 定义 5 层架构 + Plan-and-Execute 模式状态机
- 补充 Subagent 委托架构图

### v0.7.0 (之前)
- 定义工作流阶段、状态机和统一质量门控
