# TUI 环境下的图片处理指南

> 本文件是 prd-gen 的懒加载参考，TUI 环境下用户提供图片时读取。

在终端 (TUI) 环境下，用户可以通过以下方式提供图片：

#### 方式一：本地文件路径（最简单）

直接提供图片的本地路径，使用 Read 工具读取：

```bash
# 用户对话示例
"分析这个 UI 截图: /Users/fh/Desktop/screenshot.png"
"当前界面: ~/Screenshots/ui-2025-03-12.png"
"参考图片: ./docs/product/images/reference.png"
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

使用宿主可用的图片理解能力读取远程图片（Claude Code 中为 `mcp__4_5v_mcp__analyze_image` / `mcp__zai-mcp-server__ui_to_artifact` 等 MCP 工具；其他宿主用自带读图能力）。

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
2. **远程 URL** → 使用宿主可用的图片理解能力读取（Claude Code 中为 `mcp__4_5v_mcp__analyze_image` / `mcp__zai-mcp-server__ui_to_artifact` 等 MCP 工具；其他宿主用自带读图能力）
3. **分析图片内容** → 提取 UI 结构、布局、交互元素
4. **生成 PRD** → 基于图片分析结果生成需求文档
