# 原型文件说明

本目录用于存放生成的原型文件，支持两种格式。

## 支持格式

### HTML 原型
- 文件格式：`.html`
- 预览方式：双击文件在浏览器中打开
- 用途：快速验证、演示给干系人

### Pencil 设计稿
- 文件格式：`.pen`
- 预览方式：在 Pencil 应用中打开
- 用途：专业设计、开发对接、设计资产管理

## Pencil .pen 文件格式规范

有效的 .pen 文件必须包含以下必需字段：

```json
{
  "version": "1.0.0",
  "children": [...]
}
```

**必需字段说明：**
- `version`: 字符串，表示 .pen 格式版本（如 "1.0.0"）
- `children`: 数组，包含所有顶层节点

**如果缺少 version 或 children 字段，文件无法在 Pencil 应用中打开！**

**常见问题排查：**

| 错误现象 | 可能原因 | 解决方法 |
|:---------|:---------|:---------|
| "Unsupported file format" | 缺少 version 字段 | 重新生成文件 |
| 文档打开但为空 | children 为空数组 | 添加至少一个顶层 Frame |
| 无法编辑节点 | 节点结构无效 | 检查操作代码 |

## 使用说明

### HTML 原型预览
```bash
open context/prototypes/{文件名}.html
```

### Pencil 设计稿预览
```bash
# 方式 1: 在 Pencil 应用中打开
open -a Pencil context/prototypes/{文件名}.pen

# 方式 2: 查看预览截图
open context/prototypes/{文件名}-preview.png
```

### 验证步骤（生成后必做）

```bash
# 1. 检查文档状态
# 确认有顶层节点，不是 "No nodes are selected."

# 2. 生成截图预览
# 保存为 {feature-name}-preview.png

# 3. 尝试在 Pencil 应用中打开
# 用户手动打开 .pen 文件验证
```

## 命名规范

- HTML 原型：`{feature-name}.html`（如 `user-profile.html`）
- Pencil 设计稿：`{feature-name}.pen`（如 `user-profile.pen`）
- 预览截图：`{feature-name}-preview.png`

## 文件内容说明

### HTML 原型
- 完整的 HTML 结构
- 内联 CSS 样式
- 基础 JavaScript 交互
- 响应式布局

### Pencil 设计稿
- 结构化设计数据（JSON 格式）
- 版本信息（`version` 字段）
- 顶层节点数组（`children` 字段）
- 设计系统组件
- 支持导出代码（React/Vue/Svelte）
