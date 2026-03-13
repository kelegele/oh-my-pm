---
name: figma-prototype
description: 基于 PRD 和设计参考生成 Figma 原型或 HTML 原型。当用户需要 UI/UX 原型、想要从需求创建设计、说"生成原型"、"创建 Figma 设计"、"制作 UI 线框图"，或在 PRD 生成后用户同意创建原型时使用。优先使用 Figma MCP 创建设计文件，当 MCP 不可用时询问用户是否生成 HTML 原型作为替代。支持迭代模式（匹配现有样式）和新产品模式（使用设计参考）。
layer: design
input-from: prd-gen
output-to: requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.3.0
---

# Figma Prototype Generation

Generate Figma design prototypes from PRD requirements with design reference.

## Prerequisites: Figma MCP Server

**This skill requires Figma MCP Server to be enabled.**

If you see "Figma MCP 工具在当前环境中不可用", follow these steps:

### Option 1: Remote MCP Server (Recommended)

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@figma/mcp-server"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "你的_figma_token"
      }
    }
  }
}
```

### Option 2: Desktop MCP Server

If you have Figma desktop app installed, add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "figma-desktop": {
      "command": "/Applications/Figma.app/Contents/MacOS/Figma",
      "args": ["--mcp"]
    }
  }
}
```

**After configuration**, restart Claude Code for changes to take effect.

### Get Figma Access Token

1. Login to [Figma](https://www.figma.com)
2. Click avatar → **Settings**
3. Go to **Security** → **Personal access tokens**
4. Click **Generate new token**
5. Name it (e.g., `Oh-My-PM-MCP`) and copy

**Official docs**: https://help.figma.com/hc/en-us/articles/32132100833559

---

## What This Skill Does

Creates Figma design files based on PRD requirements and user-provided design references. Integrates with Figma MCP to:
- Check and configure Figma API access token
- Analyze existing UI styles (iteration mode)
- Generate new prototypes with proper design system
- Mark changes with color annotations
- Update PRD with Figma links

## When to Use

Activate this skill when:
- After PRD generation, user approves prototype creation
- User says "generate prototype", "create Figma design", "make UI mockup"
- User needs visual design for product requirements
- Preparing for design review or stakeholder presentation

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    FIGMA PROTOTYPE WORKFLOW                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  STEP 1: Check Configuration                                │
│  ┌─────────────┐                                            │
│  │Check MCP API│ → Available? → No: 询问用户是否生成 HTML   │
│  └─────────────┘          Yes: 继续                          │
│                                                             │
│  STEP 2: Determine Mode                                     │
│  ┌─────────────┐  ┌─────────────┐                            │
│  │ Iteration   │  │ New Product │                            │
│  └─────────────┘  └─────────────┘                            │
│         ↓                ↓                                   │
│  STEP 3: Collect Design Reference                           │
│  ┌─────────────┐  ┌─────────────┐                            │
│  │ UI Screenshots│  │ Style Ref  │                            │
│  │ HTML / URL   │  │ Component  │                            │
│  └─────────────┘  │   Library  │                            │
│                   └─────────────┘                            │
│         ↓                ↓                                   │
│  STEP 4: Generate Prototype                                  │
│  ┌─────────────────────────────────────────────┐            │
│  │ Analyze Style → Create Frame → Add Content │            │
│  └─────────────────────────────────────────────┘            │
│         ↓                                                        ↓
│  STEP 5: Mark Changes (Iteration mode only)                    │
│  ┌─────────────────────────────────────────────┐            │
│  │ Green=New, Yellow=Modify, Red=Delete      │            │
│  └─────────────────────────────────────────────┘            │
│         ↓                                                        ↓
│  STEP 6: Update PRD with Link (Figma or HTML)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Step 1: Check Figma MCP Availability

**First, check if Figma MCP tools are available in the current environment.**

Try to use Figma MCP tools (e.g., list available tools or a simple Figma API call).

### If Figma MCP is NOT Available

Use `AskUserQuestion` to ask the user:

```markdown
## ⚠️ Figma MCP 不可用

检测到 Figma MCP 工具在当前环境中不可用。请选择：

| 选项 | 说明 |
|:-----|:-----|
| **生成 HTML 原型** | 直接生成可交互的 HTML 原型文件，可在浏览器中预览 |
| **配置 Figma MCP** | 按照 Skill 文件中的配置说明启用 Figma MCP |
```

If user chooses **生成 HTML 原型**, skip to "HTML Prototype Generation Mode" section below.

If user chooses **配置 Figma MCP**, show the configuration guide from Prerequisites section.

### If Figma MCP is Available

Continue to Step 2.

**Check if Figma API token is configured:**

```bash
# Check .env file for FIGMA_ACCESS_TOKEN
if [ -f .env ] && grep -q "FIGMA_ACCESS_TOKEN" .env; then
    echo "Token found"
else
    echo "Token not configured"
fi
```

**If not configured, guide user:**

---

## 🔑 Figma API Token 配置

### 获取 Personal Access Token

1. 登录 [Figma](https://www.figma.com)
2. 点击左上角头像 → **Settings（设置）**
3. 选择 **Security** 标签页
4. 滚动到 **Personal access tokens** 部分
5. 点击 **Generate new token**
6. 输入名称（如 `Oh-My-PM-MCP`），设置权限
7. 复制生成的 token（⚠️ 仅显示一次！）

### Token 说明

- **有效期**：最多 90 天（Figma 限制）
- **到期后**：需要重新生成并更新配置
- **建议**：设置日历提醒 85 天后更新

### 配置到本地环境

**方法一：在项目根目录创建 .env 文件**

```bash
echo "FIGMA_ACCESS_TOKEN=你的token" > .env
```

**方法二：追加到现有 .env 文件**

```bash
echo "FIGMA_ACCESS_TOKEN=你的token" >> .env
```

**文件位置**：`~/Projects/oh-my-pm/.env` 或当前工作目录

---

## Step 2: Determine Prototype Mode

Use `AskUserQuestion` to determine the mode:

### Q: 请选择原型生成模式

| 选项 | 说明 | 需要提供 |
|:-----|:-----|:---------|
| **迭代更新** | 基于现有功能迭代 | 当前 UI 截图/HTML/链接 |
| **新功能/新产品** | 从零开始设计 | 设计参考/组件库链接 |

## Step 3: Collect Design Reference by Mode

### Mode A: 迭代更新 (Iteration)

**Required Information:**

| 信息项 | 说明 | 获取方式 |
|:-------|:-----|:---------|
| 当前 UI 截图 | 现有界面图片 | 用户上传本地文件路径 |
| HTML 文件 | 可选：本地 HTML 文件路径 | Read 工具读取 |
| 在线链接 | 可选：产品在线 URL | webReader 工具 |

**UI Collection Methods:**
```markdown
请提供当前 UI 状态（至少一种）：

1. 本地截图路径：`~/Desktop/screenshot.png`
2. HTML 文件路径：`./context/ui-reference.html`
3. 在线链接：`https://your-product.com/page`
```

### Mode B: 新功能/新产品 (New)

**Required Information:**

```markdown
请提供设计参考（至少一种）：

1. 风格参考截图：___________
2. 组件库链接（Ant Design / Element UI / Figma Community）：___________
3. 设计规范文档：___________
4. Figma Community 组件链接：___________

⚠️ 严禁凭空想象生成样式！必须基于明确的设计参考。
```

**Common Component Libraries:**
- [Ant Design](https://ant.design/)
- [Element UI](https://element.eleme.cn/)
- [Figma Community](https://www.figma.com/community)
- [Material Design](https://m3.material.io/)

## Step 4: Generate Prototype

### 4.1 Analyze Design Reference

**For Iteration Mode:**
- Extract color palette (primary, secondary, background, text)
- Extract typography (font family, sizes, weights, line heights)
- Extract spacing system (padding, margins, gaps)
- Extract border radius, shadows, other styling tokens

**For New Product Mode:**
- Read component library documentation
- Extract design tokens from reference
- Understand component patterns

### 4.2 Create Figma Design File

Use Figma MCP tools to create the design:

```
# File structure
File: {PRD名称}-原型
├── Page: 桌面端 / 移动端
│   ├── Frame: 登录页面
│   ├── Frame: 首页
│   ├── Frame: 功能页面
│   └── ...
└── Styles / Components
    ├── Colors
    ├── Typography
    ├── Effects
    └── Components
```

### 4.3 Apply Changes Based on PRD

- Read PRD functional requirements
- Create frames for each user story
- Add UI components according to requirements
- Set proper layouts and constraints

## Step 5: Mark Changes (Iteration Mode Only)

For iteration updates, mark all changes:

| Change Type | Color | Figma Implementation |
|:-----------|:-----|:---------------------|
| 新增 | 🟢 Green | Green fill/stroke + `[新增]` annotation |
| 修改 | 🟡 Yellow | Yellow fill/stroke + `[修改]` annotation |
| 删除 | 🔴 Red | Red strike-through + `[删除]` annotation |

**Annotation Example:**
```markdown
Frame 注释内容：
- [新增] 用户头像组件
- [修改] 按钮颜色从蓝色改为绿色
- [删除] 旧的活动推荐模块
```

## Step 6: Update PRD with Figma Link

**Append to PRD file:**

```markdown
## 7. 原型设计

### Figma 原型链接
- **在线查看**: [Figma 文件链接](https://www.figma.com/file/xxxxx)
- **文件路径**: `{PRD名称}-原型`

### 原型说明
- **设计参考**: [参考来源]
- **生成模式**: {迭代更新 / 新功能/新产品}
- **修改标注**:
  - 🟢 绿色 = 新增
  - 🟡 黄色 = 修改
  - 🔴 红色 = 删除

### 页面清单
1. {页面名称} - {说明}
2. {页面名称} - {说明}
3. ...
```

## Step 7: Notify User

**Success Message:**

```markdown
## ✅ 原型图已生成！

📄 **PRD 文档**: context/prd/{feature-name}-{date}-v{version}.md
🎨 **Figma 原型**: https://www.figma.com/file/xxxxx

### 原型说明
- 共生成 {N} 个页面
- 基于 {设计参考} 风格
- 修改点已在图中标注

原型链接已附在 PRD 文档中，可直接查看。
```

## Error Handling

| Error Scenario | Handling |
|:---------------|:----------|
| Token not found | Guide user to configure |
| Token expired | Prompt user to regenerate |
| No design reference (new product) | Require user to provide before proceeding |
| Figma API error | Show error message, suggest retry |
| File write failed | Check permissions, report issue |

---

## HTML Prototype Generation Mode

**When Figma MCP is not available and user chooses to generate HTML prototype.**

### Overview

Generate standalone HTML/CSS/JS prototype files that can be opened directly in a browser. This mode provides:
- Immediate visual feedback
- No external dependencies
- Interactive prototype with basic functionality
- Easy sharing via file transfer or hosting

### Step 1: Collect Design Reference (Same as Figma Mode)

Determine mode (Iteration / New Product) and collect design reference using the same process as Figma mode.

### Step 2: Generate HTML Prototype

**File Structure:**
```
context/prototypes/{feature-name}-{date}/
├── index.html          # Main page / navigation
├── css/
│   └── style.css       # All styles
├── js/
│   └── main.js         # Interactions
└── pages/              # Individual page HTMLs
    ├── page1.html
    ├── page2.html
    └── ...
```

**CSS Framework Choice:**

Use `AskUserQuestion` to ask:

| 选项 | 说明 | 适用场景 |
|:-----|:-----|:---------|
| **Tailwind CSS (CDN)** | 快速开发，工具类优先 | 快速原型、现代设计 |
| **原生 CSS** | 无依赖，完全自定义 | 简单页面、学习目的 |
| **Bootstrap (CDN)** | 成熟组件库 | 传统企业应用 |

### Step 3: HTML Template Structure

**Base Template:**
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{页面名称} - 原型</title>
    <!-- CSS framework based on user choice -->
</head>
<body>
    <header>
        <!-- Navigation / Header -->
    </header>
    <main>
        <!-- Main content based on PRD requirements -->
    </main>
    <footer>
        <!-- Footer -->
    </footer>
    <script src="js/main.js"></script>
</body>
</html>
```

### Step 4: Apply Design Tokens

Extract and apply design tokens from reference:

```css
/* Design tokens extracted from {design-reference} */
:root {
    /* Colors */
    --color-primary: #1890ff;
    --color-secondary: #52c41a;
    --color-background: #ffffff;
    --color-text: #000000d9;
    --color-border: #d9d9d9;

    /* Typography */
    --font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    --font-size-base: 14px;
    --font-size-lg: 16px;
    --font-size-sm: 12px;

    /* Spacing */
    --spacing-xs: 4px;
    --spacing-sm: 8px;
    --spacing-md: 16px;
    --spacing-lg: 24px;
    --spacing-xl: 32px;

    /* Border */
    --border-radius: 4px;
}
```

### Step 5: Mark Changes (Iteration Mode Only)

For iteration updates, use CSS classes to mark changes:

```css
/* Change annotations */
.change-new {
    outline: 2px solid #52c41a;
    outline-offset: 2px;
    position: relative;
}
.change-new::after {
    content: "[新增]";
    position: absolute;
    top: -8px;
    left: -8px;
    background: #52c41a;
    color: white;
    font-size: 10px;
    padding: 2px 6px;
    border-radius: 2px;
}

.change-modified {
    outline: 2px solid #faad14;
    outline-offset: 2px;
    position: relative;
}
.change-modified::after {
    content: "[修改]";
    position: absolute;
    top: -8px;
    left: -8px;
    background: #faad14;
    color: white;
    font-size: 10px;
    padding: 2px 6px;
    border-radius: 2px;
}

.change-deleted {
    outline: 2px solid #ff4d4f;
    outline-offset: 2px;
    opacity: 0.5;
    text-decoration: line-through;
}
.change-deleted::after {
    content: "[删除]";
    position: absolute;
    top: -8px;
    left: -8px;
    background: #ff4d4f;
    color: white;
    font-size: 10px;
    padding: 2px 6px;
    border-radius: 2px;
}
```

### Step 6: Update PRD with HTML Link

**Append to PRD file:**

```markdown
## 7. 原型设计

### HTML 原型文件
- **本地路径**: `context/prototypes/{feature-name}-{date}/index.html`
- **打开方式**: 双击 index.html 在浏览器中查看

### 原型说明
- **设计参考**: [参考来源]
- **生成模式**: {迭代更新 / 新功能/新产品}
- **CSS 框架**: {Tailwind CSS / 原生 CSS / Bootstrap}
- **修改标注**:
  - 🟢 绿色边框 = 新增
  - 🟡 黄色边框 = 修改
  - 🔴 红色边框 + 删除线 = 删除

### 页面清单
1. {页面名称} - pages/page1.html
2. {页面名称} - pages/page2.html
3. ...
```

### Step 7: Notify User

**Success Message:**

```markdown
## ✅ HTML 原型已生成！

📄 **PRD 文档**: context/prd/{feature-name}-{date}-v{version}.md
🌐 **HTML 原型**: context/prototypes/{feature-name}-{date}/index.html

### 原型说明
- 共生成 {N} 个页面
- 基于 {设计参考} 风格
- 使用 {CSS 框架}
- 双击 index.html 在浏览器中预览

原型路径已附在 PRD 文档中。
```

---

## Quality Standards

**For Figma Prototype:**
- [ ] Figma MCP is available and token is valid
- [ ] Design reference collected (based on mode)
- [ ] Prototype matches design reference style
- [ ] Changes marked (iteration mode)
- [ ] PRD updated with Figma link
- [ ] User notified with links

**For HTML Prototype:**
- [ ] Design reference collected (based on mode)
- [ ] HTML/CSS/JS files created in correct structure
- [ ] Design tokens extracted and applied
- [ ] Changes marked with CSS classes (iteration mode)
- [ ] PRD updated with HTML file path
- [ ] User notified with file location

## Technical Notes

**Figma MCP Tools Available:**
- File creation and management
- Frame/node creation
- Style and component management
- Design token extraction

**Environment Variables:**
```bash
FIGMA_ACCESS_TOKEN=figd_xxxxxx
```

**Token Validation:**
```bash
# Check token validity (curl example)
curl -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN" \
  https://api.figma.com/v1/me
```

## Context Integration

**Reads:**
- `.env` - Figma API token (for Figma mode)
- `context/prd/{prd-file}.md` - PRD requirements
- User-provided design references (images, URLs, docs)

**Writes (Figma Mode):**
- `.env` - Token configuration (if guiding user)
- `context/prd/{prd-file}.md` - Updated with Figma link
- Figma design file via MCP API

**Writes (HTML Mode):**
- `context/prototypes/{feature-name}-{date}/` - HTML prototype directory
  - `index.html` - Main navigation page
  - `css/style.css` - All styles
  - `js/main.js` - Interactions
  - `pages/*.html` - Individual pages
- `context/prd/{prd-file}.md` - Updated with HTML path

## Example Usage

```
User: "生成 Figma 原型"
→ Check MCP → Available? → No: Ask user (HTML or Configure Figma?)
                              Yes: Continue with Figma
                              HTML: Generate HTML prototype
→ Generate prototype → Update PRD

User: "为用户改版功能创建原型"
→ Detect iteration mode → Collect UI screenshots →
  Analyze style → Create prototype with changes → Mark modifications
```
