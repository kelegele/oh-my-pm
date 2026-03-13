---
name: full-pm-cycle
description: 编排从市场研究到上线后分析的完整产品管理周期。用于综合产品规划、0-1 产品开发，或当用户说"完整产品计划"、"完整 PM 周期"、"从研究到上线"时使用。
layer: workflow
input-from: user
output-to: iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Full PM Cycle Workflow

Complete product management from idea to impact.

## What This Workflow Does

Orchestrates the complete product management lifecycle across all five layers:
- **Perception**: Market research, user research, competitive analysis
- **Strategy**: Positioning, roadmap, prioritization
- **Design**: PRD generation, prototype design
- **Delivery**: Requirement review, project coordination, release management
- **Validation**: Impact analysis, feedback synthesis

## When to Use

Activate this workflow when:
- Planning a new product (0-1)
- Comprehensive product strategy exercise
- User says "full product plan", "complete PM cycle", "from scratch"
- Need end-to-end product planning with all perspectives

## How It Works

The workflow progresses through all five layers in sequence:

```
┌─────────────────────────────────────────────────────────────┐
│                    FULL PM CYCLE WORKFLOW                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LAYER 1: PERCEPTION (Understand)                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Market      │  │ User        │  │ Competitive         │ │
│  │ Research    │→ │ Research    │→ │ Analysis            │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│         ↓                ↓                    ↓             │
│  LAYER 2: STRATEGY (Position)                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Product     │→ │ Roadmap     │→ │ Prioritization      │ │
│  │ Positioning │  │ Planning    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│         ↓                ↓                    ↓             │
│  LAYER 3: DESIGN (Define)                                   │
│  ┌─────────────┐  ┌─────────────┐                            │
│  │ PRD         │→ │ Prototype   │                            │
│  │ Generation  │  │ Design      │                            │
│  └─────────────┘  └─────────────┘                            │
│         ↓                ↓                                   │
│  LAYER 4: DELIVERY (Build)                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Requirement │→ │ Project     │→ │ Release             │ │
│  │ Review      │  │ Coordination│  │ Management          │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│         ↓                ↓                    ↓             │
│  LAYER 5: VALIDATION (Learn)                                  │
│  ┌─────────────────────┐  ┌─────────────────────┐          │
│  │ Impact              │→ │ Feedback            │→ Iterate│
│  │ Analysis            │  │ Synthesis           │         │
│  └─────────────────────┘  └─────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Workflow Stages

### Stage 0: Setup
1. Define product scope and goals
2. Identify stakeholders and constraints
3. Set collaboration mode (autopilot/copilot/manual)
4. Create workflow tracking file

### Stage 1: Perception (Understand the landscape)
**Skills invoked**: `market-intelligence` → `user-research` → `competitive-analysis`

**Activities**:
- Market sizing and trend analysis
- User interviews and persona creation
- Competitive feature comparison

**Outputs**:
- `context/market-analysis.json`
- `context/user-research.json`
- `context/competitive-analysis/`

**Gate**: Complete when 3+ competitor insights and 2+ personas defined

### Stage 2: Strategy (Define the direction)
**Skills invoked**: `product-positioning` → `roadmap-planning` → `prioritization`

**Activities**:
- Create positioning statement and value proposition
- Develop 12-month roadmap with themes
- Prioritize features using RICE framework

**Outputs**:
- `context/positioning.md`
- `context/roadmap.md`
- `context/prioritization.json`

**Gate**: Complete when positioning validated and roadmap approved

### Stage 3: Design (Specify the solution)
**Skills invoked**: `prd-gen` → `prototype-design`

**Activities**:
- Generate comprehensive PRD with user stories
- Create interactive prototype or wireframes

**Outputs**:
- `context/prd/[feature]-v1.md`
- `context/design/`

**Gate**: Complete when PRD approved and prototype validated

### Stage 4: Delivery (Build and ship)
**Skills invoked**: `requirement-review` → `project-coordination` → `release-management`

**Activities**:
- Conduct requirement review with stakeholders
- Coordinate project execution across teams
- Plan and execute release

**Outputs**:
- `context/review-notes/`
- `context/project-plan.md`
- `context/release-plan.md`

**Gate**: Complete when feature is successfully released

### Stage 5: Validation (Measure and learn)
**Skills invoked**: `impact-analysis` → `feedback-synthesis`

**Activities**:
- Analyze post-release metrics against goals
- Synthesize user feedback from all sources

**Outputs**:
- `context/impact-analysis.json`
- `context/feedback-synthesis.json`

**Gate**: Complete when impact assessed and next steps identified

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `product_name` | string | Yes | Name of product or feature |
| `product_type` | string | Yes | `new-product` (0-1), `new-feature` (1-N), `pivot` |
| `scope` | string | No | Scope boundaries (default: "full product") |
| `timeframe` | string | No | Planning horizon (default: "12 months") |

## Workflow Tracking

The workflow maintains state in `context/current-workflow.json`:

```json
{
  "workflow_id": "pm-cycle-20260312",
  "workflow_name": "full-pm-cycle",
  "product_name": "[Product Name]",
  "status": "in_progress",
  "current_layer": "strategy",
  "current_stage": "product-positioning",
  "completed_stages": [
    "market-intelligence",
    "user-research",
    "competitive-analysis"
  ],
  "started_at": "2026-03-12T10:00:00Z",
  "updated_at": "2026-03-12T14:30:00Z",
  "mode": "copilot",
  "outputs": {
    "market_analysis": "context/market-analysis.json",
    "user_research": "context/user-research.json",
    "competitive_analysis": "context/competitive-analysis/",
    "positioning": "context/positioning.md",
    "roadmap": "context/roadmap.md",
    "prioritization": "context/prioritization.json"
  }
}
```

## Output Structure

### Final Deliverables

At workflow completion, you'll have:

1. **Market Intelligence Package**
   - Market size, trends, and key players
   - Growth projections and opportunities

2. **User Research Package**
   - User personas and profiles
   - User journey maps
   - Pain points and needs

3. **Competitive Analysis**
   - Feature comparison matrix
   - Competitive positioning
   - Differentiation opportunities

4. **Strategy Package**
   - Positioning statement and value prop
   - 12-month roadmap
   - Prioritized feature backlog

5. **Design Package**
   - Complete PRD with user stories
   - Interactive prototype
   - Design specifications

6. **Delivery Plan**
   - Project timeline and milestones
   - Resource allocation
   - Release plan

7. **Measurement Plan**
   - Success metrics and KPIs
   - Impact analysis framework
   - Feedback collection plan

## Quality Gates

Each layer has a quality gate before proceeding:

| Layer | Gate Criteria |
|:------|:--------------|
| **Perception** | 3+ competitors analyzed, 2+ personas, market size estimated |
| **Strategy** | Positioning validated, roadmap approved, top 10 prioritized |
| **Design** | PRD approved, prototype tested, requirements complete |
| **Delivery** | Sign-off obtained, release executed successfully |
| **Validation** | Impact measured, feedback synthesized, learnings documented |

## Collaboration Modes

| Mode | Description | When to Use |
|:---|:---|:---|
| `autopilot` | All stages executed automatically | Well-understood product, time-constrained |
| `copilot` | Each stage requires your approval | New product, need control |
| `manual` | Provides guidance, you execute | Learning the framework |

## Example Usage

```
User: "Create a full product plan for a new project management tool"
→ Executes all 5 layers, generates complete product package

User: "Run the full PM cycle for our AI assistant feature"
→ Orchestrates all skills for the specified feature

User: "I need a complete product strategy from scratch"
→ Starts with market research and proceeds through all stages
```

## Customization Options

### Fast Track Mode
Skip research layers if you already have data:
- Start at Strategy if market/user research exists
- Start at Design if positioning is complete
- Start at Delivery if PRD is approved

### Deep Dive Mode
Spend more time on specific layers:
- Extended market research with analyst reports
- Comprehensive user interview program
- Detailed financial modeling

### Parallel Execution
Some stages can run in parallel:
- User research and competitive analysis
- Prototype design while PRD is being reviewed

## Context Integration

**Reads From**:
- User input and existing context
- Previous workflow outputs (if resuming)

**Writes To**:
- All layer-specific context files
- `context/current-workflow.json` (state tracking)
- Final product package in `context/product-package/`

**Triggers**:
- May trigger `iteration-planning` after validation complete
- May trigger additional research cycles based on findings
