# AGENTS.md

This file provides guidance to Claude Code and Codex when working with code in this repository.

## Overview

Oh-My-PM is an AI Agent workflow system for Product Managers, implemented as a **Skills plugin** installable into Claude Code and Codex.

The system features a **5-layer architecture** with **20 Skills** (17 domain + 3 workflows) and **8 Subagents**, covering the complete product management lifecycle from requirement sensing to value validation.

Current plugin version: **0.9.0** (see `.claude-plugin/plugin.json`). See `docs/planning/roadmap.md` for full version history.

## Commands

```bash
# Run skill structure tests
bash tests/test-skills.sh

# Install plugin from GitHub
npx skills add kelegele/oh-my-pm -a claude-code   # Claude Code
npx skills add kelegele/oh-my-pm -a codex          # Codex

# Install plugin from a local checkout
npx skills add . -a claude-code
npx skills add . -a codex

# Usage examples (via natural language in Claude Code or Codex)
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
│  competitive-analysis · data-monitoring ·       │
│  clarify-requirements                            │
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
│  prd-gen · prototype-design · process-optimization                  │
│  → Output: prd/*.md, prototypes/*.html          │
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

### Skills Breakdown

| Layer | Skills | Examples |
|:------|:-------|:---------|
| **Perception** (5) | competitive-analysis, market-intelligence, user-research, data-monitoring, clarify-requirements | Market data, personas |
| **Strategy** (3) | product-positioning, roadmap-planning, prioritization | Positioning, roadmap |
| **Design** (3) | prd-gen, prototype-design, process-optimization | PRD, HTML prototypes |
| **Delivery** (3) | requirement-review, project-coordination, release-management | Review reports, release plans |
| **Validation** (3) | impact-analysis, feedback-synthesis, iteration-planning | Impact metrics, iteration plans |
| **Workflows** (3) | quick-prd, full-pm-cycle, feature-launch | Multi-skill orchestration |

### Context Passing

All intermediate outputs are stored in `context/` directory:

| File | Layer | Flow |
|:-----|:------|:-----|
| `competitive-analysis.json` | Perception | → prd-gen, positioning |
| `personas.json` | Perception | → positioning, prd-gen |
| `market-analysis.json` | Perception | → positioning |
| `user-research.json` | Perception | → positioning |
| `clarification-result.json` | Perception | → prd-gen |
| `prd/*.md` | Design | → prototype-design, requirement-review |
| `prototypes/*.html` | Design | → validation |
| `prd-draft.md` | Design | Draft PRD |
| `impact-analysis.json` | Validation | → iteration-planning |
| `feedback-synthesis.json` | Validation | → iteration-planning |
| `iteration-plan.json` | Validation | → next cycle |
| `current-workflow.json` | All | Workflow state tracking |

### Shared Rules & Templates

- **Anti-Hallucination Rules**: Inlined into each Perception-layer Skill (competitive-analysis, market-intelligence, user-research, data-monitoring) for standalone installability.
- **`templates/prototype/`**: HTML prototype templates (wireframe, mockup, interactive) with component library and quality standards.

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

The 4th command, **`ompm`**, is a **workflow dispatcher** (`/ompm <workflow> [args...] | help | ?`) that namespaces the three workflows above — e.g. `/ompm quick-prd "用户改版" 淘宝 京东`. It is the primary entry point; the bare `/quick-prd` etc. are shorthand.

## Key Files

| Path | Purpose |
|:-----|:--------|
| `skills/*/SKILL.md` | Skill definitions (20 skills, flat directory structure) |
| `agents/*/*.md` | Subagent specifications |
| `commands/*.md` | CLI command definitions |
| `.claude-plugin/plugin.json` | Plugin manifest (Skills + Agents + Commands) |
| `templates/prototype/` | HTML prototype templates + component library |
| `context/` | Workflow intermediate outputs |
| `docs/architecture/workflow-architecture.md` | Plan-and-Execute architecture spec |
| `docs/architecture/subagent-architecture.md` | Subagent design patterns |
| `docs/architecture/CODEMAPS.md` | Comprehensive component navigation |

## Subagent Memory System

Each subagent maintains independent memory in `.claude/agent-memory/<name>/MEMORY.md`:

- **market-researcher**: Market data & trends
- **competitive-analyst**: Competitor knowledge base
- **user-interviewer**: User research patterns
- **data-monitor**: Metrics baseline
- **process-optimizer**: Process optimization frameworks
- **impact-analyst**: Impact analysis frameworks
- **feedback-collector**: Feedback theme patterns
- **pm-orchestrator**: Workflow best practices

Memory enables cross-session learning without polluting main conversation context.

## Development

### Adding a New Skill

1. Create directory: `skills/skill-name/`
2. Create `SKILL.md` with YAML frontmatter (`name`, `description`, `layer`, `version`)
3. Validate frontmatter manually — `tests/test-skills.sh` only checks 5 MVP skills, not new ones (see Testing below); extend its `test_skill_file` list if you want CI coverage
4. Update `.claude-plugin/plugin.json` — add `./skills/skill-name/` to the `skills` array

### Adding a New Subagent

1. Create `agents/{layer}/name.md` with agent spec
2. Add entry to `.claude-plugin/plugin.json` → `agents` array
3. Create memory directory: `.claude/agent-memory/name/MEMORY.md`

### Testing

```bash
# Skill structure validation (checks YAML frontmatter + name/description fields)
bash tests/test-skills.sh
```

Note: `tests/test-skills.sh` only **hardcodes 5 MVP skills** (competitive-analysis, clarify-requirements, prd-gen, iteration-planning, quick-prd) plus the `context/` directory — it does **not** auto-discover all 20 skills. A newly added skill is not exercised by this script; verify its frontmatter manually or extend the script's `test_skill_file` list.

Skills are triggered by natural language in Claude Code or Codex — test by simulating user prompts.

## Versioning & Commits

**Semantic versioning**: `major.minor.patch`

- **Every feature update commit must bump the patch version** in relevant files (plugin.json, SKILL.md headers, agent definitions)
- Check `git diff` before committing — if any file has a `version` field, increment it
- Breaking changes bump major, new features bump minor, bug fixes bump patch
