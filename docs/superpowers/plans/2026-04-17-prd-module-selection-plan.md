# PRD 内容模块选择功能实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 prd-gen skill 的 PRD 生成前增加章节选择环节，让用户多选确认要生成的内容模块，并明确排除技术方案和接口定义。

**Architecture:** 在现有 SKILL.md 的 Step 0.5（PRD Plan）环节中插入章节选择步骤，复用已有的 AskUserQuestion 多组展示机制和审批流程。PRD 生成时根据用户选择动态包含/排除章节。

**Tech Stack:** Markdown skill definitions, Claude Code AskUserQuestion tool

---

### Task 1: 新增 Step 0.6 章节选择环节

**Files:**
- Modify: `skills/design/prd-gen/SKILL.md` (在 "Information Gap Analysis & PRD Plan" 的 User Approval 之前插入新步骤)

- [ ] **Step 1: 在 SKILL.md 中 Step 0.5 的 "5. User Approval" 之前插入章节选择步骤**

在现有的 "4. Generate PRD Plan" 和 "5. User Approval" 之间插入以下内容：

```markdown
4.5. **Chapter Selection** (HARD GATE — Before presenting PRD Plan):

Present chapter selection to user via `AskUserQuestion` with multiSelect. Due to the 4-option limit, split into 3 sequential questions:

**Question 1 — Core Chapters (第0-3章):**
```
| Option | Default | Description |
|:-------|:--------|:------------|
| 第0章 行业对标分析 | ✅ Selected | Research benchmark products and best practices |
| 第1章 项目概述 | ✅ Selected | Project background, objectives, scope |
| 第2章 业务分析 | ✅ Selected | Target users, pain points, market analysis |
| 第3章 功能需求 | ✅ Selected | Feature list, user stories, detailed requirements |
```

**Question 2 — Extended Chapters (第4-6章):**
```
| Option | Default | Description |
|:-------|:--------|:------------|
| 第4章 非功能性需求 | ✅ Selected | Performance, security, availability, compatibility |
| 第5章 用户体验流程 | ✅ Selected | User journey, page flow diagrams |
| 第6章 项目风险 | ✅ Selected | Project risks and mitigation strategies |
| 第7章 合规建议 | ⬜ Not selected | Compliance guidelines and risk categories |
```

**Question 3 — Optional Chapters (第8-9章):**
```
| Option | Default | Description |
|:-------|:--------|:------------|
| 第8章 原型设计 | ⬜ Not selected | Prototype links and design notes |
| 第9章 成功指标 | ⬜ Not selected | North star, process, and outcome metrics |
| (No more chapters) | — | — |
| (No more chapters) | — | — |
```

After collecting selections, build the `selected_chapters` list and `excluded_chapters` list.

**Important:** Inform the user of the following permanent exclusions (these are NOT in the selection list and will NEVER be generated):
- 技术方案 / 架构设计 — PRD 不包含技术实现细节
- API 接口定义 — 接口文档由开发团队另写
- 数据库表结构设计 — 不在产品需求范围内
```

- [ ] **Step 2: 更新 Step 0.5 的 "4. Generate PRD Plan" 中的表格模板**

将现有的 PRD Plan 表格改为动态格式，包含「选中」列：

```markdown
### PRD 内容方案

| 章节 | 内容概要 | 选中 | 依赖状态 |
|:-----|:---------|:-----|:---------|
| 第0章 行业对标 | 将研究 X 个标杆产品 | ✅ / ❌ | 已完成 / [待补充] |
| 第1章 项目概述 | 基于用户描述展开 | ✅ / ❌ | 已完成 |
| 第2章 业务分析 | 目标用户 X，痛点 Y | ✅ / ❌ | 已完成 / [待补充] |
| 第3章 功能需求 | [关键功能列表] | ✅ / ❌ | 已完成 |
| 第4章 非功能性需求 | 行业标准要求 | ✅ / ❌ | 自动生成 |
| 第5章 用户体验流程 | 基于功能推导 | ✅ / ❌ | 需 UI 补充 |
| 第6章 项目风险 | 基于功能复杂度 | ✅ / ❌ | 自动生成 |
| 第7章 合规建议 | 基于数据类型 | ✅ / ❌ | 自动生成 |
| 第8章 原型设计 | [原型链接] | ✅ / ❌ | - |
| 第9章 成功指标 | 基于目标推导 | ✅ / ❌ | 自动生成 |
```

- [ ] **Step 3: 在 PRD Plan 末尾增加「排除清单」区块**

在表格之后、关键决策点之前，插入：

```markdown
### 排除清单（不生成以下内容）
- 技术方案 / 架构设计 — PRD 为产品需求文档，不包含技术实现细节
- API 接口定义 / 端点规格 — 由开发团队在技术方案中另写
- 数据库表结构设计 — 不在产品需求范围内

### 关键决策点
- [列出需要用户确认的关键决策]
```

- [ ] **Step 4: 更新 "5. User Approval" 的选项**

将现有选项表更新为：

```markdown
5. **User Approval**: Use `AskUserQuestion` to present the PRD Plan (with chapter selections) and get explicit approval:

| Option | Description |
|:-------|:------------|
| **确认，按此章节方案生成 PRD** | 进入 Step 1 行业基准和 Step 2 PRD 生成 |
| **调整章节选择** | 重新勾选要生成的章节 |
| **需要调整方案** | 修改 PRD Plan 后重新确认 |
| **我有更多信息要补充** | 回到 Step 0.5 补充信息，重新生成方案 |
| **先补充感知数据** | 调用 competitive-analysis / user-research / market-intelligence |
```

---

### Task 2: 在 PRD 生成指令中加入排除约束

**Files:**
- Modify: `skills/design/prd-gen/SKILL.md` (在 "How It Works" 和 PRD 生成指令部分)

- [ ] **Step 1: 在 "## How It Works" 的步骤描述中加入章节选择**

将现有的步骤列表更新为：

```markdown
1. **Scenario Detection** - Use AskUserQuestion to identify iteration/new-feature/new-product
2. **Context Collection** - Gather required information based on scenario type
3. **Information Gap Analysis** - Identify missing info, ask one question at a time
4. **Chapter Selection** - User selects which PRD chapters to generate (multiSelect)
5. **PRD Plan Presentation** - Present plan with chapter selections for user approval (HARD GATE)
6. **Industry Benchmark Research** - Search and extract best practices (user-specified + agent search)
7. **Parse requirements** - Structure the user's feature request into key components
8. **Gather context** - Read market analysis, competitive insights, user research
9. **Assemble sections** - Build only the SELECTED PRD sections with appropriate detail
10. **Verify completeness** - Check against quality standards (selected chapters only)
11. **Generate output** - Write to `context/prd/{feature-name}-{date}-v{version}.md`
```

- [ ] **Step 2: 在 PRD 生成指令前追加排除约束块**

在 Step 2 PRD 生成（即 "Assemble sections" 步骤）的指令中，要求 LLM 在生成 PRD 前读取以下约束：

```markdown
**Content Constraints (HARD RULES):**

Before generating PRD content, note:
1. Generate ONLY the chapters selected by the user. Skip unselected chapters entirely.
2. NEVER generate the following content types, regardless of user input:
   - Technical architecture / implementation details
   - API endpoint definitions or specifications
   - Database schema or table designs
3. If the user's feature description mentions technical details, summarize them as functional requirements WITHOUT exposing implementation specifics.
```

- [ ] **Step 3: 更新 Quality Standards 为动态检查**

将现有的 Quality Standards 和 Quality Gate Checklist 改为动态验证：

```markdown
## Quality Standards

Before delivering, the PRD should include:
- **Scenario identified** (iteration/new-feature/new-product)
- **Required context collected** for the identified scenario
- **3+ industry benchmarks** referenced with rationale (第0章, if selected)
- All **selected** sections complete
- **文档基本信息** with version and revision history
- User stories in "作为...我希望...以便..." format (第3章, if selected)
- **成功指标** quantified with 3+ metrics (第9章, if selected)
- Dependencies and constraints clearly identified
- References to context sources

**Exclusion Verification:**
- [ ] No technical architecture or implementation details
- [ ] No API endpoint definitions or specifications
- [ ] No database schema or table designs

**Quality Gate Checklist:**
- [ ] Scenario type confirmed with user
- [ ] All required context for this scenario collected
- [ ] Chapter selections confirmed by user
- [ ] Industry benchmarks researched (3+ references, if 第0章 selected)
- [ ] 文档基本信息 complete (version, status, creator, reviewer)
- [ ] 项目概述 complete (background, objectives, scope, if 第1章 selected)
- [ ] 业务分析 complete (target users, pain points, market analysis, if 第2章 selected)
- [ ] 功能需求 complete (feature list, user stories, details, if 第3章 selected)
- [ ] 非功能性需求 complete (performance, security, availability, compatibility, if 第4章 selected)
- [ ] 用户体验流程 complete (user journey, page flow, if 第5章 selected)
- [ ] 项目风险 documented with mitigation (product/business risks only, no technical risks, if 第6章 selected)
- [ ] 合规建议 complete with risk categories and attachment reference (if 第7章 selected)
- [ ] 原型设计 section present (if 第8章 selected)
- [ ] 成功指标 quantified (North Star + process + outcome, if 第9章 selected)
- [ ] Dependencies documented
- [ ] Exclusion constraints verified (no tech/API/DB content)
```

---

### Task 3: 验证改动的一致性并提交

**Files:**
- Modify: `skills/design/prd-gen/SKILL.md`

- [ ] **Step 1: 验证文件内所有引用的一致性**

检查以下引用点是否与新增的章节选择逻辑一致：

1. `context-requirements` frontmatter — 无需改动（章节选择不影响场景检测）
2. `mode-support` — 无需改动
3. 结尾的 "HTML 原型生成" 部分 — 更新为仅在用户选择了第8章时触发

将结尾的 "## HTML 原型生成" 部分更新为：

```markdown
## HTML 原型生成

**Only trigger this step if the user selected 第8章 原型设计 in the chapter selection.**

After PRD generation, if 原型设计 was selected:

1. Generate interactive HTML prototype based on PRD content
2. Output to `context/prototypes/{feature-name}.html`
3. Include basic styling and interaction for demonstration
4. Update PRD with HTML prototype link
5. Notify user with preview instructions

If 原型设计 was NOT selected, skip this step and notify the user that PRD generation is complete.
```

- [ ] **Step 2: 提交改动**

```bash
git add skills/design/prd-gen/SKILL.md
git commit -m "feat: add chapter selection gate to prd-gen skill

Add multi-select chapter selection before PRD generation. Users can now
choose which PRD sections to generate, with technical architecture and
API definitions permanently excluded."
```

---

## 文件变更总结

| 文件 | 变更类型 | 说明 |
|:-----|:---------|:-----|
| `skills/design/prd-gen/SKILL.md` | Modify | 新增 Step 0.5.5 章节选择、更新 PRD Plan 表格、添加排除约束、更新 Quality Gate |

## 命令

本任务无需运行测试命令，改动为纯文档（SKILL.md）更新。验证方式为人工审查 SKILL.md 内容是否一致。
