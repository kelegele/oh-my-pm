# Oh-My-PM

<div align="center">

> AI Agent Workflow System for Product Managers — Powered by Claude Code Skills

[![License](https://img.shields.io/github/license/kelegele/oh-my-pm)](LICENSE)
[![Version](https://img.shields.io/github/v/release/kelegele/oh-my-pm)](https://github.com/kelegele/oh-my-pm/releases)
[![Skills](https://img.shields.io/badge/Skills-12-blue)](skills/)
[![Agents](https://img.shields.io/badge/Agents-6-purple)](agents/)

**3-Layer Core + Validation Loop · 6 Subagents · 12 Professional Skills · Complete Product Lifecycle**

[Quick Start](#quick-start) • [Skills](#all-skills) • [Subagents](#subagents-architecture) • [中文文档](README-CN.md)

</div>

---

## Overview

Oh-My-PM is a comprehensive AI Agent workflow system for Product Managers, built as a **Claude Code Plugin**. Instead of building a standalone SaaS platform, it leverages AI Agent plugins and workflow orchestration to automate and enhance product management tasks.

### Core Features

| Feature | Description |
|:---------|:-------------|
| **3-Layer Core + Validation** | Main line Perception → Strategy → Design, with validation skills closing the feedback loop |
| **Scenario-Driven PRD** | Iteration updates / New features / 0-1 products — no random assumptions |
| **Industry Benchmarking** | Auto-benchmark against best practices for professional output |
| **HTML Prototype Generation** | Generate interactive HTML prototypes from PRDs |
| **Human-AI Collaboration** | Autopilot / Copilot / Manual modes |

---

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) or [OpenAI Codex](https://github.com/openai/codex) CLI tool
- Clone this repository to your local project directory

### Installation (Claude Code)

```bash
# Install all skills
npx skills add kelegele/oh-my-pm -a claude-code

# Install a single skill
npx skills add kelegele/oh-my-pm --skill prd-gen -a claude-code

# Install multiple skills
npx skills add kelegele/oh-my-pm --skill prd-gen --skill competitive-analysis -a claude-code

# List available skills
npx skills add kelegele/oh-my-pm --list
```

### Installation (Codex)

```bash
# Install all skills
npx skills add kelegele/oh-my-pm -a codex

# Install a single skill
npx skills add kelegele/oh-my-pm --skill prd-gen -a codex

# List available skills
npx skills add kelegele/oh-my-pm --list
```

### Installation Channels

| Channel | What you get | Notes |
|:--------|:-------------|:------|
| `npx skills add kelegele/oh-my-pm -a <agent>` | All **12 Skills** — the complete PM workflow capability (intent routing, evidence discipline, execution profiles all live in the skills layer) | Works with any agent: Claude Code, Codex, Cursor, Copilot… |
| Claude Code marketplace plugin | Everything in the 12 Skills, **plus 6 Subagents** (isolated execution + persistent memory) **and 4 slash Commands** (quick entry points) | Enhanced experience for Claude Code |

### Manual Installation

```bash
# Clone repository
git clone https://github.com/kelegele/oh-my-pm.git
cd oh-my-pm
```

> **Note**: This plugin installs via `--plugin-dir` or plugin marketplace. Skills trigger automatically through natural language—no manual configuration needed.

### Usage

#### Commands (Direct Invocation)

4 workflow Commands can be invoked directly:

```bash
# Direct invocation
/quick-prd "User profile redesign" taobao jd
/full-pm-cycle "New project management tool"
/feature-launch "User registration flow"

# Namespace invocation
/ompm quick-prd "Dark mode"
/ompm full-pm-cycle "AI assistant feature"
/ompm feature-launch "Cart redesign"
/ompm help  # Show help
```

`/ompm` is a shim that activates the **ompm skill** — the global intent router: invoked with no arguments or with a natural-language request, it reads the current context plus `docs/product/.ompm/current-workflow.json` and recommends the most valuable next step.

#### Skills (Natural Language Triggering)

12 Skills trigger automatically through natural language:

```bash
# Direct conversation—system identifies and calls the relevant Skill
"Analyze the competitive differences between Notion and Feishu docs"  # → competitive-analysis
"Write a PRD for user profile redesign"                 # → prd-gen
"How did this feature perform after launch?"            # → retrospective
"How should we position our product?"                   # → product-strategy
```

**Note**: Skills do not support `/skill-name` explicit invocation—they trigger through natural language or workflows.

---

## 3-Layer Core + Validation Loop

The main line runs **Perception → Strategy → Design**; validation skills close the feedback loop. The former Delivery layer is folded in: PRD pre-review is now a `prd-gen` tail gate, and release checklists / rollout strategy live in `feature-launch`. On top sit 4 workflow skills: the `ompm` global intent router (front door) plus three orchestrators (`quick-prd` / `full-pm-cycle` / `feature-launch`).

```
┌─────────────────────────────────────────────────────────┐
│  Main Line 1: Perception          3 Skills              │
│  Competitive Analysis · Market Research · Clarify Requirements│
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Main Line 2: Strategy            1 Skill               │
│  Product Strategy (positioning · prioritization · roadmap)│
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Main Line 3: Design              2 Skills              │
│  PRD Generation (with pre-review gate) · Prototype Design│
└─────────────────────────────────────────────────────────┘
                              ↓
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
   Auxiliary: Validation          2 Skills
   Retrospective (impact + iteration) · Feedback Synthesis
   ──→ feedback loop back to Perception
└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
```

---

## Subagents Architecture (v0.8.0)

### What are Subagents?

Subagents are specialized AI agents that run in isolated contexts with custom system prompts, specific tool access, and independent permissions. When Claude encounters tasks matching a subagent's description, it delegates to that subagent for processing.

### Subagents vs Skills

| Feature | Skills | Subagents |
|:---------|:----------|:------------|
| **Context** | Shared with main conversation | Independently isolated |
| **Model Selection** | Inherits from main conversation | Configurable (haiku/sonnet/opus) |
| **Tool Access** | Unlimited | Configurable allowlist/denylist |
| **Persistent Memory** | None | Supports cross-session knowledge accumulation |
| **Use Case** | Simple prompt injection | High-capacity output isolation |

### 6 Subagents

#### 📊 Perception Layer (3)

| Subagent | Model | Features | Trigger Examples |
|:----------|:--------|:----------|:-----------------|
| `market-researcher` | haiku | Worktree isolation | "Analyze X market", "Industry trends" |
| `competitive-analyst` | sonnet | GitHub code analysis | "Competitive analysis", "Compare XX and YY" |
| `user-interviewer` | sonnet | User research memory | "Create user persona", "User interviews" |

#### 📈 Validation Layer (2)

| Subagent | Model | Features | Trigger Examples |
|:----------|:--------|:----------|:-----------------|
| `impact-analyst` | sonnet | Performance analysis | "Launch performance", "How is it performing" |
| `feedback-collector` | haiku | Feedback aggregation | "User feedback", "What users are saying" |

#### 🔄 Workflows (1)

| Subagent | Functionality | Trigger Examples |
|:----------|:--------------|:-----------------|
| `pm-orchestrator` | Orchestrates complete PM cycle with parallel execution | "Complete product planning", "0-1 product" |

### Memory System

Each subagent has an independent memory directory (`.claude/agent-memory/`) for cross-session knowledge accumulation:

```
.claude/agent-memory/
├── market-researcher/    # Market data accumulation
├── competitive-analyst/  # Competitor knowledge base
├── user-interviewer/     # User research patterns
├── impact-analyst/       # Impact analysis framework
├── feedback-collector/   # Feedback theme patterns
└── pm-orchestrator/      # Workflow best practices
```

### Usage

Subagents are automatically recognized and called by Claude Code—no explicit triggering needed:

```bash
# Auto-identify and delegate to market-researcher
"Analyze the market size for AI writing assistants"

# Auto-identify and delegate to competitive-analyst
"Compare feature differences between ClickUp and Asana"

# Auto-identify and delegate to pm-orchestrator
"Do complete product planning for a new project management tool"
```

---

## All Skills

### 📊 Perception Layer

| Skill | Install | Function | Trigger Examples |
|:-------|:--------|:---------|:-----------------|
| `competitive-analysis` | `--skill competitive-analysis` | Competitive feature comparison & strategic opportunity identification | "Analyze competitors", "Compare XX and YY" |
| `market-research` | `--skill market-research` | Market trends, industry analysis & user research / personas | "Market analysis", "Industry trends", "User research" |
| `clarify-requirements` | `--skill clarify-requirements` | Requirement clarification & information gap analysis | "Clarify requirements", "What info is missing" |

### 🎯 Strategy Layer

| Skill | Install | Function | Trigger Examples |
|:-------|:--------|:---------|:-----------------|
| `product-strategy` | `--skill product-strategy` | Positioning, prioritization (RICE/MoSCoW) & roadmap in one pass | "Product positioning", "Feature priority", "Product roadmap" |

### 🎨 Design Layer

| Skill | Install | Function | Trigger Examples |
|:-------|:--------|:---------|:-----------------|
| `prd-gen` | `--skill prd-gen` | Structured PRD generation (scenario-driven, with pre-review tail gate) | "Write PRD", "Requirements document" |
| `prototype-design` | `--skill prototype-design` | HTML prototype generation (iteration + new product modes) | "Design prototype", "HTML prototype", "UI flow" |

### 📈 Validation Layer

| Skill | Install | Function | Trigger Examples |
|:-------|:--------|:---------|:-----------------|
| `retrospective` | `--skill retrospective` | Post-launch impact analysis & next-iteration planning | "Impact analysis", "Post-launch review", "Plan next sprint" |
| `feedback-synthesis` | `--skill feedback-synthesis` | User feedback aggregation & analysis | "Feedback analysis", "User feedback" |

### 🔄 Workflow Orchestrators

| Workflow | Install | Function | Trigger Examples |
|:----------|:--------|:---------|:-----------------|
| `ompm` | `--skill ompm` | Global intent router (front door): reads context + current-workflow.json, recommends the most valuable next step | "What should I do next", "Continue", any PM request |
| `quick-prd` | `--skill quick-prd` | Thin preset of full-pm-cycle: competitive analysis + PRD | "Quick PRD", "Requirements with competitive analysis" |
| `full-pm-cycle` | `--skill full-pm-cycle` | Complete product lifecycle (0-1) | "Complete product planning", "0-1 product" |
| `feature-launch` | `--skill feature-launch` | Feature launch workflow (release checklist & rollout strategy) | "Feature launch", "Launch coordination" |

---

## PRD Generation Scenarios

`/prd-gen` supports intelligent scenario recognition:

| Scenario | Required Info | UI Extraction Method |
|:---------|:---------------|:---------------------|
| **Iteration Update** | Feature description + UI state + iteration goals | Screenshot / HTML / Link |
| **New Feature** | Product architecture + design spec + entry point | Read from docs/product/ |
| **0-1 New Product** | Product context + resource constraints + reference products | User input + competitive analysis |

**Core Principle**: No random assumptions—output based on industry best practices.

---

## Usage Guide

### Directory Structure

```
oh-my-pm/
├── agents/              # Subagent definitions (6) - at root!
│   ├── perception/      # Market research, competitive analysis, user research
│   ├── validation/      # Impact analysis, feedback aggregation
│   └── workflows/       # PM orchestrator
├── skills/                        # Skill plugin directory (12)
│   ├── competitive-analysis/      # layer: perception
│   ├── market-research/           # layer: perception
│   ├── clarify-requirements/      # layer: perception
│   ├── product-strategy/          # layer: strategy
│   ├── prd-gen/                   # layer: design
│   ├── prototype-design/          # layer: design
│   ├── retrospective/             # layer: validation
│   ├── feedback-synthesis/        # layer: validation
│   ├── ompm/                      # layer: workflow (global intent router)
│   ├── quick-prd/                 # layer: workflow
│   ├── full-pm-cycle/             # layer: workflow
│   └── feature-launch/            # layer: workflow
├── .claude/
│   ├── agent-memory/    # Subagent memory system
│   └── settings.local.json
├── .claude-plugin/      # Plugin configuration
│   ├── plugin.json
│   ├── agents.yaml
│   ├── skills.yaml
│   └── marketplace.json
├── docs/product/             # Context passing directory
├── docs/                # Design documents
├── tests/               # Test scripts
└── CLAUDE.md            # Project configuration
```

---

## Roadmap

| Version | Goal | Status |
|:--------|:-----|:-----|
| v0.1.0 | MVP (4 Skills) | ✅ |
| v0.2.0 | Complete 5-layer architecture (19 Skills) | ✅ |
| v0.3.0 | Subagent hybrid architecture (8 Subagents + memory system) | ✅ |
| v0.4.0 | Commands integration (19 Skills + 4 Commands) | ✅ |
| v0.5.1 | Remove Figma dependency, switch to HTML prototypes (19 Skills) | ✅ |
| v0.6.0 | HTML prototype generation (iteration + new product modes) | ✅ |
| v0.9.0 | Flat skill directory, standalone install per skill | ✅ |
| v0.9.3 | Fix context-passing contract (flat .ompm model) + doc version sync | ✅ |
| v1.0.0 | Simplified architecture: 3-layer core + validation loop (11 Skills, 6 Subagents) | ✅ |
| v1.1.0 | Portability overhaul: new `ompm` intent-router skill (12 Skills total); `npx skills add` on any agent delivers full capability | ✅ |

See [Project Board](https://github.com/users/kelegele/projects/4) for full planning.

---

## License

[MIT License](LICENSE)
