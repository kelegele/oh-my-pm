---
name: prd-gen
description: 从功能需求生成结构化产品需求文档（PRD）。当用户想要创建 PRD、记录新功能、编写产品规格、形式化用户故事、说"为 X 写 PRD"、需要记录需求、或正在准备产品评审会议时使用。即使没有明确说"PRD"，当用户需要包含用户故事、验收标准和成功指标的结构化产品文档时也应激活。
layer: design
input-from: product-positioning,prioritization,competitive-analysis
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.2.1
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

The PRD follows this structure for consistency:

```markdown
# [Feature Name] PRD

## Document Info
- **Created**: YYYY-MM-DD
- **Status**: Draft/Review/Approved
- **Scenario**: iteration/new-feature/new-product
- **Version**: v{N}

## 0. Industry Benchmarks (NEW - REQUIRED)
### 0.1 Reference Products
| Product | Key Features | Adoption/Differentiation |
|:---------|:-------------|:------------------------|
| [Benchmark A] | XXX | We adopt their XXX pattern because... |
| [Benchmark B] | XXX | We differentiate by... |

### 0.2 Best Practice Summary
- **Interaction Pattern**: [Industry standard pattern used]
- **Key Differentiator**: [What makes this solution unique]

## 1. Background & Goals
### 1.1 Business Context
[Market and competitive background from context files]

### 1.2 Objectives
- **Primary**: [Quantified core objective]
- **Secondary**: [Supporting objectives]

### 1.3 Success Metrics
| Metric | Baseline | Target | How to Measure |
|:-------||:---------|:-------|:---------------|
| XXX | 0 | 100 | Event tracking |

## 2. User Stories
### 2.1 Target Users
| Role | Description | Core Needs |
|:-----|:-----------|:-----------|
| User A | [From user-research] | XXX |

### 2.2 User Stories
- **US-1**: As a [role], I want [feature], so that [value]
  - Acceptance: Given [context], When [action], Then [outcome]

- **US-2**: ...

## 3. Functional Requirements
### 3.1 Core Features
| ID | Description | Priority | Dependencies |
|:---|:-----------|::--------|:-------------|
| F-001 | XXX | P0 | None |

### 3.2 Feature Details
#### F-001: [Feature Name]
**Description**: [Detailed description]

**Interaction Flow**:
1. Step one
2. Step two

**Edge Cases**:
- Normal: ...
- Exception: ...

### 3.3 Non-Functional Requirements
- **Performance**: Response time < 200ms
- **Security**: Encrypted data storage
- **Compatibility**: iOS 14+, Android 10+

## 4. Constraints & Dependencies
### 4.1 Technical Constraints
- [List technical limitations]

### 4.2 Business Constraints
- [List business limitations]

### 4.3 External Dependencies
- [External systems/services required]

## 5. Milestones & Timeline
| Phase | Deliverable | Timeline |
|:------|:------------|:---------|
| Design | Prototype | Week 1 |
| Development | Feature launch | Week 3 |

## 6. Risks & Mitigation
| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| XXX | Medium | High | XXX |

## Appendix
- References: [links]
- Competitive analysis: [link]
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
- **3+ industry benchmarks** referenced with rationale
- All 6 required sections (background, user stories, features, non-functional, constraints, milestones)
- User stories in "As a... I want... So that..." format
- 3+ quantifiable success metrics
- Dependencies and constraints clearly identified
- References to context sources

**Quality Gate Checklist**:
- [ ] Scenario type confirmed with user
- [ ] All required context for this scenario collected
- [ ] Industry benchmarks researched (3+ references)
- [ ] PRD sections complete
- [ ] Success metrics quantified
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
