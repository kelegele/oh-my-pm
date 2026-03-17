# 项目记忆 - Oh-My-PM

## 项目概述

Oh-My-PM 是基于 **Claude Code Skill 插件** 的产品经理 AI Agent 工作流系统。

**核心理念**: 轻量级实现，不构建完整系统，而是通过 Agent 插件和工作流形式落地。

---

## 当前状态 (v0.8.0)

**完成内容**:
1. ✅ 完整五层架构 (20 Skills)
2. ✅ Subagent 混合架构 (8 Subagents)
3. ✅ Commands 集成 (4 Commands)
4. ✅ Plan-and-Execute 工作流架构
5. ✅ Pencil MCP 专业设计集成
6. ✅ HTML 原型生成系统
7. ✅ 测试框架建立
8. ✅ GitHub 仓库建立
9. ✅ 文档体系完善

---

## 关键技术决策

### 1. 技术选型: Claude Code Skills

**为什么选择 Skills 而非独立系统**:
- 用户明确要求 "Agent 插件、workflow 等形式落地"
- 轻量级，无需部署后端
- 直接集成到 Claude Code 开发体验
- 可通过 YAML frontmatter 定义触发条件

**关键文件**: `.claude-plugin/skills/` + `skills/`

### 2. 目录结构演变

```
oh-my-pm/
├── skills/                   # 生产 Skills (20个)
│   ├── perception/           # 第一层：需求感知 (4)
│   ├── strategy/             # 第二层：策略规划 (3)
│   ├── design/               # 第三层：方案设计 (4)
│   ├── delivery/             # 第四层：交付协调 (3)
│   ├── validation/           # 第五层：价值验证 (3)
│   └── workflows/            # 工作流编排器 (3)
├── agents/                    # Subagent 定义 (8个)
│   ├── perception/           # 市场研究、竞品分析、用户研究、数据监控
│   ├── design/               # 流程优化
│   ├── validation/           # 效果分析、反馈汇总
│   └── workflows/            # PM 编排器
├── commands/                 # CLI 命令定义 (4个)
│   ├── quick-prd.md
│   ├── full-pm-cycle.md
│   ├── feature-launch.md
│   └── ompm.md
├── .claude-plugin/            # 插件配置
│   ├── plugin.json
│   ├── skills.yaml
│   ├── agents.yaml
│   └── marketplace.json
├── .claude/agent-memory/     # Subagent 记忆系统
│   ├── market-researcher/
│   ├── competitive-analyst/
│   ├── user-interviewer/
│   ├── data-monitor/
│   ├── process-optimizer/
│   ├── impact-analyst/
│   ├── feedback-collector/
│   └── pm-orchestrator/
├── context/                  # 上下文传递目录
├── docs/                    # 设计文档
└── templates/prototype/      # HTML 原型模板
```

### 3. Skills vs Subagents 选择策略

| 使用场景 | 推荐方案 | 原因 |
|:---------|:---------|:-----|
| 简单提示词注入 | Skill | 无需隔离，主对话共享上下文 |
| 高容量输出隔离 | Subagent | 独立上下文，避免主对话污染 |
| 需要模型优化 | Subagent | 可指定 haiku/sonnet/opus |
| 工具权限限制 | Subagent | allowlist/denylist 控制 |
| 持久化记忆 | Subagent | 跨会话知识积累 |
| 主对话交互 | Skill | 用户可见执行过程 |
| 后台并行执行 | Subagent | background: true 支持 |

### 4. Plan-and-Execute 工作流架构 (v0.8.0)

**核心设计**:
- 统一阶段标识: S0 (Setup) → S1-S5 (各层执行)
- 状态机追踪: in_progress / completed / blocked
- 质量门控: 每阶段完成前必须满足质量标准
- 状态追踪文件: `context/current-workflow.json`

**阶段定义**:
| Stage ID | 名称 | 关键输出 |
|:---------|:-----|:----------|
| S0 | Setup | workflow_tracking.json |
| S1 | Perception | market_data.json, personas.json |
| S2 | Strategy | positioning.md, roadmap.md |
| S3 | Design | prd/*.md, prototypes/*.html, prototypes/*.pen |
| S4 | Delivery | project_plan.md, release_notes.md |
| S5 | Validation | impact.json, feedback.json |

### 5. 原型方案演变 (v0.5.0 → v0.7.0)

| 阶段 | 方案 | 原因 |
|:-----|:-----|:-----|
| v0.4.0 | Figma MCP | 尝试专业工具集成 |
| v0.6.0 | HTML 原型 | 移除外部依赖，自包含方案 |
| v0.7.0 | Pencil MCP | 专业设计能力，需 MCP 环境配置 |

**教训**: 外部工具依赖增加使用门槛，保留 HTML 原型作为无依赖选项，Pencil 作为高级选项。

---

## GitHub Project 管理经验

### 1. GitHub CLI 权限问题

**问题**: 创建 Project Board 需要额外 scope

**解决**:
```bash
gh auth refresh -h github.com -s project,read:project
```

**教训**: 提前检查所需权限，避免中途卡住

### 2. Plugin 加载机制关键发现 (v0.4.0)

**发现**: `--plugin-dir` 只加载配置，不自动注册 Skills

**解决**:
- 技能文件必须在 `~/.claude/skills/` 才可被自动发现
- 本地开发需使用符号链接: `ln -sf skills/*/SKILL.md ~/.claude/skills/`

**教训**: Marketplace 插件与本地 `--plugin-dir` 插件行为不同。

---

## Context 文件系统设计

### 设计原则

1. **JSON 用于结构化数据** - 便于解析和验证
2. **Markdown 用于文档** - 便于人类阅读
3. **统一前缀** - 便于查找和管理

### 文件清单

| 文件 | 格式 | 用途 | 读写 Skills |
|:-----|:-----|:-----|:------------|
| competitive-analysis.json | JSON | 竞品分析结果 | competitive-analysis → prd-gen |
| prd-draft.md | Markdown | PRD 文档 | prd-gen |
| iteration-plan.json | JSON | 迭代计划 | iteration-planning |
| current-workflow.json | JSON | 工作流状态 | 全部工作流 |

### 教训

**问题**: Write 工具要求先 Read 文件

**解决**: 创建空文件或在代码中先读取再写入

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
│  prd-gen, prototype-design, pencil-design,        │
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
feat: add Plan-and-Execute workflow architecture (v0.8.0)
fix: resolve context file permission issue
docs: update roadmap with v0.8.0 milestones
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

### Q: Pencil MCP 如何配置？

**A**: 在 `~/.claude/settings.json` 添加：
```json
{
  "mcpServers": {
    "pencil": {
      "command": "npx",
      "args": ["-y", "@anysphere/mcp-server-pencilmcp"]
    }
  }
}
```

---

## 下一步计划

| 版本 | 目标 | 状态 |
|:-----|:-----|:-----|
| v0.9.0 | Jira/Linear API 集成 | ⏳ 规划中 |
| v1.0.0 | 多 Agent 协作能力 | ⏳ 规划中 |
| v1.1.0 | 预测性分析 | ⏳ 规划中 |
| v1.2.0 | 个性化适配 | ⏳ 规划中 |

---

## 资源链接

- **GitHub**: https://github.com/kelegele/oh-my-pm
- **Project Board**: https://github.com/users/kelegele/projects/4
- **Claude Code**: https://claude.ai/code
- **anthropics/skills**: https://github.com/anthropics/skills
- **Pencil MCP**: https://github.com/anysphere/mcp-server-pencilmcp
