# Oh-My-PM 工作流架构 (v0.8.0)

Oh-My-PM 采用 **5 层架构** + **Plan-and-Execute 模式**，覆盖需求感知→策略规划→方案设计→交付协调→价值验证完整闭环。

## 5 层架构总览

```mermaid
graph TB
    subgraph L1["1. Perception 需求感知层"]
        A1["market-intelligence\n市场情报"]
        A2["user-research\n用户研究"]
        A3["competitive-analysis\n竞品分析"]
        A4["data-monitoring\n指标监控"]
    end

    subgraph L2["2. Strategy 策略规划层"]
        B1["product-positioning\n产品定位"]
        B2["roadmap-planning\n路线图规划"]
        B3["prioritization\n优先级排序"]
    end

    subgraph L3["3. Design 方案设计层"]
        C1["prd-gen\nPRD 生成"]
        C2["prototype-design\n原型设计"]
        C3["process-optimization\n流程优化"]
    end

    subgraph L4["4. Delivery 交付协调层"]
        D1["requirement-review\n需求评审"]
        D2["project-coordination\n项目协调"]
        D3["release-management\n发布管理"]
    end

    subgraph L5["5. Validation 价值验证层"]
        E1["impact-analysis\n效果分析"]
        E2["feedback-synthesis\n反馈汇总"]
        E3["iteration-planning\n迭代规划"]
    end

    L1 -->|"context/"| L2
    L2 -->|"context/"| L3
    L3 -->|"context/"| L4
    L4 -->|"context/"| L5
    L5 -.->|"反馈循环"| L1
```

## 用户对话流

用户通过 **自然语言** 或 **Command** 触发，系统自动识别并路由到对应 Skill。

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant SK as Skill Router
    participant CTX as context/ 目录
    participant SA as Subagent

    U->>CC: "分析 Notion vs 飞书的差异"
    CC->>SK: 识别触发词 → competitive-analysis
    SK->>SA: 委托 competitive-analyst (Sonnet)
    SA->>SA: GitHub 代码分析 + 功能对比
    SA->>CTX: 写入 context/competitive-analysis.json
    SA-->>CC: 返回对比矩阵
    CC-->>U: 展示竞品分析结果

    U->>CC: "基于这个分析写 PRD"
    CC->>SK: 识别触发词 → prd-gen
    SK->>CTX: 读取 competitive-analysis.json
    SK->>SK: 识别场景：迭代/新功能/0-1
    SK-->>CC: 生成 PRD 文档
    CC->>CTX: 写入 context/prd/feature-name.md
    CC-->>U: 展示 PRD 内容

    U->>CC: "帮我设计原型"
    CC->>SK: 识别触发词 → prototype-design
    SK->>CTX: 读取 prd/*.md
    SK-->>CC: 生成 HTML 原型
    CC->>CTX: 写入 context/prototypes/*.html
    CC-->>U: 返回 HTML 原型链接
```

## Command 工作流详解

### /quick-prd — 竞品分析 + PRD

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant CA as competitive-analysis
    participant PG as prd-gen
    participant CTX as context/

    U->>CC: /quick-prd "用户中心改版" 淘宝 京东
    CC->>CA: 启动竞品分析流程
    CA->>CA: 分析淘宝/京东用户中心功能
    CA->>CTX: 写入 competitive-analysis.json
    CA-->>CC: 输出对比矩阵
    CC->>PG: 传入竞品分析结果 + 需求描述
    PG->>CTX: 读取 competitive-analysis.json
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
    participant PP as product-positioning
    participant RM as roadmap-planning
    participant PR as prioritization
    participant PG as prd-gen
    participant PD as prototype-design
    participant CTX as context/

    U->>CC: /full-pm-cycle "项目管理工具"
    CC->>PM: 启动完整 PM 周期编排

    Note over PM,CTX: 阶段 1: 需求感知 (并行执行)
    PM->>MR: market-researcher 分析市场
    PM->>CA: competitive-analyst 分析竞品
    PM->>UI: user-interviewer 创建画像
    MR->>CTX: 写入 market-data.json
    CA->>CTX: 写入 competitive-analysis.json
    UI->>CTX: 写入 personas.json

    Note over PM,CTX: 阶段 2: 策略规划
    PM->>PP: 基于感知层输出写定位
    PP->>CTX: 读取 market-data + competitive + personas
    PP->>CTX: 写入 positioning.md
    PM->>RM: 基于定位写路线图
    RM->>CTX: 读取 positioning.md → roadmap.md
    PM->>PR: 基于路线图排优先级
    PR->>CTX: 读取 roadmap.md → prioritization.json

    Note over PM,CTX: 阶段 3: 方案设计
    PM->>PG: 基于策略层输出写 PRD
    PG->>CTX: 读取 positioning + roadmap + priorities
    PG->>CTX: 写入 prd/project-mgmt.md
    PM->>PD: 基于 PRD 生成原型
    PD->>CTX: 读取 prd/*.md → prototypes/*.html

    PM-->>CC: 完整周期完成，更新 workflow_tracking.json
    CC-->>U: 展示完整产物清单
```

### /feature-launch — 功能发布工作流

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant CC as Claude Code
    participant RR as requirement-review
    participant PC as project-coordination
    participant RM as release-management
    participant IA as impact-analysis
    participant FB as feedback-synthesis
    participant IP as iteration-planning
    participant CTX as context/

    U->>CC: /feature-launch "用户注册流程"
    CC->>RR: 启动需求评审
    RR->>RR: 生成评审清单 + 干系人确认
    RR->>CTX: 写入 requirement-review.json

    CC->>PC: 启动项目协调
    PC->>PC: 制定任务分配 + 时间线
    PC->>CTX: 写入 project-plan.md

    CC->>RM: 启动发布管理
    RM->>RM: 生成发布包 + 上线检查清单
    RM->>CTX: 写入 release-checklist.md

    Note over CC,CTX: 功能上线后 7-14 天
    CC->>IA: 启动效果分析
    IA->>CTX: 读取目标指标
    IA->>CTX: 写入 impact-analysis.json

    CC->>FB: 启动反馈汇总
    FB->>CTX: 读取用户反馈
    FB->>CTX: 写入 feedback-themes.json

    CC->>IP: 启动迭代规划
    IP->>CTX: 读取 impact + feedback
    IP->>CTX: 写入 iteration-plan.md

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
        CTX["context/ 文件写入"]
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
        DM["data-monitor\nHaiku + daemon"]
        PO["process-optimizer\nSonnet + readonly"]
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
    MC -.->|"触发词匹配"| DM
    MC -.->|"触发词匹配"| PO
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
    S0_Setup --> S1_Perception: 创建 workflow_tracking.json
    S1_Perception --> S1_Quality: 执行感知层 Skills
    S1_Quality --> S2_Strategy: 质量门控通过
    S1_Quality --> S1_Perception: 需要补充数据

    S2_Strategy --> S2_Quality: 执行策略层 Skills
    S2_Quality --> S3_Design: 质量门控通过
    S2_Quality --> S2_Strategy: 需要调整策略

    S3_Design --> S3_Quality: 执行设计层 Skills
    S3_Quality --> S4_Delivery: 质量门控通过
    S3_Quality --> S3_Design: PRD 需要修改

    S4_Delivery --> S4_Quality: 执行交付层 Skills
    S4_Quality --> S5_Validation: 质量门控通过
    S4_Quality --> S4_Delivery: 风险未解决

    S5_Validation --> S5_Quality: 执行验证层 Skills
    S5_Quality --> [*]: 完整周期完成
    S5_Quality --> S1_Perception: 反馈循环重启

    state S1_Quality <<choice>>
    state S2_Quality <<choice>>
    state S3_Quality <<choice>>
    state S4_Quality <<choice>>
    state S5_Quality <<choice>>
```

## 质量门控标准

### Perception 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 市场研究完成 | 3+ 竞品市场规模和趋势分析 | `market_size`, `growth_rate`, `key_players` |
| 用户研究完成 | 3+ 用户访谈，2+ 用户画像 | `personas_created`, `interviews_conducted` |
| 竞品分析完成 | 2+ 竞品功能对比 | `competitors_analyzed`, `matrix_complete` |

### Strategy 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 产品定位完成 | 定位声明 + 价值主张 + 差异化策略 | `positioning_created`, `value_proposition_clarity` |
| 路线图完成 | 12 个月产品路线图 | `milestones_defined`, `timeline_set` |
| 优先级完成 | RICE/MoSCoW 框架排序 | `rice_scores_calculated`, `moscow_decisions` |

### Design 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| PRD 完整 | 8 章节 PRD 文档 | `all_sections_complete`, `user_stories_mapped` |
| 原型验证 | 原型生成 + 可用性确认 | `prototype_created`, `design_consistent` |

### Delivery 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 需求评审完成 | 干系人评审会议 + 签字 | `review_held`, `stakeholders_aligned` |
| 项目计划完成 | 任务分配 + 时间线确认 | `tasks_assigned`, `timeline_confirmed` |
| 发布准备完成 | 代码冻结 + 上线检查清单 | `code_freeze`, `checklist_complete` |

### Validation 层

| 门控 | 标准 | 指标 |
|:-----|:-----|:-----|
| 效果分析完成 | 上线 7-14 天目标达成分析 | `goals_achieved`, `variance_analyzed` |
| 反馈综合完成 | 用户反馈主题分析 | `themes_identified`, `improvements_mapped` |
| 迭代规划完成 | 下一轮迭代计划 | `next_iteration_planned`, `success_metrics_defined` |

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

### v0.8.0
- 新增 Mermaid 可视化工作流架构
- 新增完整对话流 sequence diagram
- 定义 5 层架构 + Plan-and-Execute 模式状态机
- 补充 Subagent 委托架构图

### v0.7.0 (之前)
- 定义工作流阶段、状态机和统一质量门控
