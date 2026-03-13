---
name: prd-gen
description: 从功能需求生成结构化产品需求文档（PRD）。当用户想要创建 PRD、记录新功能、编写产品规格、形式化用户故事、说"为 X 写 PRD"、需要记录需求、或正在准备产品评审会议时使用。即使没有明确说"PRD"，当用户需要包含用户故事、验收标准和成功指标的结构化产品文档时也应激活。
layer: design
input-from: product-positioning,prioritization,competitive-analysis
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.3.0
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

Transforms informal feature requests into complete PRDs with user stories, acceptance criteria, functional requirements, success metrics, and delivery timelines. The output is ready for engineering teams to implement and stakeholders to review.

## When to Use

Activate this skill when:
- User wants to document a new feature or product idea
- Phrases like "write a PRD", "create requirements", "document this feature"
- Preparing for product review, stakeholder alignment, or engineering handoff
- User mentions user stories, acceptance criteria, or success metrics
- Need to formalize a rough idea into structured documentation

## Scenario Detection (CRITICAL - First Step)

**Before generating any PRD content, you MUST identify the scenario.**

Use `AskUserQuestion` to determine which scenario applies:

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
| **迭代更新** | 1. 当前功能描述<br>2. UI 状态（截图/HTML/链接）<br>3. 迭代目标 | User input + AskUserQuestion for UI state option |
| **新功能** | 1. 产品整体架构<br>2. 设计规范（组件库/交互模式）<br>3. 入口位置 | Read from `context/` or user input |
| **0-1 新产品** | 1. 产品背景与目标用户<br>2. 资源约束<br>3. 参考产品 | User input + competitive analysis |

**UI State Collection for Iteration Updates**:
When user selects "迭代更新", ask how they want to provide current UI state:
- **截图** - User provides screenshot, use `mcp__zai-mcp-server__ui_to_artifact` or `mcp__4_5v_mcp__analyze_image`
- **HTML 文件** - User provides local HTML path, use `Read` tool to parse DOM structure
- **在线链接** - User provides URL, use `mcp__web_reader__webReader` (no login required)

### TUI 环境下的图片处理指南

在终端 (TUI) 环境下，用户可以通过以下方式提供图片：

#### 方式一：本地文件路径（最简单）

直接提供图片的本地路径，使用 Read 工具读取：

```bash
# 用户对话示例
"分析这个 UI 截图: /Users/fh/Desktop/screenshot.png"
"当前界面: ~/Screenshots/ui-2025-03-12.png"
"参考图片: ./context/images/reference.png"
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

使用 `mcp__4_5v_mcp__analyze_image` 或 `mcp__zai-mcp-server__ui_to_artifact` 工具读取远程图片。

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
2. **远程 URL** → 使用 `mcp__4_5v_mcp__analyze_image` 或 `mcp__zai-mcp-server__ui_to_artifact`
3. **分析图片内容** → 提取 UI 结构、布局、交互元素
4. **生成 PRD** → 基于图片分析结果生成需求文档

### Industry Benchmark Check

After scenario detection and context collection:

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

1. **Scenario Detection** - Use AskUserQuestion to identify iteration/new-feature/new-product
2. **Context Collection** - Gather required information based on scenario type
3. **Industry Benchmark Research** - Search and extract best practices (user-specified + agent search)
4. **Parse requirements** - Structure the user's feature request into key components
5. **Gather context** - Read market analysis, competitive insights, user research
6. **Assemble sections** - Build each PRD section with appropriate detail
7. **Verify completeness** - Check against quality standards
8. **Generate output** - Write to `context/prd/{feature-name}-{date}-v{version}.md`

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `requirements` | string | Yes | Feature description or user story to document |
| `target_audience` | string | No | Target user segment or persona |
| `context_refs` | list | No | Related context files to reference |

## Output Structure

The PRD follows this structure (aligned with standard PRD template):

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
| 风险ID | 风险描述 | 概率 | 影响 | 应对措施 |
|:-------|:---------|:-----|:-----|:---------|
| R-001 | XXX | 高/中/低 | 高/中/低 | XXX |
| R-002 | XXX | 高/中/低 | 高/中/低 | XXX |

## 7. 原型设计
### 7.1 原型链接
- **Figma**: [链接] 或 **HTML**: [本地路径]
- 待生成...

### 7.2 设计说明
- **设计参考**: [来源]
- **设计风格**: [描述]

## 8. 项目计划
| 阶段 | 交付物 | 时间 | 负责人 |
|:-----|:-------|:-----|:-------|
| 设计 | 原型图 | Week 1 | XXX |
| 开发 | 功能上线 | Week 3 | XXX |
| 测试 | 测试报告 | Week 4 | XXX |

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
- **3+ industry benchmarks** referenced with rationale (第0章)
- All 9 required sections complete (第1-9章)
- **文档基本信息** with version and revision history
- **用户痛点** identified and documented (第2.2节)
- User stories in "作为...我希望...以便..." format (第3.2节)
- **非功能性需求** as standalone section (第4章)
- **用户体验流程** with user journey (第5章)
- **原型设计** section (第7章)
- **成功指标** split into North Star, process, and outcome metrics (第9章)
- 3+ quantifiable success metrics
- Dependencies and constraints clearly identified
- References to context sources

**Quality Gate Checklist**:
- [ ] Scenario type confirmed with user
- [ ] All required context for this scenario collected
- [ ] Industry benchmarks researched (3+ references)
- [ ] 文档基本信息 complete (version, status, creator, reviewer)
- [ ] 项目概述 complete (background, objectives, scope)
- [ ] 业务分析 complete (target users, pain points, market analysis)
- [ ] 功能需求 complete (feature list, user stories, details)
- [ ] 非功能性需求 complete (performance, security, availability, compatibility)
- [ ] 用户体验流程 complete (user journey, page flow)
- [ ] 项目风险 documented with mitigation
- [ ] 原型设计 section present
- [ ] 项目计划 with timeline
- [ ] 成功指标 quantified (North Star + process + outcome)
- [ ] Dependencies documented

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates complete PRD automatically, writes to file |
| `copilot` | Shows PRD outline, confirms each section with you before finalizing |
| `manual` | Provides PRD template, you fill in the content |

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `context/market-analysis.json` - Market background
- `context/competitive-analysis.json` - Competitive comparison
- `context/user-research.json` - User insights

**Writes:**
- `context/prd/{feature-name}-{date}-v{version}.md` - The generated PRD (versioned output)
- Legacy: `context/prd-draft.md` for backward compatibility

## Figma Integration (NEW)

After PRD generation, ask user if they need Figma prototype:

```markdown
## 🎨 PRD 已生成完成！

📄 文档位置: `context/prd/{feature-name}-{date}-v{version}.md`

是否需要生成 Figma 原型图？
- ✅ 是，生成原型
- ⏭️ 跳过
```

If user approves, activate `figma-prototype` skill to:
1. Check Figma API token configuration
2. Collect design reference (iteration mode: UI screenshots; new product: style reference)
3. Generate Figma prototype with proper styling
4. Mark changes (iteration mode: green=new, yellow=modify, red=delete)
5. Update PRD with Figma link
6. Notify user with prototype link

## Example Usage

```
User: "Write a PRD for dark mode"
→ Generates complete PRD with user stories, requirements, metrics

User: "Document the user onboarding feature"
→ Activates prd-gen to create structured requirements

User: "I need user stories for the checkout flow"
→ Generates PRD section focused on checkout user stories
```
