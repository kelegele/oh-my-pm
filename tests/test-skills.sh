#!/bin/bash
# Oh-My-PM Skills Test Runner
# 简单的测试脚本，验证 Skills 基本结构

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$PROJECT_ROOT/skills"
CONTEXT_DIR="$PROJECT_ROOT/context"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# 测试函数
test_skill_file() {
    local skill_file="$1"
    local skill_name=$(basename "$(dirname "$skill_file")")

    echo -n "Testing $skill_name... "

    # 检查文件存在
    if [ ! -f "$skill_file" ]; then
        echo -e "${RED}FAILED${NC} - File not found"
        ((FAILED++))
        return 1
    fi

    # 检查 YAML frontmatter
    if ! grep -q "^---" "$skill_file"; then
        echo -e "${RED}FAILED${NC} - Missing YAML frontmatter"
        ((FAILED++))
        return 1
    fi

    # 检查必需字段
    if ! grep -q "^name:" "$skill_file"; then
        echo -e "${RED}FAILED${NC} - Missing 'name' field"
        ((FAILED++))
        return 1
    fi

    if ! grep -q "^description:" "$skill_file"; then
        echo -e "${RED}FAILED${NC} - Missing 'description' field"
        ((FAILED++))
        return 1
    fi

    echo -e "${GREEN}PASSED${NC}"
    ((PASSED++))
    return 0
}

test_context_files() {
    echo -n "Testing context directory... "

    if [ ! -d "$CONTEXT_DIR" ]; then
        echo -e "${YELLOW}SKIPPED${NC} - Context directory not found"
        return 0
    fi

    # 检查必需的 context 文件
    local required_files=(
        "current-workflow.json"
        "prd-draft.md"
    )

    for file in "${required_files[@]}"; do
        if [ ! -f "$CONTEXT_DIR/$file" ]; then
            echo -e "${YELLOW}WARNING${NC} - Missing $file"
        fi
    done

    echo -e "${GREEN}OK${NC}"
}

# 测试所有 MVP Skills
echo "======================================"
echo "Oh-My-PM Skills Test"
echo "======================================"
echo ""

echo "Testing MVP Skills..."
echo ""

test_skill_file "$SKILLS_DIR/perception/competitive-analysis/SKILL.md"
test_skill_file "$SKILLS_DIR/design/prd-gen/SKILL.md"
test_skill_file "$SKILLS_DIR/validation/iteration-planning/SKILL.md"
test_skill_file "$SKILLS_DIR/workflows/quick-prd/SKILL.md"

echo ""
test_context_files

echo ""
echo "======================================"
echo "Test Results"
echo "======================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
