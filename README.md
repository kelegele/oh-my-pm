# Oh-My-PM

<div align="center">

> AI Agent Workflow System for Product Managers — Powered by Claude Code Skills

[![Claude Code](https://img.shields.io/badge/Claude-Code-forest?logo=anthropic)](https://claude.ai/code)
[![License](https://img.shields.io/github/license/kelegele/oh-my-pm)](LICENSE)
[![Version](https://img.shields.io/github/v/release/kelegele/oh-my-pm)](https://github.com/kelegele/oh-my-pm/releases)
[![Skills](https://img.shields.io/badge/Skills-20-blue)](skills/)
[![Agents](https://img.shields.io/badge/Agents-8-purple)](agents/)

**5-Layer Architecture · 8 Subagents · 20 Professional Skills · Complete Product Lifecycle**

[Quick Start](#quick-start) • [Skills](#all-skills) • [Subagents](#subagents-architecture) • [Contributing](#contributing)

</div>

---

## Overview

Oh-My-PM is a comprehensive AI Agent workflow system for Product Managers, built as a **Claude Code Plugin**. Instead of building a standalone SaaS platform, it leverages AI Agent plugins and workflow orchestration to automate and enhance product management tasks.

### Core Features

| Feature | Description |
|:---------|:-------------|
| **5-Layer Architecture** | Complete closed-loop from requirement sensing to value validation |
| **Scenario-Driven PRD** | Iteration updates / New features / 0-1 products — no random assumptions |
| **Industry Benchmarking** | Auto-benchmark against best practices for professional output |
| **HTML Prototype Generation** | Generate interactive HTML prototypes from PRDs |
| **Human-AI Collaboration** | Autopilot / Copilot / Manual modes |

---

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) CLI tool
- Clone this repository to your local project directory

### Installation via skills.sh

```bash
# Install directly via skills.sh
npx skills add kelegele/oh-my-pm -a claude-code
```

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

#### Skills (Natural Language Triggering)

20 Skills trigger automatically through natural language:

```bash
# Direct conversation—system identifies and calls the relevant Skill
"Analyze the competitive differences between Notion and Feishu docs"  # → competitive-analysis
"Write a PRD for user profile redesign"                 # → prd-gen
"How did this feature perform after launch?"            # → impact-analysis
"How should we position our product?"                   # → product-positioning
```

**Note**: Skills do not support `/skill-name` explicit invocation—they trigger through natural language or workflows.

---

## 5-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Perception (Requirement)     4 Skills      │
│  Market Intelligence · User Research · Competitive Analysis   │
│  · Data Monitoring                                      │
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 2: Strategy            3 Skills      │
│  Product Positioning · Roadmap Planning · Prioritization │
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 3: Design             3 Skills      │
│  PRD Generation · Prototype Design · Process Optimization│
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 4: Delivery            3 Skills      │
│  Requirement Review · Project Coordination · Release Management│
└─────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 5: Validation          3 Skills      │
│  Impact Analysis · Feedback Synthesis · Iteration Planning│
└─────────────────────────────────────────────────────────┘
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

### 8 Subagents

#### 📊 Perception Layer (4)

| Subagent | Model | Features | Trigger Examples |
|:----------|:--------|:----------|:-----------------|
| `market-researcher` | haiku | Worktree isolation | "Analyze X market", "Industry trends" |
| `competitive-analyst` | sonnet | GitHub code analysis | "Competitive analysis", "Compare XX and YY" |
| `user-interviewer` | sonnet | User research memory | "Create user persona", "User interviews" |
| `data-monitor` | haiku | Background daemon | "Monitor metrics", "Data dashboard" |

#### 🎨 Design Layer (1)

| Subagent | Model | Features | Trigger Examples |
|:----------|:--------|:----------|:-----------------|
| `process-optimizer` | sonnet | Read-only mode | "Process optimization", "Efficiency solutions" |

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
├── data-monitor/         # Metrics baseline
├── process-optimizer/    # Process optimization knowledge
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

| Skill | Function | Trigger Examples |
|:-------|:---------|:-----------------|
| `competitive-analysis` | Competitive feature comparison | "Analyze competitors", "Compare XX and YY" |
| `market-intelligence` | Market intelligence collection & analysis | "Market analysis", "Industry trends" |
| `user-research` | User research & persona creation | "User interviews", "Create user persona" |
| `data-monitoring` | Product metrics monitoring & anomaly detection | "Monitor metrics", "Data dashboard" |

### 🎯 Strategy Layer

| Skill | Function | Trigger Examples |
|:-------|:---------|:-----------------|
| `product-positioning` | Product positioning & differentiation strategy | "Product positioning", "Differentiation strategy" |
| `roadmap-planning` | Product roadmap planning | "Product roadmap", "Version planning" |
| `prioritization` | Prioritization (RICE/MoSCoW frameworks) | "Prioritization", "Feature priority" |

### 🎨 Design Layer

| Skill | Function | Trigger Examples |
|:-------|:---------|:-----------------|
| `prd-gen` | Structured PRD generation (scenario-driven) | "Write PRD", "Requirements document" |
| `prototype-design` | HTML prototype generation (iteration mode + new product mode) | "Design prototype", "HTML prototype", "UI flow" |
| `process-optimization` | Business process optimization | "Process optimization", "Efficiency solutions" |

### 🚢 Delivery Layer

| Skill | Function | Trigger Examples |
|:-------|:---------|:-----------------|
| `requirement-review` | Requirement review & stakeholder alignment | "Requirement review", "Review meeting" |
| `project-coordination` | Project progress & risk management | "Project status", "Progress tracking" |
| `release-management` | Release management & launch checklist | "Release plan", "Launch checklist" |

### 📈 Validation Layer

| Skill | Function | Trigger Examples |
|:-------|:---------|:-----------------|
| `impact-analysis` | Post-launch impact analysis & goal comparison | "Impact analysis", "Post-launch review" |
| `feedback-synthesis` | User feedback aggregation & analysis | "Feedback analysis", "User feedback" |
| `iteration-planning` | Data-driven iteration planning | "Iteration planning", "Version scheduling" |

### 🔄 Workflow Orchestrators

| Workflow | Function | Trigger Examples |
|:----------|:---------|:-----------------|
| `quick-prd` | Competitive analysis + PRD integration | "Quick PRD", "Requirements with competitive analysis" |
| `full-pm-cycle` | Complete product lifecycle (0-1) | "Complete product planning", "0-1 product" |
| `feature-launch` | Feature launch workflow | "Feature launch", "Launch coordination" |

---

## PRD Generation Scenarios

`/prd-gen` supports intelligent scenario recognition:

| Scenario | Required Info | UI Extraction Method |
|:---------|:---------------|:---------------------|
| **Iteration Update** | Feature description + UI state + iteration goals | Screenshot / HTML / Link |
| **New Feature** | Product architecture + design spec + entry point | Read from context/ |
| **0-1 New Product** | Product context + resource constraints + reference products | User input + competitive analysis |

**Core Principle**: No random assumptions—output based on industry best practices.

---

## Usage Guide

### Human-AI Collaboration Modes

| Mode | Description | Use Case |
|:-----|:-------------|:-----------|
| `autopilot` | AI auto-executes, human reviews only | Data monitoring, report generation |
| `copilot` | AI suggests, human decides & confirms | PRD generation, solution design |
| `manual` | Human leads, AI assists | Strategic decisions, creative work |

### Directory Structure

```
oh-my-pm/
├── agents/              # Subagent definitions (8) - at root!
│   ├── perception/      # Market research, competitive analysis, user research, data monitoring
│   ├── design/          # Process optimization
│   ├── validation/      # Impact analysis, feedback aggregation
│   └── workflows/       # PM orchestrator
├── skills/              # Skill plugin directory (20)
│   ├── perception/      # Perception layer (4)
│   ├── strategy/        # Strategy layer (3)
│   ├── design/          # Design layer (3)
│   ├── delivery/        # Delivery layer (3)
│   ├── validation/      # Validation layer (3)
│   └── workflows/       # Workflow orchestrators (3)
├── .claude/
│   ├── agent-memory/    # Subagent memory system
│   └── settings.local.json
├── .claude-plugin/      # Plugin configuration
│   ├── plugin.json
│   ├── agents.yaml
│   ├── skills.yaml
│   └── marketplace.json
├── context/             # Context passing directory
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
| v0.4.0 | Commands integration (20 Skills + 4 Commands) | ✅ |
| v0.5.1 | Remove Figma dependency, switch to HTML prototypes (19 Skills) | ✅ |
| v0.6.0 | HTML prototype generation (iteration + new product modes) | ✅ |
| v0.8.0 | Plan-and-Execute workflow, Pencil integration | ✅ |
| v1.0.0 | Enterprise edition & integrations | ⏳ |

See [Project Board](https://github.com/users/kelegele/projects/4) for full planning.

---

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

[MIT License](LICENSE)

---

<div align="center">

**Made with** [Claude Code](https://claude.ai/code) **by** [@kelegele](https://github.com/kelegele)

</div>
