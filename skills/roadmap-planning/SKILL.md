---
name: roadmap-planning
description: 创建产品路线图，包含里程碑、时间表和战略对齐。当用户需要规划产品方向、创建路线图、定义里程碑、规划发布，或说"创建路线图"、"我们的计划是什么"、"下季度路线图"时使用。即使没有明确说"路线图"，当用户正在规划产品时间线、发布或战略方向时也应激活。
layer: strategy
input-from: prioritization,product-positioning
output-to: prd-gen,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Roadmap Planning

Plan what to build and when to build it.

## What This Skill Does

Creates strategic product roadmaps that translate positioning and priorities into actionable plans. Defines themes, milestones, timelines, and resource allocation while maintaining flexibility for changing circumstances.

## When to Use

Activate this skill when:
- User needs a product roadmap or release plan
- Phrases like "create roadmap", "what's our plan", "upcoming releases"
- Planning quarterly or annual product strategy
- Communicating product direction to stakeholders
- User says "roadmap for next [period]" or "what are we building"

## How It Works

The roadmap planning process ensures strategic alignment:

1. **Review context** - Understand positioning, priorities, constraints
2. **Define themes** - Group work into strategic themes
3. **Set milestones** - Identify key delivery points
4. **Allocate resources** - Match work to capacity
5. **Create timeline** - Build phased delivery schedule
6. **Validate feasibility** - Check against constraints and risks

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `timeframe` | string | Yes | Planning horizon (e.g., "Q2 2026", "2026", "next 6 months") |
| `scope` | string | No | `product` (full product), `feature` (specific area) |
| `granularity` | string | No | `themes` (high-level), `milestones` (standard), `features` (detailed) |

## Output Structure

The skill generates roadmap outputs:

1. **Roadmap document** (`context/roadmap.md`) - Visual and detailed roadmap
2. **Milestone definitions** - Key delivery points with success criteria

### Roadmap Document Format

```markdown
# Product Roadmap: [Timeframe]

## Strategic Themes
| Theme | Description | Business Value | Priority |
|:------|:-------------|:---------------|:---------|
| Theme 1 | [What and why] | [Expected outcome] | P0 |
| Theme 2 | [What and why] | [Expected outcome] | P1 |

## Timeline Overview

```
Q1  |████████████████████|  Theme 1: Foundation
Q2  |        ████         |  Theme 2: Growth
Q3  |            ████     |  Theme 3: Scale
Q4  |                ████ |  Theme 4: Expansion
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
```

## Milestones

### Q1 2026 - Foundation
**Goal**: Establish core platform capabilities

| Deliverable | Target | Success Criteria | Risk |
|:------------|:-------|:------------------|:-----|
| Feature A | Feb 15 | [Metric] | [Risk level] |
| Feature B | Mar 30 | [Metric] | [Risk level] |

**Dependencies**: Tech platform v2, API access
**Risks**: Engineering capacity, third-party API limits

### Q2 2026 - Growth
**Goal**: Drive user acquisition and engagement

| Deliverable | Target | Success Criteria | Risk |
|:------------|:-------|:------------------|:-----|
| Feature C | May 15 | [Metric] | [Risk level] |

**Dependencies**: Q1 delivery complete
**Risks**: Market competition, user adoption

## Quarterly Breakdown

### Q1 2026 (Jan-Mar)
**Focus**: Foundation

| Week | Theme | Features | Capacity |
|:-----|:------|:---------|:---------|
| W1-4 | Setup | Infrastructure, auth | 20 pts |
| W5-8 | Core | Feature A, Feature B | 25 pts |
| W9-12 | Launch | Beta release, feedback | 20 pts |

**Total**: 65 story points
**Allocation**: 60% features, 20% tech debt, 20% buffer

### Q2 2026 (Apr-Jun)
**Focus**: Growth

| Week | Theme | Features | Capacity |
|:-----|:------|:---------|:---------|
| W13-16 | Acquisition | Onboarding, invitations | 25 pts |
| W17-20 | Engagement | Feature C, notifications | 30 pts |
| W21-24 | Optimization | Performance, analytics | 25 pts |

**Total**: 80 story points
**Allocation**: 70% features, 15% tech debt, 15% buffer

## Now/Next/Later View

### Now (Current Quarter)
- [ ] Feature A (Week 4)
- [ ] Feature B (Week 8)
- [ ] Beta Launch (Week 12)

### Next (Following Quarter)
- Feature C
- Feature D
- Public Launch

### Later (Future)
- Feature E
- Feature F
- International expansion

## Dependencies & Risks
| Item | Type | Impact | Mitigation |
|:-----|:-----|:-------|:-----------|
| Dependency | External | High | [Plan B] |
| Risk | Technical | Medium | [Mitigation] |

## Resource Allocation
| Team | Q1 | Q2 | Q3 | Q4 |
|:-----|:---|:---|:---|:---|
| Engineering | 2 FTE | 2 FTE | 3 FTE | 3 FTE |
| Design | 0.5 FTE | 0.5 FTE | 1 FTE | 1 FTE |
| PM | 1 FTE | 1 FTE | 1 FTE | 1 FTE |

## Assumptions
1. Engineering headcount increases in Q3
2. No major technical blockers
3. Market conditions remain stable
4. Competitors don't launch major alternatives
```

## Roadmap Views

| View | When to Use | Key Elements |
|:-----|:------------|:-------------|
| **Now/Next/Later** | Executive communication | 3 buckets only |
| **Timeline** | Planning sessions | Dates and milestones |
| **Theme-based** | Strategic alignment | Grouped by initiatives |
| **Feature-based** | Engineering execution | Detailed feature list |

## Quality Standards

Before delivering, the roadmap should:
- Align with product positioning and strategy
- Be realistic given resource constraints
- Include measurable success criteria
- Identify key dependencies and risks
- Balance new features with tech debt
- Allow flexibility for changes
- Communicate clearly to all audiences

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates roadmap from priorities and constraints |
| `copilot` | Drafts roadmap, validates milestones with you |
| `manual` | Provides roadmap templates, you complete |

## Context Integration

**Reads:**
- `context/prioritization.json` - Prioritized backlog
- `context/positioning.md` - Strategic direction

**Writes:**
- `context/roadmap.md` - Complete roadmap document
- `context/roadmap.json` - Machine-readable roadmap data

**Read By:**
- `prd-gen` - References roadmap for feature planning
- `iteration-planning` - Uses roadmap for sprint planning

## Example Usage

```
User: "Create a roadmap for Q2"
→ Generates Q2 roadmap with milestones

User: "What's our product plan for this year?"
→ Creates annual roadmap with themes

User: "Show me now/next/later"
→ Generates simplified 3-bucket view
```

## Best Practices

1. **Theme-based, not feature-based** - Group into strategic themes
2. **Leave room for discovery** - Don't fill every slot
3. **Communicate uncertainty** - Show confidence levels
4. **Update regularly** - Roadmaps change, keep them current
5. **Multiple views** - Different detail for different audiences
