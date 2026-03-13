---
name: figma-prototype
description: 基于 PRD 和设计参考生成 Figma 原型。当用户需要 UI/UX 原型、想要从需求创建 Figma 设计、说"生成原型"、"创建 Figma 设计"、"制作 UI 线框图"，或在 PRD 生成后用户同意创建原型时使用。此技能与 Figma MCP 集成创建设计文件，需要配置 Figma API 访问令牌，支持迭代模式（匹配现有样式）和新产品模式（使用设计参考）。
layer: design
input-from: prd-gen
output-to: requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Figma Prototype Generation

Generate Figma design prototypes from PRD requirements with design reference.

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
│  │ Check .env  │ → 有 Token? → No: 引导用户配置              │
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
│  STEP 6: Update PRD with Figma Link                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Step 1: Check Figma Configuration

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

## Quality Standards

Before completing, verify:
- [ ] Figma token is configured and valid
- [ ] Design reference collected (based on mode)
- [ ] Prototype matches design reference style
- [ ] Changes marked (iteration mode)
- [ ] PRD updated with Figma link
- [ ] User notified with links

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
- `.env` - Figma API token
- `context/prd/{prd-file}.md` - PRD requirements
- User-provided design references (images, URLs, docs)

**Writes:**
- `.env` - Token configuration (if guiding user)
- `context/prd/{prd-file}.md` - Updated with Figma link
- Figma design file via MCP API

## Example Usage

```
User: "生成 Figma 原型"
→ Check token → Prompt for mode → Generate prototype → Update PRD

User: "为用户改版功能创建原型"
→ Detect iteration mode → Collect UI screenshots →
  Analyze style → Create prototype with changes → Mark modifications
```
