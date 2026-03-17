---
name: prototype-design
description: 创建交互式 HTML 原型以验证设计方案。当用户需要设计 UI/UX、创建原型、设计用户流程，或说"创建原型"、"设计这个功能"、"UI 原型"时使用。支持迭代模式（基于现有样式）和新产品模式（自定义设计规范）。
layer: design
input-from: prd-gen,user-research
output-to: project-coordination,requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.2.0
---

# Prototype Design

生成 HTML 交互式原型，可视化设计方案并进行早期验证。

## What This Skill Does

生成独立的 HTML 原型文件，可在浏览器中直接打开预览。支持两种模式：

1. **迭代模式**：基于用户提供的截图或 HTML 文件，提取现有样式后生成匹配的新原型
2. **新产品模式**：询问用户设计偏好后，使用默认或自定义设计规范生成原型

## When to Use

激活此 skill 当：
- PRD 生成后需要创建可视化原型
- 用户说"创建原型"、"设计这个功能"、"UI 原型"
- 需要验证用户流程或交互模式
- 需要向干系人演示设计概念

## 模式检测 (CRITICAL - 第一步)

**生成任何原型前，必须先检测模式。**

使用 `AskUserQuestion` 确定模式：

### Q: 请选择原型生成模式

| Option | Description |
|:-------|-------------|
| **迭代更新** | 基于现有产品样式生成（需要截图或 HTML 文件） |
| **新产品** | 创建全新设计（需要确认设计规范） |

## 迭代模式工作流

当用户选择"迭代更新"时：

### Step 1: 收集现有样式

询问用户如何提供现有 UI：

```markdown
### Q: 如何提供现有 UI 样式？

| Option | Description |
|:-------|-------------|
| **截图** | 提供 UI 截图（本地路径或 URL） |
| **HTML 文件** | 提供现有 HTML 文件路径 |
| **在线链接** | 提供在线页面 URL |
```

### Step 2: 分析并提取样式

根据用户提供的方式：

| 输入方式 | 分析工具 | 提取内容 |
|:---------|:---------|:---------|
| 截图 | `mcp__4_5v_mcp__analyze_image` 或 `Read` | 颜色、字体、布局、组件 |
| HTML | `Read` 工具解析 DOM | CSS 变量、class 样式、组件结构 |
| 在线链接 | `mcp__web_reader__webReader` | 页面样式和布局 |

### Step 3: 生成样式配置

从分析中提取并生成：

```javascript
// styles.config.js
const EXTRACTED_STYLES = {
  colors: {
    primary: "#3b82f6",      // 主色调
    secondary: "#8b5cf6",    // 次要色
    background: "#ffffff",   // 背景色
    surface: "#f9fafb",      // 表面色
    text: "#1f2937",         // 主文本
    textSecondary: "#6b7280", // 次要文本
    border: "#e5e7eb",       // 边框色
    success: "#10b981",      // 成功色
    error: "#ef4444",         // 错误色
  },
  typography: {
    fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
    fontSize: {
      xs: "0.75rem",   // 12px
      sm: "0.875rem",  // 14px
      base: "1rem",    // 16px
      lg: "1.125rem",  // 18px
      xl: "1.25rem",   // 20px
      "2xl": "1.5rem", // 24px
      "3xl": "1.875rem", // 30px
    },
    fontWeight: {
      normal: "400",
      medium: "500",
      semibold: "600",
      bold: "700",
    }
  },
  spacing: {
    xs: "0.25rem",   // 4px
    sm: "0.5rem",    // 8px
    md: "1rem",      // 16px
    lg: "1.5rem",    // 24px
    xl: "2rem",      // 32px
    "2xl": "3rem",   // 48px
  },
  borderRadius: {
    sm: "0.25rem",   // 4px
    md: "0.375rem",  // 6px
    lg: "0.5rem",    // 8px
    xl: "0.75rem",   // 12px
    full: "9999px",  // 圆形
  },
  shadows: {
    sm: "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    md: "0 4px 6px -1px rgb(0 0 0 / 0.1)",
    lg: "0 10px 15px -3px rgb(0 0 0 / 0.1)",
  }
};
```

### Step 4: 生成 HTML 原型

使用提取的样式生成原型，输出到 `context/prototypes/{feature-name}.html`

## 新产品模式工作流

当用户选择"新产品"时：

### Step 1: 确认设计规范

使用 `AskUserQuestion` 收集设计偏好：

```markdown
### Q: 请选择设计风格

| Option | Description |
|:-------|-------------|
| **简约现代** | 大量留白、简洁线条、无衬线字体 |
| **商务专业** | 稳重配色、传统布局、清晰层级 |
| **活泼创意** | 鲜明色彩、圆角元素、动感设计 |
| **暗色主题** | 深色背景、高对比度、科技感 |

### Q: 主色调偏好？

| Option | Color |
|:-------|-------|
| **蓝色** | 专业、可信（默认） |
| **绿色** | 健康、自然 |
| **紫色** | 创意、高端 |
| **橙色** | 活力、热情 |
| **红色** | 紧迫、重要 |
| **自定义** | 输入色值 |
```

### Step 2: 生成样式配置

基于用户选择生成样式配置（同上格式）

### Step 3: 生成 HTML 原型

## HTML 原型输出格式

生成的文件结构：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Feature Name] 原型</title>
  <style>
    /* CSS 变量定义 - 基于提取或用户选择的样式 */
    :root {
      /* 颜色系统 */
      --color-primary: #3b82f6;
      --color-secondary: #8b5cf6;
      --color-background: #ffffff;
      --color-surface: #f9fafb;
      --color-text: #1f2937;
      --color-text-secondary: #6b7280;
      --color-border: #e5e7eb;
      --color-success: #10b981;
      --color-error: #ef4444;

      /* 字体系统 */
      --font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      --font-size-xs: 0.75rem;
      --font-size-sm: 0.875rem;
      --font-size-base: 1rem;
      --font-size-lg: 1.125rem;
      --font-size-xl: 1.25rem;
      --font-size-2xl: 1.5rem;
      --font-size-3xl: 1.875rem;

      /* 间距系统 */
      --spacing-xs: 0.25rem;
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
    }

    /* 基础重置 */
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: var(--font-family);
      font-size: var(--font-size-base);
      color: var(--color-text);
      background: var(--color-background);
      line-height: 1.5;
    }

    /* 通用组件样式 */
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

    .card {
      background: var(--color-background);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-md);
      padding: var(--spacing-lg);
    }

    /* 布局样式 */
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 var(--spacing-md);
    }

    .grid {
      display: grid;
      gap: var(--spacing-md);
    }

    .grid-2 { grid-template-columns: repeat(2, 1fr); }
    .grid-3 { grid-template-columns: repeat(3, 1fr); }
    .grid-4 { grid-template-columns: repeat(4, 1fr); }

    /* 页面切换 */
    .page { display: none; }
    .page.active { display: block; }

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
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
  </style>
</head>
<body>
  <!-- 页面内容 -->

  <script>
    // 简单的页面路由
    function showPage(pageId) {
      document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
      document.getElementById(pageId).classList.add('active');
    }

    // 模拟表单提交
    function handleSubmit(event) {
      event.preventDefault();
      // 显示成功状态
      alert('表单已提交（演示）');
    }
  </script>
</body>
</html>
```

## 保真度级别

| 级别 | 说明 | 输出 |
|:-----|:-----|:-----|
| `wireframe` | 线框图 | 灰度布局，无视觉样式 |
| `mockup` | 模型 | 完整视觉设计，静态页面 |
| `interactive` | 交互式 | 可点击、状态切换、表单演示 |

## 输出位置

```
context/prototypes/
├── {feature-name}.html      # 主原型文件
├── {feature-name}-styles.css # 独立样式文件（可选）
└── README.md                # 预览说明
```

## Quality Standards

生成原型前确保：
- [ ] 模式已确认（迭代/新产品）
- [ ] 迭代模式：已收集并分析现有 UI
- [ ] 新产品模式：已确认设计风格和颜色
- [ ] PRD 内容已读取并理解
- [ ] 用户流程已映射
- [ ] 生成 HTML 文件可在浏览器中打开
- [ ] 包含必要的交互演示

## 上下文集成

**读取:**
- `context/prd/*.md` - 需求文档
- 用户提供的截图/HTML（迭代模式）

**写入:**
- `context/prototypes/{feature-name}.html` - 生成的原型
- 更新 PRD 中的原型链接

## 使用示例

```
# 迭代模式
User: "基于现有首页生成新功能原型"
→ 询问现有 UI 提供方式
→ 提取样式
→ 生成匹配风格的原型

# 新产品模式
User: "为新产品创建原型"
→ 询问设计风格和颜色
→ 生成带样式的原型
```

## 预览说明

生成后向用户提供：

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
