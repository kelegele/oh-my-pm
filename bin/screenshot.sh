#!/usr/bin/env bash
# 跨平台截图脚本
# 用于在 TUI 环境下快速截取屏幕并保存为图片文件
#
# 使用方法:
#   ./bin/screenshot.sh                    # 保存到 ~/screenshot.png
#   ./bin/screenshot.sh ~/ui.png          # 保存到指定路径
#   ./bin/screenshot.sh -c                # 从粘贴板获取 (macOS)

set -e

# 默认输出路径
DEFAULT_OUTPUT="$HOME/screenshot.png"
OUTPUT="${1:-$DEFAULT_OUTPUT}"

# 展开波浪号
OUTPUT="${OUTPUT/#\~/$HOME}"

# 粘贴板模式 (仅 macOS)
if [[ "$1" == "-c" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        OUTPUT="${2:-$DEFAULT_OUTPUT}"
        OUTPUT="${OUTPUT/#\~/$HOME}"

        if command -v pngpaste &> /dev/null; then
            pngpaste "$OUTPUT"
            echo "✓ 粘贴板图片已保存: $OUTPUT"
            exit 0
        else
            echo "✗ pngpaste 未安装"
            echo "  安装: brew install pngpaste"
            exit 1
        fi
    else
        echo "✗ 粘贴板模式仅支持 macOS"
        exit 1
    fi
fi

# 检测操作系统并执行相应截图命令
case "$(uname)" in
    Darwin)
        # macOS
        screencapture -i "$OUTPUT"
        ;;
    Linux)
        # Linux - 检测可用的截图工具
        if command -v import &> /dev/null; then
            # ImageMagick
            import "$OUTPUT"
        elif command -v gnome-screenshot &> /dev/null; then
            # gnome-screenshot
            gnome-screenshot -a -f "$OUTPUT"
        elif command -v spectacle &> /dev/null; then
            # KDE spectacle
            spectacle -r -o "$OUTPUT"
        elif command -v scrot &> /dev/null; then
            # scrot
            scrot -s "$OUTPUT"
        else
            echo "✗ 未找到可用的截图工具"
            echo ""
            echo "请安装其中一个:"
            echo "  sudo apt install imagemagick    # import 命令"
            echo "  sudo apt install gnome-screenshot"
            echo "  sudo apt install spectacle"
            echo "  sudo apt install scrot"
            exit 1
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        # Windows/Git Bash
        echo "✗ Windows 环境请使用系统截图工具:"
        echo "  Win + Shift + S (Windows 10/11)"
        echo "  然后手动保存到: $OUTPUT"
        exit 1
        ;;
    *)
        echo "✗ 不支持的操作系统: $(uname)"
        exit 1
        ;;
esac

# 检查文件是否创建成功
if [[ -f "$OUTPUT" ]]; then
    FILE_SIZE=$(stat -f%z "$OUTPUT" 2>/dev/null || stat -c%s "$OUTPUT" 2>/dev/null)
    echo "✓ 截图已保存: $OUTPUT (${FILE_SIZE} bytes)"
    echo ""
    echo "在 Claude Code 中使用:"
    echo "  \"分析这个 UI 截图: $OUTPUT\""
else
    echo "✗ 截图保存失败"
    exit 1
fi
