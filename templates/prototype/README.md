# HTML 原型模板

本目录提供 `prototype-design` Skill 使用的 HTML 原型模板与配套规范。所有模板均为独立 HTML 文件，基于 Tailwind CSS（CDN 引入），使用 CSS 变量定义配色，正文中的 `{{FEATURE_NAME}}` 等占位符在生成时替换。

## 三档保真度模板

| 模板 | 保真度 | 适用场景 |
|:-----|:-------|:---------|
| `wireframe.html` | 低保真线框图 | 灰度布局、虚线边框，用于结构验证和信息架构确认 |
| `mockup.html` | 中保真视觉稿 | 完整视觉设计，用于设计评审和品牌对齐 |
| `interactive.html` | 高保真交互原型 | 支持页面切换、弹窗等交互，用于用户测试和开发参考 |

## 配套规范

- **`COMPONENTS.md`** — 标准 UI 组件库：基础组件（Button/Input/Select 等）、布局组件（Container/Grid/Card 等）、导航组件、数据展示、反馈组件、表单组件，每个组件附使用示例与适用场景。
- **`QUALITY-STANDARDS.md`** — 原型质量标准："优秀原型"的定义（视觉/交互/代码三个维度）、生成前中后检查清单、0-10 分评分表与常见问题解决方法。

## 使用方式

模板不直接手工编辑使用，而是由 `prototype-design` Skill 在生成原型时引用：

1. Skill 根据需求选择保真度档位（wireframe / mockup / interactive）
2. 套用对应模板，并参考 `COMPONENTS.md` 组装界面组件
3. 按 `QUALITY-STANDARDS.md` 的检查清单做质量校验
4. 输出到 `docs/product/prototypes/{feature-name}.html`

也可以直接用自然语言触发，例如："帮我设计 XX 功能的原型"、"创建一个交互原型"。
