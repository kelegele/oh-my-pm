# 项目记忆 - Oh-My-PM

## 项目概述

Oh-My-PM 是基于 **Claude Code Skill 插件** 的产品经理 AI Agent 工作流系统。

**核心理念**: 轻量级实现，不构建完整系统，而是通过 Agent 插件和工作流形式落地。

---

## 本次开发会话总结

**日期**: 2026-03-11

**完成内容**:
1. ✅ 项目初始化和 MVP Skills 实现 (4个)
2. ✅ 测试框架建立
3. ✅ GitHub 仓库创建和发布
4. ✅ 项目管理体系建立 (Issues + Project Board)
5. ✅ 文档体系完善

---

## 关键技术决策

### 1. 技术选型: Claude Code Skills

**为什么选择 Skills 而非独立系统**:
- 用户明确要求 "Agent 插件、workfl 等形式落地"
- 轻量级，无需部署后端
- 直接集成到 Claude Code 开发体验
- 可通过 YAML frontmatter 定义触发条件

**关键文件**: `.claude/skills/*/SKILL.md`

### 2. 目录结构

```
.claude/skills/           # Claude Code 工具技能
└── skill-creator/        # 官方 skill 创建工具

skills/                   # 生产 Skills (项目核心)
├── perception/           # 第一层：需求感知
├── strategy/             # 第二层：策略规划
├── design/               # 第三层：方案设计
├── delivery/             # 第四层：交付协调
├── validation/           # 第五层：价值验证
└── workflows/            # 跨层工作流编排

context/                  # Skills 间数据共享
```

**教训**: 最初混淆了 `.claude/skills/` 的用途
- `.claude/skills/` = Claude Code 工具 (如 skill-creator)
- `skills/` = 项目生产代码

### 3. Skill 描述原则

来自 `anthropics/skills` 的最佳实践:

```yaml
---
description: >
  Use this skill whenever...  # 主动告诉 Claude 何时使用
  Activate when...            # 列出触发场景
  Even if they don't say...   # 包含隐性触发词
---
```

**关键要素**:
- **Pushy Description**: 主动而非被动
- **Explain Why Not Must**: 解释为什么需要，而非必须做什么
- **Progressive Disclosure**: 简单到详细
- **Concrete Examples**: 具体输入输出示例

---

## GitHub Project 管理经验

### 1. GitHub CLI 权限问题

**问题**: 创建 Project Board 需要额外 scope

**解决**:
```bash
gh auth refresh -h github.com -s project,read:project
```

**教训**: 提前检查所需权限，避免中途卡住

### 2. Issue 批量创建

**有效模式**:
```bash
# 使用 shell 数组批量创建
issues=(
  "title|label|body"
  "title|label|body"
)

for issue in "${issues[@]}"; do
  IFS='|' read -r title label body <<< "$issue"
  gh issue create --title "$title" --label "$label" --body "$body"
done
```

### 3. Project Board 链接

**发现**: 创建 Project 后需要显式链接到仓库

```bash
gh project link <number> --repo owner/repo
```

---

## Context 文件系统设计

### 设计原则

1. **JSON 用于结构化数据** - 便于解析和验证
2. **Markdown 用于文档** - 便于人类阅读
3. **统一前缀** - 便于查找和管理

### 文件清单

| 文件 | 格式 | 用途 | 读写 Skills |
|:-----|:-----|:-----|:------------|
| competitive-analysis.json | JSON | 竞品分析结果 | competitive-analysis→, prd-gen← |
| prd-draft.md | Markdown | PRD 文档 | prd-gen→ |
| iteration-plan.json | JSON | 迭代计划 | iteration-planning→ |
| current-workflow.json | JSON | 工作流状态 | 全部 |

### 教训

**问题**: Write 工具要求先 Read 文件

**解决**:
```bash
# 创建空文件
touch context/file.json

# 或在代码中先读取再写入
```

---

## 测试策略

### 自动化测试

**tests/test-skills.sh** 验证:
- 文件存在性
- YAML frontmatter 格式
- 必需字段 (name, description)

### 手动测试

**docs/testing-guide.md** 定义测试用例:
- 触发测试
- 输出质量测试
- 工作流集成测试

**局限**: Skill 触发有 LLM 随机性，无法完全自动化

---

## 五层架构设计

```
┌─────────────────────────────────────────────────┐
│  Perception Layer (需求感知)                    │
│  market-intelligence, user-research,            │
│  competitive-analysis, data-monitoring          │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  Strategy Layer (策略规划)                      │
│  product-positioning, roadmap-planning,         │
│  prioritization                                 │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  Design Layer (方案设计)                        │
│  prd-gen, prototype-design,                     │
│  process-optimization                           │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  Delivery Layer (交付协调)                      │
│  requirement-review, project-coordination,      │
│  release-management                             │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│  Validation Layer (价值验证)                    │
│  impact-analysis, feedback-synthesis,           │
│  iteration-planning ──→ 反馈闭环 ──→            │
└─────────────────────────────────────────────────┘
```

**核心思想**: iteration-planning 读取 impact-analysis 和 feedback-synthesis，发现新问题后重新触发 perception 层 skills

---

## 人机协作模式

| 模式 | 描述 | 适用场景 | Skill 实现 |
|:-----|:-----|:---------|:-----------|
| autopilot | AI 自动执行 | 数据汇总、报告生成 | 无需确认，直接写入 context |
| copilot | AI 建议，人工确认 | 方案设计、优先级排序 | 生成结果，等待用户确认 |
| manual | 人工主导，AI 辅助 | 战略决策、创意工作 | 提供模板，用户填写 |

---

## Git 工作流

### Commit 规范

```
<type>: <description>

[optional body]
```

Types: feat, fix, docs, refactor, test, chore

### 示例

```
feat: add prototype-design skill
fix: resolve context file permission issue
docs: update roadmap with v0.2.0 milestones
```

---

## 常见问题

### Q: Skill 触发率低怎么办？

**A**: 优化 description
- 添加更多触发短语
- 包含同义词
- 添加 "Even if they don't say..." 条款

### Q: 如何测试 Skill？

**A**: 两种方式
1. 在 Claude Code 中直接对话测试
2. 运行 `./tests/test-skills.sh` 验证结构

### Q: Context 文件格式如何定义？

**A**:
- 结构化数据用 JSON (便于解析)
- 文档用 Markdown (便于阅读)
- 在 SKILL.md 中定义 schema

---

## 下一步计划

| 版本 | 目标 | 状态 |
|:-----|:-----|:-----|
| v0.1.0 | MVP (4 Skills) | ✅ 完成 |
| v0.2.0 | Design Layer 扩展 | 🔄 Issues #1, #2 |
| v0.3.0 | Perception Layer | ⏳ Issues #3-#5 |
| v0.4.0 | Strategy Layer | ⏳ Issues #6-#8 |
| v0.5.0 | Delivery Layer | ⏳ Issues #9-#11 |
| v0.6.0 | Validation Layer 扩展 | ⏳ Issue #12 |
| v1.0.0 | Full Cycle Workflow | ⏳ Issue #14 |

---

## 资源链接

- **GitHub**: https://github.com/kelegele/oh-my-pm
- **Project Board**: https://github.com/users/kelegele/projects/4
- **Claude Code**: https://claude.ai/code
- **anthropics/skills**: https://github.com/anthropics/skills
