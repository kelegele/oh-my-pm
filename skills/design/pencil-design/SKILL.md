---
name: pencil-design
description: 使用 Pencil MCP 生成专业设计稿（.pen 文件）。支持结构化设计数据、设计系统组件和代码导出。当用户选择 Pencil 格式时使用，或明确需要专业设计工具集成时激活。
layer: design
input-from: prd-gen,user-research
output-to: project-coordination,requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.7.0
---

# Pencil Design

使用 Pencil MCP 生成专业设计稿（.pen 文件），支持结构化设计数据、专业设计工具和代码导出。

## What This Skill Does

生成交互式设计稿（.pen 文件），用于专业设计场景、设计资产管理和开发对接。

## When to Use

激活此 skill 当：
- 用户选择 **Pencil 设计稿**格式时
- PRD 生成后用户选择 Pencil 格式
- 明确需要专业设计工具、设计系统或代码导出
- 用户说"Pencil"、"设计稿"、".pen 文件"

## Pencil MCP 环境配置 (CRITICAL - 第一优先级)

**生成任何 Pencil 设计稿前，必须先完成环境检查：**

### Step P1: 提示用户提供 Token Key

```markdown
### Q: Pencil MCP 配置

Pencil 需要认证才能使用设计功能。请提供：

1. **Token Key** - 从 Pencil 获取的认证密钥
2. **环境变量保存位置** - 默认 ~/.env 或 ~/.zshrc

需要我帮你配置吗？
```

**Token Key 验证：**
- Token 应该是 64 字符十六进制格式
- 必须从 Pencil.app 账号页面获取
- 有效期通常为 90 天

**如果用户无法提供：**
- 跳过 Pencil MCP 环境配置
- 降级到 HTML 原型格式

### Step P2: 引导用户配置 Pencil MCP

```markdown
## Pencil MCP 服务器配置

### 方式一：本地运行（推荐）

```bash
# 安装 Pencil CLI
npm install -g @pencil/cli

# 启动 MCP 服务器
pencil mcp-server
```

### 方式二：Docker 运行

```bash
docker run -d -p 3000:3000 pencil/mcp-server
```

### 配置 Claude Code

编辑 `~/.claude/mcp_settings.json`：

```json
{
  "mcpServers": {
    "pencil": {
      "command": "npx",
      "args": ["-y", "@pencil/mcp-server"],
      "env": {
        "PENCIL_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### Step P3: 测试连接

配置完成后，必须测试连接：

**测试连接：**
```python
mcp__pencil__get_editor_state(include_schema=False)
```

**测试创建新文档：**
```python
try:
    mcp__pencil__open_document(filePathOrTemplate="new")
    print("✅ Pencil MCP 连接成功")
except Exception as e:
    if "权限" in str(e) or "permission" in str(e).lower():
        print("❌ 权限不足，需要开通 Pencil 高级功能")
        print("📌 请访问 https://pencil.app/pricing 开通权限")
        return False
    else:
        print(f"❌ 连接失败: {e}")
        return False
```

**权限不足处理：**

```markdown
### ⚠️ Pencil 权限不足

当前账户缺少以下权限：
- ❌ 创建设计文件
- ❌ 使用设计系统组件
- ❌ 导出代码

### 解决方案
1. 访问 https://pencil.app/account
2. 开通 Pro 或 Team 计划
3. 重新获取 Token Key 并更新环境变量
4. 重启 Claude Code

完成后请回复「重新测试」进行验证。
```

**环境检查清单：**
- [ ] 用户提供了 Token Key
- [ ] Token Key 已保存到环境变量
- [ ] Pencil MCP 服务器已启动/配置
- [ ] MCP 配置已添加到 ~/.claude/mcp_settings.json
- [ ] 连接测试通过
- [ ] 权限检查通过

**只有以上所有检查通过后，才能进入后续步骤。**

## 设计稿生成工作流

### Step P4: 获取设计指南

```python
# 获取设计指南
mcp__pencil__get_guidelines(topic="web-app")  # 或 mobile-app/landing-page

# 获取可用风格标签
mcp__pencil__get_style_guide_tags()

# 获取指定风格指南
mcp__pencil__get_style_guide(tags=["minimal", "professional"])
```

**Pencil 设计原则（来自 web-app）：**
- **Purpose First**: 每个屏幕有明确的单一目的和主导区域
- **Understandability**: 界面自解释，标签清晰，图标不替代文字
- **Progressive Disclosure**: 逐步揭示复杂度
- **Action Hierarchy**: 层级化动作（主/次/破坏性）
- **System Status Visibility**: 支持加载/空/错误/成功/权限状态
- **Responsiveness**: 移动端单列、桌面端多区域

### Step P5: 构建设计结构

使用 `mcp__pencil__batch_design` 执行批量操作（单次最多 25 个操作）：

```javascript
// 操作示例
document = "document"  // 根节点绑定

// 创建页面
mainScreen = I(document, {
  type: "frame",
  name: "Main Screen",
  layout: "vertical",
  gap: 24,
  padding: 32
})

// 创建标题
title = I(mainScreen, {
  type: "text",
  content: "Feature Name",
  fontSize: 32,
  fontWeight: "700"
})

// 创建卡片
card1 = I(mainScreen, {type: "frame", layout: "vertical", ...})
card2 = I(mainScreen, {type: "frame", layout: "vertical", ...})

// 创建按钮
button = I(card1, {type: "text", content: "Submit", ...})
```

**常用操作：**
- `I(parent, data)` - 插入节点
- `C(path, parent, options)` - 复制节点
- `R(path, data)` - 替换节点
- `U(path, data)` - 更新节点属性
- `D(nodeId)` - 删除节点
- `M(nodeId, parent, index)` - 移动节点
- `G(nodeId, type, prompt)` - 生成图片填充

### Step P6: 验证设计

```python
# 获取截图验证
mcp__pencil__get_screenshot(nodeId="screen-id")

# 检查布局
mcp__pencil__snapshot_layout(maxDepth=3, problemsOnly=False)
```

### Step P7: 输出设计稿

```markdown
- 保存到 `context/prototypes/{feature-name}.pen`
- 生成预览截图 `context/prototypes/{feature-name}-preview.png`
- 更新 PRD 中的原型链接
```

## 输出格式

**Pencil 设计稿保真度级别：**

| 级别 | 说明 | 输出 |
|:-----|:-----|:-----|
| `basic` | 线框图，结构清晰 | 基础布局，组件对齐 |
| `mockup` | 模型，视觉完整 | 完整设计，视觉专业 |
| `interactive` | 交互式，可点击 | 可交互，演示流程 |

**输出位置：**

```
context/prototypes/
├── {feature-name}.pen           # Pencil 设计稿
├── {feature-name}-preview.png    # 预览截图
└── README.md                   # 使用说明
```

## Quality Standards

生成设计稿前确保：
- [ ] Pencil MCP 环境配置完成（所有检查项通过）
- [ ] Pencil MCP 连接测试通过
- [ ] 获取了设计指南和风格指南
- [ ] 设计结构基于 PRD 内容
- [ ] 生成文件可在 Pencil 应用中打开
- [ ] 包含必要的组件和交互
- [ ] 设计原则符合 web-app 规范

## 上下文集成

**读取:**
- `context/prd/*.md` - 需求文档
- Pencil 设计指南（自动获取）

**写入:**
- `context/prototypes/{feature-name}.pen` - Pencil 设计稿
- `context/prototypes/{feature-name}-preview.png` - 预览截图
- 更新 PRD 中的原型链接

## 使用示例

````
# Pencil 设计稿生成
User: "为新产品创建 Pencil 设计稿"
→ 检查 Pencil MCP 环境
→ 询问设计风格和颜色
→ 生成 Pencil 设计稿
→ 生成预览截图
```

## 与 HTML 原型对比

| 特性 | HTML 原型 | Pencil 设计稿 |
|:-----|:-----|:-----|
| 工具依赖 | 无 | Pencil MCP（需配置） |
| 设计工具 | Claude Code | Pencil 应用 |
| 保真度 | 3 级（基础/视觉/交互） | basic/mockup/interactive |
| 编辑能力 | 手动编辑 HTML 文件 | 在 Pencil 应用中编辑 |
| 专业设计系统 | ❌ | ✅ 组件库 + 样式系统 |
| 代码导出 | ❌ | ✅ 支持 React/Vue/Svelte |
| 设计资产管理 | ❌ | ✅ .pen 文件作为设计资产 |
| 适用场景 | 快速验证、演示 | 专业设计、开发对接 |
