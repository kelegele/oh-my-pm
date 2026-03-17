---
name: prototype-design
description: 创建交互式原型以验证设计方案。支持 HTML 原型和 Pencil 设计稿两种输出格式。当用户需要设计 UI/UX、创建原型、设计用户流程，或说"创建原型"、"设计这个功能"、"UI 原型"、"Pencil 设计稿"时使用。支持迭代模式（基于现有样式）和新产品模式（自定义设计规范）。
layer: design
input-from: prd-gen,user-research
output-to: project-coordination,requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.6.0
---

# Prototype Design

生成交互式原型，可视化设计方案并进行早期验证。支持 **HTML 原型**和 **Pencil 设计稿**两种输出格式。

## What This Skill Does

生成原型文件，用于可视化设计方案并进行早期验证。支持两种输出格式：

1. **HTML 原型**：独立 HTML 文件，可在浏览器中直接打开预览
2. **Pencil 设计稿**：.pen 设计文件，结构化设计数据，支持专业设计工具和代码导出

支持两种模式：
- **迭代模式**：基于用户提供的截图或 HTML 文件，提取现有样式后生成匹配的新原型
- **新产品模式**：询问用户设计偏好后，使用默认或自定义设计规范生成原型

## When to Use

激活此 skill 当：
- PRD 生成后需要创建可视化原型
- 用户说"创建原型"、"设计这个功能"、"UI 原型"、"Pencil 设计稿"
- 需要验证用户流程或交互模式
- 需要向干系人演示设计概念

## HTML 原型生成工作流 (v0.6.0 新增)

### Step 0: 格式选择 (CRITICAL)

**生成任何原型前，必须先选择输出格式。**

在「模式检测」之后、样式配置之前，增加格式选择：

```markdown
### Q: 选择原型输出格式

| Option | Description |
|:-------|-------------|
| **HTML 原型** | 可在浏览器直接预览、演示交互 |
| **Pencil 设计稿** | 结构化设计数据、专业设计工具、可导出代码 |
| **两者都生成** | 同时生成 HTML 和 Pencil 两种格式 |
```

**格式对比：**

| 格式 | 优势 | 适用场景 | 输出位置 |
|:-----|:-----|:---------|:-----------|
| **HTML 原型** | 可在浏览器直接预览、快速演示交互 | 快速验证、演示给干系人 | `context/prototypes/{name}.html` |
| **Pencil 设计稿** | 结构化设计数据、可导出代码、支持设计系统、专业工具集成 | 专业设计、开发对接、设计资产管理 | `context/prototypes/{name}.pen` |

### Step 1: 模式检测 (CRITICAL - 第二步)

在输出格式选择后，必须检测场景模式：

使用 `AskUserQuestion` 确定模式：

```markdown
### Q: 请选择原型生成模式

| Option | Description |
|:-------|-------------|
| **迭代更新** | 基于现有产品样式生成（需要截图或 HTML 文件） |
| **新产品** | 创建全新设计（需要确认设计规范） |
```

### Step 2: 迭代模式工作流

当用户选择"迭代更新"时：

#### Step 2.1: 收集现有样式

询问用户如何提供现有 UI：

```markdown
### Q: 如何提供现有 UI 样式？

| Option | Description |
|:-------|-------------|
| **截图** | 提供 UI 截图（本地路径或 URL） |
| **HTML 文件** | 提供现有 HTML 文件路径 |
| **在线链接** | 提供在线页面 URL |
```

根据用户提供的方式：

| 输入方式 | 分析工具 | 提取内容 |
|:---------|:---------|:---------|
| 截图 | `mcp__zai-mcp-server__analyze_image` 或 `Read` | 颜色、字体、布局、组件 |
| HTML | `Read` 工具解析 DOM | CSS 变量、class 样式、组件结构 |
| 在线链接 | `mcp__web_reader__webReader` | 页面样式和布局 |

#### Step 2.2: 分析并提取样式

根据用户提供的方式：

| 输入方式 | 处理方式 |
|:---------|:---------|
| 截图 | AI 图片分析工具提取颜色、字体、布局信息 |
| HTML | Read 工具解析 DOM 结构，提取 CSS 规则 |
| 在线链接 | Web Reader 获取页面样式 |

从分析中提取并生成样式配置：

```javascript
// styles.config.js
const EXTRACTED_STYLES = {
  colors: {
    primary: "{{PRIMARY_COLOR}}",      // 主色调（迭代模式从截图提取）
    secondary: "{{SECONDARY_COLOR}}",  // 次要色
    background: "#ffffff",   // 背景色
    surface: "#f9fafb",      // 表面色
    text: "#1f2937",         // 主文本
    textSecondary: "#6b7280", // 次要文本
    border: "#e5e7eb",       // 边框色
    success: "#10b981",      // 成功色
    error: "#ef4444",        // 错误色
  },
  typography: {
    fontFamily: "{{FONT_FAMILY}}",
    fontSize: {
      base: "{{FONT_SIZE_BASE}}",
      headings: {
        h1: "{{FONT_SIZE_H1}}",
        h2: "{{FONT_SIZE_H2}}",
        h3: "{{FONT_SIZE_H3}}",
      }
    },
    fontWeight: {
      normal: "400",
      medium: "500",
      semibold: "600",
      bold: "700",
    }
  },
  spacing: {
    xs: "0.25rem",
    sm: "0.5rem",
    md: "1rem",
    lg: "1.5rem",
    xl: "2rem",
    "2xl": "3rem",
  },
  borderRadius: {
    sm: "0.25rem",
    md: "0.375rem",
    lg: "0.5rem",
    xl: "0.75rem",
    full: "9999px",
  },
  shadows: {
    sm: "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    md: "0 4px 6px -1px rgb(0 0 0 / 0.1)",
    lg: "0 10px 15px -3px rgb(0 0 0 / 0.1)",
  }
};
```

#### Step 2.3: 生成原型（根据格式选择）

**HTML 格式：**

使用提取的样式生成原型，选择合适的保真度级别：

| 保真度级别 | 说明 | 模板 |
|:---------|:-----|:-------|
| `wireframe` | 线框图，灰度布局，无视觉样式 | `templates/prototype/wireframe.html` |
| `mockup` | 完整视觉设计，带颜色和样式 | `templates/prototype/mockup.html` |
| `interactive` | 可交互的完整原型，带 JavaScript 交互 | `templates/prototype/interactive.html` |

生成到 `context/prototypes/{feature-name}.html`

**HTML 原型输出格式**：

生成的文件结构：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{FEATURE_NAME}} - 原型</title>
    <style>
        /* CSS 变量定义 - 基于提取或用户选择的样式 */
        :root {
            /* 颜色系统 */
            --color-primary: {{PRIMARY_COLOR}};
            --color-secondary: {{SECONDARY_COLOR}};
            --color-background: {{BACKGROUND_COLOR}};
            --color-surface: {{SURFACE_COLOR}};
            --color-text: {{TEXT_COLOR}};
            --color-text-secondary: {{TEXT_SECONDARY_COLOR}};
            --color-border: {{BORDER_COLOR}};
            --color-success: {{SUCCESS_COLOR}};
            --color-error: {{ERROR_COLOR}};

            /* 字体系统 */
            --font-family: {{FONT_FAMILY}};
            --font-size-base: {{FONT_SIZE_BASE}};

            /* 间距系统 */
            --spacing-sm: 0.5rem;
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
            --spacing-2xl: 3rem;

            /* 圆角 */
            --radius-sm: 0.25rem;
            --radius-md: 0.375rem;
            --radius-lg: 0.5rem;
            --radius-xl: 0.75rem;
            --radius-full: 9999px;

            /* 阴影 */
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);

            /* 基础重置 */
            * { margin: 0; padding: 0; box-sizing: border-box; }
        }

        body {
            font-family: var(--font-family);
            font-size: var(--font-size-base);
            color: var(--color-text);
            background: var(--color-background);
            line-height: 1.6;
        }

        /* 通用组件样式 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-md);
        }

        .header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: white;
            padding: 32px;
            border-radius: var(--radius-xl);
            margin-bottom: 24px;
        }

        .header h1 {
            font-size: var(--font-size-h1);
            font-weight: 700;
            margin: 0;
        }

        /* 页面布局样式 */
        .layout {
            display: grid;
            grid-template-columns: 1fr;
            gap: var(--spacing-md);
        }

        /* 表单元素 */
        .input {
            width: 100%;
            padding: var(--spacing-sm) var(--spacing-md);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
        }

        .input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* 按钮样式 */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--radius-md);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary {
            background: var(--color-primary);
            color: white;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        /* 卡片样式 */
        .card {
            background: var(--color-surface);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
        }

        /* 交互演示 */
        .page { display: none; }
        .page.active { display: block; }
    </style>
</head>
<body>
    <div class="container">
        <!-- 页面头部 -->
        <div class="header">
            <h1>{{FEATURE_NAME}}</h1>
            <p>{{FEATURE_DESCRIPTION}}</p>
        </div>

        <!-- 功能页面 -->
        <div id="page-list" class="page active">
            <h2>功能列表</h2>
            <!-- 功能卡片列表 -->
        </div>

        <!-- 详情页面 -->
        <div id="page-detail" class="page">
            <h2>功能详情</h2>
            <!-- 表单 -->
        </div>

        <!-- 操作按钮 -->
        <button class="btn btn-primary" onclick="showPage('list')">返回列表</button>
    </div>

    <script>
        // 简单的页面切换
        function showPage(pageId) {
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');
        }
    </script>
</body>
</html>
```

### Step 3: 新产品模式工作流

当用户选择"新产品"时：

#### Step 3.1: 确认设计规范

使用 `AskUserQuestion` 收集设计偏好：

```markdown
### Q: 请选择设计风格

| Option | Description |
|:-------|-------------|
| **简约现代** | 大量留白、简洁线条、无衬线字体 |
| **商务专业** | 稳重配色、传统布局、清晰层级 |
| **活泼创意** | 鲜明色彩、圆角元素、动感设计 |
| **暗色主题** | 深色背景、高对比度、科技感 |
```

### Q: 主色调偏好？

| Option | Color |
|:-------|-------|
| **蓝色** | 专业、可信（默认） |
| **绿色** | 健康、自然 |
| **紫色** | 创意、高端 |
| **橙色** | 活力、热情 |
| **红色** | 紧迫、重要 |
| **自定义** | 输入色值 |

#### Step 3.2: 生成样式配置

基于用户选择生成样式配置（同上 `styles.config.js` 格式）

#### Step 3.3: 生成原型（根据格式选择）

**HTML 格式：** 使用默认样式配置生成到 `context/prototypes/{feature-name}.html`

选择合适的保真度级别：
- **wireframe** - 线框图，使用基础样式
- **mockup** - 完整视觉设计
- **interactive** - 交互式原型

### Pencil MCP 环境配置（CRITICAL - 选择 Pencil 时必需）

当用户选择 **Pencil 设计稿**或**两者都生成**时，必须先完成 Pencil MCP 环境检查：

[保留原有 Pencil MCP 环境配置流程]

### 保真度级别

| 级别 | 说明 | 输出 |
|:-----|:-----|:-----|
| `wireframe` | 线框图，灰度布局，无视觉样式 | 基础布局，结构清晰 |
| `mockup` | 模型，完整视觉设计，静态页面 | 完整设计，视觉专业 |
| `interactive` | 交互式，可点击、状态切换、表单演示 | 可交互，演示流程 |

### 输出位置

```
context/prototypes/
├── {feature-name}.html          # HTML 原型（可选）
├── {feature-name}.pen           # Pencil 设计稿（可选）
├── {feature-name}-preview.png    # Pencil 设计稿预览截图
└── README.md                   # 使用说明
```

## Quality Standards

生成原型前确保：
- [ ] 格式已选择（HTML/Pencil/两者）
- [ ] Pencil 格式：环境配置检查通过
- [ ] 迭代模式：已收集并分析现有 UI
- [ ] 新产品模式：已确认设计风格和颜色
- [ ] PRD 内容已读取并理解
- [ ] 用户流程已映射
- [ ] 生成文件可在对应工具中打开
- [ ] 包含必要的交互演示（交互式）
- [ ] HTML 使用提取的样式或用户选择的配色

## 上下文集成

**读取:**
- `context/prd/*.md` - 需求文档
- 用户提供的截图/HTML（迭代模式）
- `templates/prototype/*.html` - HTML 原型模板

**写入:**
- `context/prototypes/{feature-name}.html` - HTML 原型（如选择）
- `context/prototypes/{feature-name}.pen` - Pencil 设计稿（如选择）
- `context/prototypes/{feature-name}-preview.png` - 设计稿预览截图（Pencil）
- 更新 PRD 中的原型链接

## 使用示例

```
# 迭代模式 + HTML
User: "基于现有首页生成新功能原型"
→ 询问现有 UI 提供方式
→ 提取样式
→ 生成匹配风格的 HTML 原型
```

```
# 新产品模式 + HTML
User: "为新产品创建原型"
→ 询问设计风格和颜色
→ 生成带样式的 HTML 原型
```

## 预览说明

生成后向用户提供：

### HTML 原型预览

```markdown
## 🎨 HTML 原型已生成！

📁 文件位置: `context/prototypes/{feature-name}.html`

📖 预览方式:
1. 直接双击文件在浏览器中打开
2. 或运行: open context/prototypes/{feature-name}.html

✨ 特性:
- 响应式布局
- 基于 [提取样式/用户选择] 的设计
- 可交互的页面切换
- 表单演示

📝 下一步:
- 查看原型并提供反馈
- 确认后可进入开发阶段
```

### Pencil 设计稿预览

```markdown
## 🎨 Pencil 设计稿已生成！

📁 文件位置: `context/prototypes/{feature-name}.pen`
🖼️ 预览截图: `context/prototypes/{feature-name}-preview.png`

📖 预览方式:
1. 在 Pencil 应用中打开 .pen 文件
2. 查看预览截图了解设计概览

✨ 特性:
- 结构化设计数据
- 支持设计系统组件
- 可导出代码
- 符合 web-app 设计原则

📝 下一步:
- 在 Pencil 中查看完整设计
- 导出代码进行开发
- 确认后可进入开发阶段
```

### 两者都生成

```markdown
## 🎨 原型已生成！（双格式）

📁 文件位置:
- HTML: `context/prototypes/{feature-name}.html`
- Pencil: `context/prototypes/{feature-name}.pen`
- 预览: `context/prototypes/{feature-name}-preview.png`

📖 预览方式:
- HTML: 双击文件在浏览器中打开
- Pencil: 在 Pencil 应用中打开

📝 下一步:
- 查看原型并提供反馈
- 确认后可进入开发阶段
```
