# Subagent 架构文档

## 概述

Oh-My-PM v0.3.0 引入了 **Subagent 混合架构**，在原有 19 个 Skills 基础上，增加了 8 个专业化 Subagents，实现上下文隔离、模型优化和知识积累。

## 架构设计

### 设计原则

| 使用场景 | 推荐方案 |
|:---------|:---------|
| 简单提示词注入 | Skill |
| 高容量输出隔离 | Subagent |
| 需要模型优化 | Subagent (指定 model) |
| 工具权限限制 | Subagent (allowlist/denylist) |
| 持久化记忆 | Subagent (memory 字段) |
| 后台并行执行 | Subagent (background: true) |
| 主对话交互 | Skill |

### 分层策略

| 层级 | 策略 | 说明 |
|:-----|:-----|:-----|
| **Perception** | 4 个全转为 Subagent | 研究型任务，高输出，适合隔离 |
| **Strategy** | 保留 Skill | 需要频繁用户交互 |
| **Design** | 混合 | prd-gen 保留，process-optimization 转为 Subagent |
| **Delivery** | 保留 Skill | 项目协调需要主对话上下文 |
| **Validation** | 2 个转 Subagent | data-monitoring 和 impact-analysis 适合隔离 |
| **Workflows** | 转为 Orchestrator Subagent | 协调其他 Subagent |

## Subagents 详解

### 1. market-researcher

**文件**: `.claude/agents/perception/market-researcher.md`

```yaml
model: haiku          # 快速 web 搜索
isolation: worktree   # 研究过程隔离
memory: project        # 市场知识积累
```

**用途**: 市场规模估算、行业趋势分析、机会识别

**触发示例**:
- "分析 AI 写助手的市场"
- "SaaS 项目管理工具的市场有多大？"

### 2. competitive-analyst

**文件**: `.claude/agents/perception/competitive-analyst.md`

```yaml
model: sonnet         # 综合分析
memory: project        # 竞品知识库
```

**用途**: 竞品功能对比、差异化分析、GitHub 代码分析

**触发示例**:
- "对比 ClickUp 和 Asana 的功能"
- "分析 Linear 的项目管理实现"

### 3. user-interviewer

**文件**: `.claude/agents/perception/user-interviewer.md`

```yaml
model: sonnet         # 深度分析
memory: project        # 用户研究模式
```

**用途**: 用户画像创建、访谈设计、用户行为分析

**触发示例**:
- "创建用户画像"
- "分析用户访谈数据"

### 4. data-monitor

**文件**: `.claude/agents/perception/data-monitor.md`

```yaml
model: haiku          # 轻量查询
background: true      # 后台监控
maxTurns: 5           # 限制执行
memory: project        # 指标基线
```

**用途**: 产品指标监控、异常检测、趋势分析

**触发示例**:
- "监控 DAU 指标"
- "为什么转化率下降了？"

### 5. process-optimizer

**文件**: `.claude/agents/design/process-optimizer.md`

```yaml
model: sonnet              # 分析任务
disallowedTools: [Edit]    # 只读模式
memory: project            # 流程优化知识
```

**用途**: 流程优化、瓶颈分析、效率改进

**触发示例**:
- "优化代码审查流程"
- "如何提高团队效率？"

### 6. impact-analyst

**文件**: `.claude/agents/validation/impact-analyst.md`

```yaml
model: sonnet         # 效果分析
memory: project        # 分析框架
```

**用途**: 上线效果分析、目标达成评估、经验总结

**触发示例**:
- "新功能上线效果如何？"
- "我们达成目标了吗？"

### 7. feedback-collector

**文件**: `.claude/agents/validation/feedback-collector.md`

```yaml
model: haiku          # 轻量汇总
memory: project        # 反馈模式
```

**用途**: 用户反馈聚合、主题分类、情绪分析

**触发示例**:
- "汇总用户反馈"
- "用户在抱怨什么？"

### 8. pm-orchestrator

**文件**: `.claude/agents/workflows/pm-orchestrator.md`

```yaml
model: inherit                       # 继承主对话
tools: Agent(...)                   # 限制可启动的 subagent
maxTurns: 20                        # 复杂编排
memory: project                      # 工作流最佳实践
```

**用途**: 协调完整 PM 周期、并行执行研究任务、综合发现

**触发示例**:
- "为新产品做完整规划"
- "运行完整 PM 周期"

## 记忆系统

### 目录结构

```
.claude/agent-memory/
├── market-researcher/MEMORY.md
├── competitive-analyst/MEMORY.md
├── user-interviewer/MEMORY.md
├── data-monitor/MEMORY.md
├── process-optimizer/MEMORY.md
├── impact-analyst/MEMORY.md
├── feedback-collector/MEMORY.md
└── pm-orchestrator/MEMORY.md
```

### 记忆范围

| 范围 | 位置 | 使用场景 |
|:-----|:-----|:---------|
| `user` | `~/.claude/agent-memory/<name>/` | 跨项目通用知识 |
| `project` | `.claude/agent-memory/<name>/` | 项目特定知识 |
| `local` | `.claude/agent-memory-local/<name>/` | 本地不提交 |

### 记忆内容示例

```markdown
# Market Researcher 知识库

## 已完成的市场分析
- [2026-03-12] SaaS 项目管理 ($10B TAM, 15% CAGR)
- [2026-03-10] AI 写助手 ($5B SAM, 25% CAGR)

## 重复出现的模式
1. SaaS 工具市场: PLG (Product-Led Growth) 成为标配
2. 企业软件: 安全和合规成为采购前提

## 可靠数据源
- Gartner (企业软件)
- IDC (技术市场)
- CB Insights (创业投资)
```

## 并行执行

### 场景: Perception 层独立研究

```yaml
# pm-orchestrator 可以并行启动:
1. market-researcher    → 市场趋势和规模
2. competitive-analyst  → 竞品功能对比
3. user-interviewer     → 用户研究和画像
```

每个 subagent 独立运行，然后 orchestrator 综合发现。

## 配置选项

### 常用字段

| 字段 | 类型 | 说明 |
|:-----|:-----|:-----|
| `name` | string | Subagent 标识 |
| `description` | string | 何时委托给此 subagent |
| `model` | string | haiku/sonnet/opus/inherit |
| `tools` | list | 允许的工具列表 |
| `disallowedTools` | list | 禁止的工具列表 |
| `memory` | string | user/project/local |
| `isolation` | string | worktree (隔离执行) |
| `background` | bool | 后台运行 |
| `maxTurns` | number | 最大轮次限制 |

### 工具限制示例

```yaml
# 只读 subagent
tools: [Read, Grep, Glob, Bash]
disallowedTools: [Edit, Write]

# 只允许启动特定 subagent
tools: [Agent(market-researcher), Agent(competitive-analyst)]
```

## 最佳实践

### 1. 选择合适的模型

| 模型 | 适用场景 |
|:-----|:---------|
| `haiku` | Web 搜索、轻量查询、监控任务 |
| `sonnet` | 分析任务、代码审查、流程优化 |
| `opus` | 战略决策、复杂规划 |
| `inherit` | 协调器、不确定的任务 |

### 2. 使用隔离模式

```yaml
isolation: worktree  # 高容量研究任务
```

研究产生的临时文件自动清理，主仓库不受影响。

### 3. 启用持久记忆

```yaml
memory: project  # 团队共享的知识积累
```

让 subagent 跨会话学习，提高效率。

### 4. 限制执行时间

```yaml
maxTurns: 5  # 防止无限循环
background: true  # 长期监控任务
```

## 故障排查

### Subagent 未被调用

**问题**: 描述不够清晰，Claude 无法识别

**解决**: 在 `description` 中明确触发条件

```yaml
description: "Market research for X. Use when user says 'analyze X market', 'market research', 'industry trends'"
```

### 记忆未生效

**问题**: MEMORY.md 文件未创建或路径错误

**解决**: 确保目录存在，文件格式正确

```bash
# 检查记忆文件
ls .claude/agent-memory/<subagent-name>/MEMORY.md
```

### 并行执行未生效

**问题**: Orchestrator 未正确配置

**解决**: 确保使用 `Agent(agent_type)` 语法

```yaml
tools: [Agent(market-researcher), Agent(competitive-analyst)]
```

## 参考资料

- [Claude Code Subagents 文档](https://code.claude.com/docs/en/sub-agents)
- [Claude Code Agent SDK](https://docs.anthropic.com/agent-sdk)
