# Oh-My-PM 测试指南

## 概述

Oh-My-PM 是 Claude Code Skill 插件项目，测试主要验证：
1. Skills 能否正确触发
2. Skills 能否正确执行并生成预期输出
3. Context 文件读写是否正常
4. 工作流编排是否正确

## 测试方式

### 方式一：手动测试（推荐快速验证）

直接在 Claude Code 中调用 Skills：

```bash
# 测试竞品分析
"分析一下淘宝和京东的个人中心功能"

# 测试 PRD 生成
"写一个暗色主题功能的 PRD"

# 测试快速 PRD 工作流
"快速生成带竞品对比的 PRD：用户个人中心改版，对比淘宝和京东"

# 测试迭代规划
"规划 Sprint 13，基于以下反馈：登录页面有用户反馈崩溃"
```

### 方式二：使用 Skill 内置触发测试

每个 Skill 应该在 `When to Use` 部分列出了触发条件。验证这些条件：

| Skill | 触发测试 |
|:---|:---|
| competitive-analysis | "XX产品有什么功能？" |
| prd-gen | "写一个PRD文档" / "记录这个需求" |
| iteration-planning | "下个迭代做什么？" |

### 方式三：单元测试 Context Schema

验证 JSON 文件格式是否正确：

```bash
# 安装 JSON 验证工具
npm install -g ajv-cli

# 验证 context 文件
ajv validate -s skills/perception/competitive-analysis/schema.json -d context/competitive-analysis.json
```

### 方式四：集成测试工作流

测试完整的 `/quick-prd` 工作流：

```bash
# 输入
requirements = "用户中心页面改版"
competitors = ["淘宝", "京东"]

# 预期输出
1. context/competitive-analysis.json - 包含功能对比矩阵
2. context/prd-draft.md - 包含完整 PRD 文档
3. context/current-workflow.json - 状态为 "completed"
```

## 测试用例模板

在 `tests/` 目录下创建测试用例：

```markdown
# test-cases.md

## Test Case 1: Competitive Analysis
**Input**: "分析 Notion 和飞书文档的核心功能差异"

**Expected**:
- [ ] Skill 被触发
- [ ] 生成功能对比矩阵
- [ ] 列出 3+ 条差异化建议
- [ ] context/competitive-analysis.json 有效

## Test Case 2: PRD Generation
**Input**: "为暗色主题功能写一个 PRD，目标是夜间使用场景"

**Expected**:
- [ ] Skill 被触发
- [ ] PRD 包含 6 个必选章节
- [ ] 包含 3+ 个用户故事
- [ ] 包含 3+ 个成功指标
- [ ] context/prd-draft.md 已生成

## Test Case 3: Quick PRD Workflow
**Input**: "快速 PRD：批量导出功能，对比 Excel 和 Google Sheets"

**Expected**:
- [ ] 工作流被触发
- [ ] 先执行 competitive-analysis
- [ ] 再执行 prd-gen
- [ ] PRD 中引用了竞品分析结果
- [ ] 两个 context 文件都已更新
```

## 测试检查清单

### Skill 触发测试

- [ ] 描述了功能但未说 "竞品分析" → 触发 competitive-analysis
- [ ] 直接说 "对比 XX 和 YY" → 触发 competitive-analysis
- [ ] 说 "写个 PRD" → 触发 prd-gen
- [ ] 说 "下个迭代做什么" → 触发 iteration-planning

### 输出质量测试

- [ ] JSON 文件格式有效
- [ ] Markdown 报告结构完整
- [ ] 包含预期的示例输出
- [ ] Context 文件可被下游 Skill 读取

### 工作流测试

- [ ] 多 Skill 按正确顺序执行
- [ ] Context 在 Skills 间正确传递
- [ ] 错误处理正常工作
- [ ] 工作流状态正确更新

## 调试技巧

### 1. 检查 Skill 是否加载

Claude Code 会自动加载 `.claude/skills/` 下的 Skills。验证：

```bash
ls -la .claude/skills/
```

### 2. 查看生成的 Context 文件

```bash
# 查看 context 目录
cat context/competitive-analysis.json
cat context/prd-draft.md
cat context/current-workflow.json
```

### 3. 手动清理 Context

重新测试前清理状态：

```bash
rm -f context/*.json context/*.md
```

### 4. 验证 Skill 语法

检查 SKILL.md 的 YAML frontmatter 格式：

```bash
# 安装 YAML 验证工具
npm install -g yaml-validator

# 验证
yaml-validator skills/perception/competitive-analysis/SKILL.md
```

## 已知限制

1. **触发不确定性**: LLM 触发 Skills 有一定随机性，同样的输入可能不会总是触发
2. **环境依赖**: 需要在 Claude Code 环境中测试，普通终端无法完整测试
3. **输出质量**: LLM 生成的 PRD 质量取决于输入详细程度

## 下一步

1. 手动测试 MVP 的 3 个 Skills
2. 根据测试结果调整 description 提高触发率
3. 添加更多测试用例
4. 考虑添加自动化测试（如使用 expect 脚本）
