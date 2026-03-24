# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Oh-My-PM is an AI Agent workflow system for Product Managers, implemented as a **Claude Code Skill plugin**.

The system features a **5-layer architecture** with **20 Skills** (16 domain + 3 workflows + 1 Pencil design) and **8 Subagents**, covering the complete product management lifecycle from requirement sensing to value validation.

## Commands

```bash
# Run skill structure tests
bash tests/test-skills.sh

# Usage examples (via Claude Code natural language)
# "Analyze the competitive differences between Notion and Feishu docs"  → competitive-analysis
# "Write a PRD for user profile redesign"                                → prd-gen
# "How did this feature perform after launch?"                           → impact-analysis
```

## Architecture Overview

### 5-Layer Data Flow

```
┌─────────────────────────────────────────────────┐
│  Perception Layer (需求感知)                     │
│  market-intelligence · user-research ·          │
│  competitive-analysis · data-monitoring          │
│  → Output: market_data, personas, competitive   │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Strategy Layer (策略规划)                       │
│  product-positioning · roadmap-planning ·       │
│  prioritization                                  │
│  → Output: positioning, roadmap, priorities     │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Design Layer (方案设计)                         │
│  prd-gen · prototype-design · pencil-design ·   │
│  process-optimization                            │
│  → Output: prd/*.md, prototypes/*.html, *.pen   │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Delivery Layer (交付协调)                       │
│  requirement-review · project-coordination ·    │
│  release-management                              │
│  → Output: project_plan, release_notes          │
└─────────────────────────────────────────────────┘
                       ↓ context/
┌─────────────────────────────────────────────────┐
│  Validation Layer (价值验证)                     │
│  impact-analysis · feedback-synthesis ·         │
│  iteration-planning                              │
│  → Output: impact, feedback, iteration_plan     │
└─────────────────────────────────────────────────┘
                       ↓
              (Feedback loop to Perception)
```

### Skills + Subagents Hybrid Model

| Component | Count | Purpose |
|:----------|:------|:--------|
| **Skills** | 20 | Prompt injection for workflow triggering |
| **Subagents** | 8 | Isolated execution with optimized models |
| **Commands** | 4 | Direct CLI invocation |

**Key Difference**: Skills share main conversation context; Subagents run in isolation with custom model selection (haiku/sonnet/opus) and persistent memory.

### Context Passing

All intermediate outputs are stored in `context/` directory:

| File | Purpose | Flow |
|:-----|:--------|:-----|
| `competitive-analysis.json` | Competitor analysis results | → prd-gen |
| `personas.json` | User persona data | → positioning |
| `prd/*.md` | PRD documents | → prototype-design |
| `prototypes/*.html` | HTML prototypes | → validation |
| `prototypes/*.pen` | Pencil design files | → validation |
| `current-workflow.json` | Workflow state tracking | All workflows |

## Workflows

### Plan-and-Execute Pattern

All workflows follow the **Plan-and-Execute pattern** with:
- **Stage gates**: Quality criteria before moving to next stage
- **State tracking**: `context/current-workflow.json`
- **Collaboration modes**: autopilot / copilot / manual

| Workflow | Command | Description |
|:---------|:--------|:------------|
| **quick-prd** | `/quick-prd "desc" [competitors...]` | Competitive analysis + PRD |
| **full-pm-cycle** | `/full-pm-cycle "product"` | Complete 0-1 product lifecycle |
| **feature-launch** | `/feature-launch "feature"` | Feature launch coordination |

## Key Files

| Path | Purpose |
|:-----|:--------|
| `skills/*/SKILL.md` | Skill definitions with triggers and workflows |
| `agents/*/*.md` | Subagent specifications |
| `commands/*.md` | CLI command definitions |
| `.claude-plugin/plugin.json` | Plugin manifest (Skills + Agents + Commands) |
| `docs/workflow-architecture.md` | Plan-and-Execute architecture spec |
| `docs/subagent-architecture.md` | Subagent design patterns |
| `docs/CODEMAPS.md` | Comprehensive component navigation |

## Subagent Memory System

Each subagent maintains independent memory in `.claude/agent-memory/<name>/MEMORY.md`:

- **market-researcher**: Market data & trends
- **competitive-analyst**: Competitor knowledge base
- **user-interviewer**: User research patterns
- **process-optimizer**: Process optimization frameworks
- **impact-analyst**: Impact analysis frameworks
- **feedback-collector**: Feedback theme patterns
- **pm-orchestrator**: Workflow best practices

Memory enables cross-session learning without polluting main conversation context.
