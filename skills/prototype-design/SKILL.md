---
name: prototype-design
description: 创建交互式原型以验证设计方案。支持 HTML 原型输出格式。当用户需要设计 UI/UX、创建原型、设计用户流程，或说"创建原型"、"设计这个功能"、"UI 原型"时使用。支持迭代模式（基于现有样式）和新产品模式（自定义设计规范）。
layer: design
input-from: prd-gen,user-research
output-to: project-coordination,requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.6.1
---

# Prototype Design

生成交互式原型，可视化设计方案并进行早期验证。支持 **HTML 原型**输出格式。

## What This Skill Does

生成原型文件，用于可视化设计方案并进行早期验证。支持两种输出格式：

1. **HTML 原型**：独立 HTML 文件，可在浏览器中直接打开预览

支持两种模式：
- **迭代模式**：基于用户提供的截图或 HTML 文件，提取现有样式后生成匹配的新原型
- **新产品模式**：询问用户设计偏好后，使用默认或自定义设计规范生成原型

## When to Use

激活此 skill 当：
- PRD 生成后需要创建可视化原型
- 用户说"创建原型"、"设计这个功能"、"UI 原型"
- 需要验证用户流程或交互模式
- 需要向干系人演示设计概念

---

## Step 0: 模式检测 (CRITICAL)

生成任何原型前，必须先检测场景模式：

使用 `AskUserQuestion` 确定模式：

```markdown
### Q: 请选择原型生成模式

| Option | Description |
|:-------|-------------|
| **迭代更新** | 基于现有产品样式生成（需要截图或 HTML 文件） |
| **新产品** | 创建全新设计（需要确认设计规范） |
```

---



## Step 2: 迭代模式工作流

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

从分析中提取并生成 Tailwind 颜色配置：

```javascript
// tailwind.config - 迭代模式从现有页面提取
tailwind.config = {
    theme: {
        extend: {
            colors: {
                primary: {
                    50: '{{PRIMARY_50}}',
                    500: '{{PRIMARY_500}}',
                    600: '{{PRIMARY_600}}',
                    700: '{{PRIMARY_700}}',
                },
                secondary: {
                    500: '{{SECONDARY_500}}',
                    600: '{{SECONDARY_600}}',
                }
            }
        }
    }
};
```

提取映射参考：
| 现有页面元素 | Tailwind 配置 |
|:-------------|:-------------|
| 主按钮背景色 | `colors.primary.600` |
| 主文字色 | 使用 `slate-900` / `slate-700` |
| 次要文字色 | 使用 `slate-500` / `slate-400` |
| 边框/分割线 | 使用 `slate-200` / `slate-100` |
| 背景色 | 使用 `slate-50` / `white` |
| 成功状态色 | 使用 `emerald-500` / `emerald-50` |
| 警告状态色 | 使用 `amber-500` / `amber-50` |
| 错误状态色 | 使用 `red-500` / `red-50` |

#### Step 2.2: 分析并提取样式

（使用步骤 2.1 收集的样式）

#### Step 2.3: 生成原型（根据格式选择）

**HTML 格式：**

使用提取的样式生成原型，选择合适的保真度级别：

| 保真度级别 | 说明 | 模板 |
|:---------|:-----|:-------|
| `wireframe` | 线框图，灰度布局，无视觉样式 | `templates/prototype/wireframe.html` |
| `mockup` | 完整视觉设计，带颜色和样式 | `templates/prototype/mockup.html` |
| `interactive` | 可交互的完整原型，带 JavaScript 交互 | `templates/prototype/interactive.html` |

生成到 `context/prototypes/{feature-name}.html`

**HTML 原型输出格式：**

所有模板默认使用 **TailwindCSS** 实用优先框架，通过 CDN 引入：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{FEATURE_NAME}} - 原型</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '{{PRIMARY_50}}', 100: '{{PRIMARY_100}}',
                            500: '{{PRIMARY_500}}', 600: '{{PRIMARY_600}}',
                            700: '{{PRIMARY_700}}',
                        }
                    },
                    animation: {
                        'fade-in': 'fadeIn 0.3s ease-out',
                        'slide-in': 'slideIn 0.3s ease-out',
                    },
                    keyframes: {
                        fadeIn: { '0%': { opacity: '0' }, '100%': { opacity: '1' } },
                        slideIn: { '0%': { transform: 'translateY(-10px)', opacity: '0' }, '100%': { transform: 'translateY(0)', opacity: '1' } },
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-slate-50 min-h-screen">
    <!-- 顶部导航 -->
    <header class="bg-white border-b border-slate-200 shadow-sm px-6 py-4">
        <h1 class="text-2xl font-bold text-slate-900">{{FEATURE_NAME}}</h1>
        <p class="text-slate-500 mt-1">{{FEATURE_DESCRIPTION}}</p>
    </header>

    <!-- 主内容 -->
    <main class="p-6">
        <div class="max-w-6xl mx-auto space-y-6">
            <!-- 统计卡片 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-5 hover:shadow-md transition-shadow">
                    <h3 class="text-sm font-medium text-slate-500 mb-2">指标名称</h3>
                    <p class="text-3xl font-bold text-slate-900">1,234</p>
                    <p class="text-sm text-emerald-600">↑ 12% <span class="text-slate-400 font-normal">较上周</span></p>
                </div>
            </div>

            <!-- 内容卡片 -->
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                <div class="px-6 py-4 border-b border-slate-200">
                    <h3 class="text-lg font-semibold text-slate-900">模块标题</h3>
                </div>
                <div class="p-6">模块内容</div>
            </div>
        </div>
    </main>
</body>
</html>
```

**TailwindCSS 组件类名参考** `templates/prototype/COMPONENTS.md`。

**常用类名速查**：
- 布局：`grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6`
- 卡片：`bg-white rounded-xl shadow-sm border border-slate-200 p-5 hover:shadow-md transition-shadow`
- 按钮：`px-4 py-2.5 text-sm font-medium text-white bg-primary-600 rounded-lg hover:bg-primary-700 transition-colors`
- 输入框：`w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500/20`
- 徽章：`inline-flex px-2.5 py-1 text-xs font-medium rounded-md bg-emerald-50 text-emerald-700`
- 响应式：`p-4 md:p-6 lg:p-8`、`hidden md:block`

---

## Step 3: 新产品模式工作流

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

#### Step 3.2: 确认主色调

```markdown
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

#### Step 3.3: 生成 Tailwind 配置

基于用户选择生成 Tailwind 配置：

```javascript
tailwind.config = {
    theme: {
        extend: {
            colors: {
                primary: {
                    50: '#f0f9ff', 100: '#e0f2fe', 200: '#bae6fd',
                    300: '#7dd3fc', 400: '#38bdf8', 500: '#0ea5e9',
                    600: '#0284c7', 700: '#0369a1', 800: '#075985', 900: '#0c4a6e',
                }
            },
            animation: {
                'fade-in': 'fadeIn 0.3s ease-out',
            },
            keyframes: {
                fadeIn: { '0%': { opacity: '0' }, '100%': { opacity: '1' } },
            }
        }
    }
};
```

**设计风格与主色映射**：
| 风格 | 主色 | Tailwind 色板 |
|:-----|:-----|:-------------|
| 简约现代 | 蓝色 | `sky` / `blue` |
| 商务专业 | 深蓝 | `slate` / `blue` |
| 活泼创意 | 紫色 | `violet` / `fuchsia` |
| 暗色主题 | 青蓝 | `cyan` / 深色 `slate` |

#### Step 3.4: 生成原型（根据格式选择）

**HTML 格式：**

使用默认样式配置生成到 `context/prototypes/{feature-name}.html`

选择合适的保真度级别：

| 保真度级别 | 说明 | 模板 |
|:---------|:-----|:-------|
| `wireframe` | 线框图，使用基础样式 |
| `mockup` | 完整视觉设计 |
| `interactive` | 交互式原型 |

---



### 保真度级别

| 级别 | 说明 | 输出 |
|:-----|:-----|
| `basic` | 线框图，结构清晰 | 基础布局，组件对齐 |
| `mockup` | 完整设计，视觉专业 | 完整设计，视觉专业 |
| `interactive` | 交互式，可点击 | 可交互，演示流程 |

### 输出位置

```
context/prototypes/
├── {feature-name}.html          # HTML 原型（可选）
└── README.md                   # 使用说明
```

---

## Quality Standards

### 质量检查清单

生成原型前确保：
- [ ] 迭代模式：已收集并分析现有 UI
- [ ] 新产品模式：已确认设计风格和颜色
- [ ] PRD 内容已读取并理解
- [ ] 用户流程已映射（页面列表 + 跳转关系）
- [ ] 保真度级别已选择（wireframe/mockup/interactive）
- [ ] 使用正确的模板文件
- [ ] 组件来自标准组件库
- [ ] **生成文件可在浏览器中正常打开**
- [ ] 包含必要的交互演示
- [ ] HTML 使用提取的样式或用户选择的配色

### 质量标准参考

详细的质量标准请参考：
- **组件规范**: `templates/prototype/COMPONENTS.md`
- **质量标准**: `templates/prototype/QUALITY-STANDARDS.md`

### 质量评分

生成完成后进行自评：
- **视觉质量** (0-10 分): 设计一致性、层级清晰、对齐精确、留白适当、配色和谐
- **交互质量** (0-10 分): 反馈即时、状态清晰、过渡流畅、导航直观、操作可撤销
- **代码质量** (0-10 分): 语义化 HTML、结构清晰、无语法错误、性能优化、可访问性

**综合评分** = 视觉×0.4 + 交互×0.4 + 代码×0.2

- 9-10 分：优秀原型，可直接使用
- 7-8 分：  良好原型，建议优化
- 5-6 分：  可用原型，需要改进
- 0-4 分：  不可用，需要重做

---

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
```

> **Standalone install note**: Template files (`templates/prototype/`) are available with the full oh-my-pm plugin install. If installed standalone, the component and quality standards defined above serve as the reference.

---

