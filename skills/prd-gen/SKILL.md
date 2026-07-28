---
name: prd-gen
description: '从功能需求生成结构化产品需求文档（PRD）。当用户想要创建 PRD、记录新功能、编写产品规格、形式化用户故事、说"为 X 写 PRD"、需要记录需求、或正在准备产品评审会议时使用。即使没有明确说"PRD"，当用户需要包含用户故事、验收标准和成功指标的结构化产品文档时也应激活。 Also triggers on: write a PRD, product requirements doc, user stories and acceptance criteria.'
layer: design
input-from: product-strategy,competitive-analysis,market-research,clarify-requirements
output-to: prototype-design,retrospective
context-requirements:
  - scenario: iteration
    required: [current_feature_desc, ui_state, iteration_goal]
    ui_state_options: [screenshot, html_file, online_url]
  - scenario: new_feature
    required: [product_architecture, design_specs, entry_point]
  - scenario: new_product
    required: [background, constraints, reference_products]
---

# PRD Generation

Generate structured Product Requirements Documents from feature ideas.

## What This Skill Does

Transforms informal feature requests into complete PRDs with user stories, acceptance criteria, functional requirements, success metrics, and compliance guidance. The output is ready for engineering teams to implement and stakeholders to review.

## When to Use

Activate this skill when:
- User wants to document a new feature or product idea
- Phrases like "write a PRD", "create requirements", "document this feature"
- Preparing for product review, stakeholder alignment, or engineering handoff
- User mentions user stories, acceptance criteria, or success metrics
- Need to formalize a rough idea into structured documentation

## Scenario Detection (CRITICAL - First Step)

**Before generating any PRD content, you MUST identify the scenario.**

Ask the user which scenario applies (use the host's structured-question tool if available, e.g. `AskUserQuestion` on Claude Code; otherwise present a numbered option list and wait for the reply):

### Q: 请选择 PRD 生成场景

| Option | Description |
|:-------|-------------|
| **迭代更新** | 基于现有功能进行迭代优化 |
| **新功能** | 在现有产品上添加新模块 |
| **0-1 新产品** | 从零开始规划全新产品 |

### Context Collection by Scenario

Once scenario is identified, collect required context:

| Scenario | Required Information | Collection Method |
|:---------|:--------------------|:------------------|
| **迭代更新** | 1. 当前功能描述<br>2. UI 状态（截图/HTML/链接）<br>3. 迭代目标 | User input + structured question for UI state option |
| **新功能** | 1. 产品整体架构<br>2. 设计规范（组件库/交互模式）<br>3. 入口位置 | Read from `docs/product/` or user input |
| **0-1 新产品** | 1. 产品背景与目标用户<br>2. 资源约束<br>3. 参考产品 | User input + competitive analysis |

**UI State Collection for Iteration Updates**:
When user selects "迭代更新", ask how they want to provide current UI state:
- **截图** - User provides screenshot; read it with the host's image-understanding capability (on Claude Code, e.g. `mcp__4_5v_mcp__analyze_image` / `mcp__zai-mcp-server__ui_to_artifact` MCP tools; other hosts use their built-in image reading)
- **HTML 文件** - User provides local HTML path, use `Read` tool to parse DOM structure
- **在线链接** - User provides URL; read it with the host's web-reading capability (on Claude Code, e.g. `mcp__web_reader__webReader`; other hosts use their built-in web access) (no login required)

### Step 0.5: Information Gap Analysis & PRD Plan (CRITICAL — HARD GATE)

**HARD GATE**: Do NOT proceed to Industry Benchmark Check or PRD generation until this step is complete and user has approved the plan.

**阶段进度显式化**：交互阶段每次向用户提问，都必须以 `当前阶段：N/M 阶段名` 开头（与 clarify-requirements 同一套格式），让用户随时掌握进度。prd-gen 的阶段划分：

| 阶段 | 阶段名 | 对应步骤 |
|:-----|:-------|:---------|
| 1/4 | 场景确认 | Scenario Detection |
| 2/4 | 逐项确认 | Step 0.5 缺口提问（提问前缀进一步细化为 `当前阶段：2/4 逐项确认 · 第 x/y 项`，x 为当前项序号、y 为缺失项总数） |
| 3/4 | 章节选择 | Step 0.5 Chapter Selection |
| 4/4 | 方案审阅 | Step 0.5 User Approval |

Gap Analysis、PRD Plan 生成、Industry Benchmark Check 与正文生成为内部处理步骤，无需前缀。

**Explicit-Skip Protocol（用户显式拒绝交互时）**: If the user explicitly forbids questions (e.g. "别问了，直接写"), you MAY skip the interactive gates — but then you MUST start the output with an **假设声明** block listing every assumption made (scenario, selected/excluded chapters, target product, key defaults), so the user can correct them. The 假设声明同时充当 Evidence Discipline 的完整度清单：未确认信息标【待确认】、无证据断言标【未验证】（见下文 Evidence Discipline），不得脑补填默认值。Never skip silently.

After scenario detection and context collection:

1. **Gap Analysis**: Compare user-provided information against `context-requirements` for this scenario. List every missing required field. Also check `docs/product/` for existing perception data (market-analysis.json, competitive-analysis, user-research.json, positioning.md).

2. **One Question At A Time**: For each missing item, ask the user with a structured question offering multiple choice options. Do NOT bundle multiple questions into one message.

   | Missing Item | Example Question |
   |:-------------|:-----------------|
   | UI 截图 | "当前功能的界面状态，你如何提供？" → A. 已有截图 B. 有 HTML 文件 C. 有在线链接 D. 暂无，先跳过 |
   | 竞品列表 | "需要分析哪些竞品？" → multi-select + "其他" |
   | 目标用户 | "目标用户是？" → A. 已定义画像 B. 我口述你来整理 C. 需要先做用户研究 |
   | 参考产品 | "有参考产品吗？" → A. 有，我来说 B. 你帮我搜索行业标杆 C. 不需要参考 |

3. **Handle Missing Assets**: If user says "I'll provide screenshots later" or "先跳过", record which items are pending and note them in the PRD plan as `[待补充]`.

4. **Generate PRD Plan**: Prepare (but do not yet display) the PRD Plan structure. The table below shows the template with default selections:

   ```markdown
   ### 预计生成的 PRD 章节
   | 章节 | 内容概要 | 选中 | 依赖状态 |
   |:-----|:---------|:-----|:---------|
   | 第0章 行业对标分析 | 将研究 X 个标杆产品 | ✅ | 已完成 / [待补充] |
   | 第1章 项目概述 | 基于用户描述展开 | ✅ | 已完成 |
   | 第2章 业务分析 | 目标用户 X，痛点 Y | ✅ | 已完成 / [待补充] |
   | 第3章 功能需求 | [关键功能列表] | ✅ | 已完成 |
   | 第4章 非功能性需求 | 行业标准要求 | ✅ | 自动生成 |
   | 第5章 用户体验流程 | 基于功能推导 | ✅ | 需 UI 补充 |
   | 第6章 项目风险 | 基于功能复杂度 | ✅ | 自动生成 |
   | 第7章 合规建议 | 基于数据类型 | ❌ | 自动生成 |
   | 第8章 原型设计 | [原型链接] | ❌ | - |
   | 第9章 成功指标 | 基于目标推导 | ❌ | 自动生成 |

   ### 排除清单（不生成以下内容）
   - 技术方案 / 架构设计 — PRD 为产品需求文档，不包含技术实现细节
   - API 接口定义 / 端点规格 — 由开发团队在技术方案中另写
   - 数据库表结构设计 — 不在产品需求范围内
   ```

   **Note:** The table above uses default selections. The actual「选中」values will be filled in Step 4.5 based on user's chapter selection responses. Do NOT present this table to the user yet.

4.5. **Chapter Selection** (HARD GATE — Before presenting PRD Plan):

Present chapter selection to the user as a structured multi-select question. If the host's question tool limits options (e.g. 4-option limit), split into 3 sequential questions. Build `selected_chapters` and `excluded_chapters` lists from responses, and update the PRD Plan table's「选中」column accordingly.

**Question 1 — Core Chapters (第0-3章):**

| Option | Default | Description |
|:-------|:--------|:------------|
| 第0章 行业对标分析 | ✅ Selected | Research benchmark products and best practices |
| 第1章 项目概述 | ✅ Selected | Project background, objectives, scope |
| 第2章 业务分析 | ✅ Selected | Target users, pain points, market analysis |
| 第3章 功能需求 | ✅ Selected | Feature list, user stories, detailed requirements |

**Question 2 — Extended Chapters (第4-7章):**

| Option | Default | Description |
|:-------|:--------|:------------|
| 第4章 非功能性需求 | ✅ Selected | Performance, security, availability, compatibility |
| 第5章 用户体验流程 | ✅ Selected | User journey, page flow diagrams |
| 第6章 项目风险 | ✅ Selected | Project risks and mitigation strategies |
| 第7章 合规建议 | ⬜ Not selected | Compliance guidelines and risk categories |

**Question 3 — Optional Chapters (第8-9章):**

| Option | Default | Description |
|:-------|:--------|:------------|
| 第8章 原型设计 | ⬜ Not selected | Prototype links and design notes |
| 第9章 成功指标 | ⬜ Not selected | North star, process, and outcome metrics |

**Permanent Exclusions (not in selection list, NEVER generated):**
- 技术方案 / 架构设计 — PRD 不包含技术实现细节
- API 接口定义 — 接口文档由开发团队另写
- 数据库表结构设计 — 不在产品需求范围内

**After collecting selections:** Update the PRD Plan table's「选中」column to reflect user choices (✅ for selected, ❌ for excluded).

5. **User Approval**: Present the PRD Plan (with chapter selections) to the user via a structured question and get explicit approval:

   | Option | Description |
   |:-------|:------------|
   | **确认，按此章节方案生成 PRD** | 进入 Step 1 行业基准和 Step 2 PRD 生成 |
   | **调整章节选择** | 重新勾选要生成的章节 |
   | **需要调整方案** | 修改 PRD Plan 后重新确认 |
   | **我有更多信息要补充** | 回到 Step 0.5 补充信息，重新生成方案 |
   | **先补充感知数据** | 调用 market-research / competitive-analysis |

**Anti-Pattern**: "I have enough info, let me just generate" — forbidden. Even with minimal gaps, present the plan and get approval.

### TUI 环境下的图片处理指南

在终端 (TUI) 环境下，用户可以通过以下方式提供图片：

#### 方式一：本地文件路径（最简单）

直接提供图片的本地路径，使用 Read 工具读取：

```bash
# 用户对话示例
"分析这个 UI 截图: /Users/fh/Desktop/screenshot.png"
"当前界面: ~/Screenshots/ui-2025-03-12.png"
"参考图片: ./docs/product/images/reference.png"
```

**支持的路径格式：**
- 绝对路径: `/Users/fh/Desktop/screenshot.png`
- 家目录缩写: `~/Screenshots/ui.png`
- 相对路径: `./images/ui.png`

**支持的图片格式：** PNG, JPG, JPEG, WebP, GIF

#### 方式二：在线图片 URL

用户将图片上传到图床/云存储后提供 URL：

```bash
# 用户对话示例
"UI 截图: https://i.imgur.com/xyz.png"
"参考图: https://s3.aws.com/bucket/screenshot.png"
```

使用宿主可用的图片理解能力读取远程图片（Claude Code 中为 `mcp__4_5v_mcp__analyze_image` / `mcp__zai-mcp-server__ui_to_artifact` 等 MCP 工具；其他宿主用自带读图能力）。

**推荐图床：**
- imgur.com (免费，无需注册)
- GitHub (作为 issue 附件)
- 云存储 (AWS S3, 阿里云 OSS)

#### 方式三：终端截图命令

引导用户使用终端截图工具快速生成截图：

**macOS:**
```bash
# 截取选定区域（交互式）
screencapture -i ~/screenshot.png

# 截取整个窗口
screencapture -w ~/screenshot.png

# 截取整个屏幕
screencapture ~/screenshot.png
```

**Linux:**
```bash
# ImageMagick (需先安装: sudo apt install imagemagick)
import ~/screenshot.png

# gnome-screenshot (Ubuntu/GNOME)
gnome-screenshot -a -f ~/screenshot.png

#spectacle (KDE)
spectacle -r -o ~/screenshot.png
```

#### 方式四：粘贴板直接获取（macOS）

```bash
# 安装 pngpaste 工具
brew install pngpaste

# 将粘贴板的图片保存为文件
pngpaste ~/screenshot.png
```

#### 处理流程

当用户提供图片后：

1. **本地路径** → 使用 `Read` 工具直接读取
2. **远程 URL** → 使用宿主可用的图片理解能力读取（Claude Code 中为 `mcp__4_5v_mcp__analyze_image` / `mcp__zai-mcp-server__ui_to_artifact` 等 MCP 工具；其他宿主用自带读图能力）
3. **分析图片内容** → 提取 UI 结构、布局、交互元素
4. **生成 PRD** → 基于图片分析结果生成需求文档

### Industry Benchmark Check

After scenario detection, context collection, and information clarification:

1. **User-provided benchmarks** (priority): User-specified reference products
2. **Agent supplemental search**: Auto-search industry best practices based on scenario keywords
3. **Extract best practices**: 3-5 benchmark interaction patterns/feature designs
4. **Cite in PRD**: Reference benchmark solutions with rationale for adoption/differentiation

**Search Keyword Mapping**:
| Scenario | Search Keywords |
|:---------|:----------------|
| 迭代更新 | "{功能名} 最佳实践", "行业 {功能名} 设计" |
| 新功能 | "{产品类型} {模块名} 方案", "同类产品 {功能}" |
| 0-1 新产品 | "{行业} 产品框架", "{领域} 产品地图" |

## How It Works

The generation process ensures complete, actionable PRDs:

1. **Scenario Detection** - Ask the user a structured question to identify iteration/new-feature/new-product
2. **Context Collection** - Gather required information based on scenario type
3. **Information Gap Analysis** - Identify missing info, ask one question at a time
4. **Chapter Selection** - User selects which PRD chapters to generate (multiSelect)
5. **PRD Plan Presentation** - Present plan with chapter selections for user approval (HARD GATE)
6. **Industry Benchmark Research** - Search and extract best practices (user-specified + agent search)
7. **Parse requirements** - Structure the user's feature request into key components
8. **Gather context** - Read market analysis, competitive insights, user research
9. **Assemble sections** - Build only the SELECTED PRD sections with appropriate detail
10. **Verify completeness** - Check against quality standards (selected chapters only)
11. **Pre-delivery self-review** - Run the PRD 预审尾门 (chapter self-check + stakeholder perspective challenge); fix blockers or mark【待确认】
12. **Generate output** - Write to `docs/product/prd/{feature-name}-{date}-v{version}.md`（含尾部「预审记录」一节）

**Content Constraints (HARD RULES):**

Before generating PRD content, note:
1. Generate ONLY the chapters selected by the user. Skip unselected chapters entirely.
2. NEVER generate the following content types, regardless of user input:
   - Technical architecture / implementation details
   - API endpoint definitions or specifications
   - Database schema or table designs
3. If the user's feature description mentions technical details, summarize them as functional requirements WITHOUT exposing implementation specifics.

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `requirements` | string | Yes | Feature description or user story to document |
| `target_audience` | string | No | Target user segment or persona |
| `context_refs` | list | No | Related context files to reference |

## Evidence Discipline (证据纪律)

1. **缺失信息标记【待确认】**：任何无法从输入或上下文获得的信息，标记为【待确认】，不得脑补填默认值。
2. **证据追溯【未验证】**：用户需求/市场断言必须追问证据来源；无证据的标记为【未验证】并注明所需验证方式。
3. **完整度检查门**：正式输出交付物前，先输出信息完整度清单（已确认 ✅ / 待确认 ⚠️ / 未验证 ❓），经用户确认后才生成正文。清单按**逐章节就绪度**判断：信息不足的章节在清单中标注原因（缺什么信息）并暂缓生成，信息充足的章节正常生成——按就绪度分别生成，而非全有或全无。

**与 Explicit-Skip Protocol（Step 0.5）的关系**: 证据纪律是输出纪律（信息标注与交付前自查），Explicit-Skip 是交互纪律（用户显式拒绝交互时的降级处理），两者互补不冲突。Explicit-Skip 场景下完整度清单不免除 — 与「假设声明」合并输出，但不再等待用户确认；假设声明中的未确认信息同样按本节规则标注【待确认】/【未验证】。

## Output Structure

The PRD follows this structure (aligned with standard PRD template). **IMPORTANT: This template shows all possible chapters. Generate ONLY the chapters selected by the user. Skip unselected chapters entirely. Do NOT generate technical architecture, API specifications, or database designs under any circumstances.**

```markdown
# [Feature Name] PRD

## 文档基本信息
- **文档版本**: v1.0
- **创建日期**: YYYY-MM-DD
- **最后更新**: YYYY-MM-DD
- **文档状态**: Draft/Review/Approved
- **创建人**: [用户名]
- **审阅人**: [待定]

## 修订记录
| 版本 | 日期 | 修订内容 | 修订人 |
|:-----|:-----|:---------|:-------|
| v1.0 | YYYY-MM-DD | 初始版本 | [创建人] |

## 0. 行业对标分析
### 0.1 参考产品
| 产品 | 关键功能 | 采纳/差异化 |
|:-----|:---------|:-----------|
| [竞品A] | XXX | 采纳其 XXX 模式，因为... |
| [竞品B] | XXX | 差异化点在于... |

### 0.2 最佳实践总结
- **交互模式**: [采用的行业标准交互模式]
- **核心差异化**: [本方案的独特之处]

## 1. 项目概述
### 1.1 项目背景
[市场背景、竞争背景、用户需求背景]

### 1.2 项目目标
#### 1.2.1 核心目标
- [可量化的核心目标]

#### 1.2.2 次要目标
- [支撑性目标]

### 1.3 项目范围
#### 1.3.1 包含范围
- [本次迭代/功能包含的内容]

#### 1.3.2 不包含范围
- [明确不在本次范围内的事项]

## 2. 业务分析
### 2.1 目标用户
| 用户角色 | 描述 | 核心需求 |
|:---------|:-----|:---------|
| 用户A | [来自用户研究] | XXX |
| 用户B | [来自用户研究] | XXX |

### 2.2 用户痛点
| 痛点ID | 痛点描述 | 影响程度 |
|:-------|:---------|:---------|
| P-001 | XXX | 高/中/低 |
| P-002 | XXX | 高/中/低 |

### 2.3 市场分析
[行业趋势、竞争格局、市场机会点]

## 3. 功能需求
### 3.1 核心功能列表
| 功能ID | 功能名称 | 优先级 | 描述 |
|:-------|:---------|:-------|:-----|
| F-001 | XXX | P0/P1/P2 | XXX |
| F-002 | XXX | P0/P1/P2 | XXX |

### 3.2 用户故事
#### US-1: [功能名称]
**作为** [用户角色]
**我希望** [功能描述]
**以便** [业务价值]

**验收标准**:
- Given [前置条件]
- When [执行操作]
- Then [预期结果]

**优先级**: P0/P1/P2
**估算**: X Story Points

#### US-2: [功能名称]
...

### 3.3 功能详情
#### F-001: [功能名称]
**描述**: [详细功能描述]

**交互流程**:
1. 步骤一
2. 步骤二
3. 步骤三

**边界情况**:
- 正常流程: ...
- 异常情况: ...

## 4. 非功能性需求
### 4.1 性能需求
- 页面响应时间 < XXXms
- 支持 XXX 并发用户
### 4.2 安全需求
- 数据加密存储
- 用户权限控制
### 4.3 可用性需求
- 系统可用性 > 99.9%
### 4.4 兼容性需求
- iOS 14+, Android 10+
- 主流浏览器兼容

## 5. 用户体验流程
### 5.1 用户旅程
[关键用户路径描述]
1. 用户进入 → 2. 执行操作 → 3. 达成目标

### 5.2 页面流程图
[页面跳转关系说明]
- 页面A → 页面B → 页面C

## 6. 项目风险与应对
> 注：本节仅包含产品/业务风险，不包含技术实现风险（技术风险由开发团队在技术方案中评估）
| 风险ID | 风险描述 | 概率 | 影响 | 应对措施 |
|:-------|:---------|:-----|:-----|:---------|
| R-001 | XXX | 高/中/低 | 高/中/低 | XXX |
| R-002 | XXX | 高/中/低 | 高/中/低 | XXX |

## 7. 合规建议

### 7.1 合规要点概述
[合规专家审查的关键要点摘要]

### 7.2 风险提示
| 风险类别 | 说明 | 建议 |
|:---------|:-----|:-----|
| 隐私合规 | [涉及用户数据的处理方式] | [合规建议] |
| 内容合规 | [涉及的内容审核要点] | [合规建议] |
| 数据安全 | [数据存储和传输要求] | [合规建议] |
| 第三方合规 | [依赖的第三方服务合规性] | [合规建议] |

### 7.3 合规报告附件
- [ ] 合规分析报告已附 (如果有，提供路径)
- [ ] 等待合规审查 (如需要，安排合规专家评审)

**备注**: 本章为 prd-gen 自包含的合规自查——按 7.1/7.2 逐项确认产品涉及的数据类型对应的法规要求与第三方服务合规性；涉及强监管领域（金融、医疗、未成年人等）时，先安排合规专家评审再定稿。

## 8. 原型设计
### 8.1 原型链接
- **HTML**: [本地路径]
- 待生成...

### 8.2 设计说明
- **设计参考**: [来源]
- **设计风格**: [描述]

## 9. 成功指标
### 9.1 北极星指标
- [核心业务指标]: 目标值

### 9.2 过程指标
| 指标名称 | 基线值 | 目标值 | 测量方式 |
|:---------|:-------|:-------|:---------|
| XXX | 0 | 100 | 事件统计 |
| XXX | 0 | 100 | 用户行为分析 |

### 9.3 结果指标
| 指标名称 | 基线值 | 目标值 | 测量方式 |
|:---------|:-------|:-------|:---------|
| XXX | 0 | 100 | 数据分析 |
| XXX | 0 | 100 | 业务报表 |

## 附录
- 参考文档: [链接]
- 竞品分析: [链接]

## 预审记录

> 本节由「PRD 预审尾门」自动生成，记录 PM 自审结果，不属于章节选择范围，不代表干系人已评审通过。

### 自审问题清单
| 问题 | 严重度 | 所在章节 | 处理方式 |
|:-----|:-------|:---------|:---------|
| XXX | 阻塞/非阻塞 | 第X章 | 已修复 / 【待确认】: 说明 |

### 干系人视角挑战
| 视角 | 问题 | 回答 |
|:-----|:-----|:-----|
| 工程 | XXX | 答案 / 【待确认】 |
| 设计 | XXX | 答案 / 【待确认】 |
| 业务 | XXX | 答案 / 【待确认】 |
```

## User Story Format

Each user story follows this template:

```
US-{NN}: [Brief feature description]

As a [user role]
I want [feature description]
So that [business value]

**Acceptance Criteria**:
- Given [precondition]
- When [I do X]
- Then [expected outcome]

**Priority**: P0/P1/P2
**Estimate**: X story points
```

## Quality Standards

Before delivering, the PRD should include:
- **Scenario identified** (iteration/new-feature/new-product)
- **Required context collected** for the identified scenario
- **Chapter selections confirmed** by user
- **3+ industry benchmarks** referenced with rationale (第0章, if selected)
- All **selected** sections complete
- **文档基本信息** with version and revision history
- **用户痛点** identified and documented (第2.2节, if 第2章 selected)
- User stories in "作为...我希望...以便..." format (第3.2节, if 第3章 selected)
- **非功能性需求** as standalone section (第4章, if selected)
- **用户体验流程** with user journey (第5章, if selected)
- **项目风险** documented (product/business risks only, no technical risks, if 第6章 selected)
- **合规建议** section with risk categories and attachment reference (if 第7章 selected)
- **原型设计** section (if 第8章 selected)
- **成功指标** split into North Star, process, and outcome metrics (if 第9章 selected)
- 3+ quantifiable success metrics (if 第9章 selected)
- Dependencies and constraints clearly identified
- References to context sources

**Exclusion Verification:**
- [ ] No technical architecture or implementation details
- [ ] No API endpoint definitions or specifications
- [ ] No database schema or table designs

**Quality Gate Checklist:**
- [ ] Scenario type confirmed with user
- [ ] All required context for this scenario collected
- [ ] Chapter selections confirmed by user
- [ ] Industry benchmarks researched (3+ references, if 第0章 selected)
- [ ] 文档基本信息 complete (version, status, creator, reviewer)
- [ ] 项目概述 complete (background, objectives, scope, if 第1章 selected)
- [ ] 业务分析 complete (target users, pain points, market analysis, if 第2章 selected)
- [ ] 功能需求 complete (feature list, user stories, details, if 第3章 selected)
- [ ] 非功能性需求 complete (performance, security, availability, compatibility, if 第4章 selected)
- [ ] 用户体验流程 complete (user journey, page flow, if 第5章 selected)
- [ ] 项目风险 documented with mitigation (product/business risks only, no technical risks, if 第6章 selected)
- [ ] 合规建议 complete with risk categories and attachment reference (if 第7章 selected)
- [ ] 原型设计 section present (if 第8章 selected)
- [ ] 成功指标 quantified (North Star + process + outcome, if 第9章 selected)
- [ ] Dependencies documented
- [ ] Exclusion constraints verified (no tech/API/DB content)
- [ ] PRD 预审尾门已通过（阻塞问题已修复或标【待确认】，「预审记录」已附加到 PRD 尾部）

## PRD 预审尾门 (Pre-Delivery Self-Review Gate)

**HARD GATE**: PRD 正文生成完成、写入 `docs/product/prd/` 交付之前，必须通过本节自审。这是 PM 自审（self-review），不是评审会议 — 不模拟"开会"、不追求"获得批准"，目标是诚实地暴露 PRD 当前的缺口与风险。

### 1. 生成后自审 (Chapter-by-Chapter Self-Check)

对已生成的每个章节逐项检查：

| 检查项 | 不通过的表现 |
|:-------|:-------------|
| **逻辑漏洞** | 前后章节矛盾（如功能列表与用户旅程不一致）、目标与范围脱节 |
| **模糊表述** | "合理"、"尽量"、"较快"、"用户友好"等无法判定的措辞 |
| **验收标准可验收性** | 无法写成 Given/When/Then、无明确预期结果、依赖主观判断 |
| **边界情况** | 缺少异常流程、空态/满态、权限边界、极端输入 |
| **指标可衡量性** | 成功指标缺基线值/目标值/测量方式（若第9章选中） |
| **范围一致性** | 不包含范围（1.3.2）与功能列表（3.1）存在冲突 |

发现问题分两档：
- **阻塞问题（Blocker）**: 导致工程无法评估、设计无法开展或验收无法执行的问题
- **非阻塞问题**: 可在后续迭代中澄清的细节，记录但不阻碍交付

### 2. 干系人视角挑战 (Stakeholder Perspective Challenge)

模拟三个视角对 PRD 提出质疑，每个视角提出 2-3 个最尖锐的问题：

| 视角 | 挑战重点 | 示例问题 |
|:-----|:---------|:---------|
| **工程** | 可实现性 / 工作量 | "这个交互在现有架构下是否需要重构？" "性能指标在当前数据量级下是否现实？" "P0 功能的工作量是否被低估？" |
| **设计** | 交互完整性 | "异常流程和空态的界面表现定义了吗？" "从页面 B 回退到页面 A 的路径是什么？" |
| **业务** | 指标可衡量性 | "北极星指标的基线值从哪里来？" "如何区分功能带来的指标变化与自然波动？" "目标值的设定依据是什么？" |

**要求**: 问题必须具体（指向 PRD 中的章节/条目），不允许泛泛而问；某视角确实提不出具体问题时，如实说明"该视角未发现阻塞疑问"，不得编造问题凑数。

### 3. 预审记录（附加到 PRD 尾部）

自审与挑战结果写入 PRD 尾部的「预审记录」一节（格式见 Output Structure 模板末尾）。该节**不属于章节选择范围，始终生成**，并声明：本记录为 PM 自审结果，不代表干系人已评审通过。

### 4. 交付条件 (Exit Criteria)

- 所有**阻塞问题**已修复，或在 PRD 中标注【待确认】并说明所需确认人与确认方式
- 「预审记录」一节已附加到 PRD 尾部
- 非阻塞问题已在交付说明中告知用户

**禁止**: 发现阻塞问题仍原样交付、在交付说明中含糊带过 — 诚实定位优于表面完整。

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `docs/product/.ompm/market-analysis.json` - Market background
- `docs/product/.ompm/competitive-analysis.json` - Competitive comparison
- `docs/product/.ompm/user-research.json` - User insights

**Writes:**
- `docs/product/prd/{feature-name}-{date}-v{version}.md` - The generated PRD (versioned output)
- Legacy: `docs/product/.ompm/prd-draft.md` for backward compatibility

## HTML 原型生成

**Only trigger this step if the user selected 第8章 原型设计 in the chapter selection.**

If 原型设计 was selected, generate the HTML prototype directly (no additional confirmation needed — the user already opted in during chapter selection):

1. Generate interactive HTML prototype based on PRD content
2. Output to `docs/product/prototypes/{feature-name}.html`
3. Include basic styling and interaction for demonstration
4. Update PRD with HTML prototype link
5. Notify user with preview instructions

If 原型设计 was NOT selected, skip this step and notify the user that PRD generation is complete.

## Example Usage

```
User: "Write a PRD for dark mode"
→ Generates complete PRD with user stories, requirements, metrics

User: "Document the user onboarding feature"
→ Activates prd-gen to create structured requirements

User: "I need user stories for the checkout flow"
→ Generates PRD section focused on checkout user stories
```

## 下一步

本 skill 完成后，如果用户没有明确下一步，引导用户使用 ompm skill 做意图路由——它会读取本轮产出和当前状态，判断最有价值的下一步。不要替用户预设固定长链；output-to 声明的是数据流向，不是强制路径。
