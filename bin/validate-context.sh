#!/bin/bash
# Oh-My-PM 运行期上下文自检工具
# 按传入 JSON 文件的 basename 在 contracts/ 中查找 <name>.schema.json 并校验
# （复用 tests/validate_contracts.py 的单文件模式：顶层 required 存在性 + 类型检查）。
#
# 用法:
#   bin/validate-context.sh <json-file>
# 示例:
#   bin/validate-context.sh docs/product/.ompm/current-workflow.json
#
# 退出码: 0 = 通过; 1 = 校验失败; 2 = 文件不存在 / 无对应 schema / JSON 非法

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <json-file>" >&2
    echo "  e.g. $0 docs/product/.ompm/current-workflow.json" >&2
    exit 2
fi

exec python3 "$PROJECT_ROOT/tests/validate_contracts.py" "$1"
