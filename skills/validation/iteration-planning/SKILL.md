---
name: iteration-planning
description: Plan the next product iteration based on impact analysis and user feedback. Use this skill when planning sprints, retrospectives, post-release analysis, prioritizing backlog items, allocating team capacity, or deciding what to work on next. Activate whenever the user says "plan the next sprint", "what should we build", "prioritize the backlog", "retrospective", or needs to balance new features, bugs, and technical debt.
layer: validation
input-from: impact-analysis,feedback-synthesis
output-to: user-research,prd-gen
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Iteration Planning

Plan the next iteration based on data and feedback.

## What This Skill Does

Analyzes post-release impact data and user feedback to create a prioritized iteration plan. Categorizes work (bugs, features, tech debt), applies prioritization frameworks like RICE, allocates team capacity, and identifies what metrics to track. Closes the feedback loop by routing new insights back to research and design skills.

## When to Use

Activate this skill when:
- Planning the next sprint or iteration
- Conducting retrospectives or post-release reviews
- User asks "what should we build next" or "how should we prioritize"
- Need to balance new features with bugs and technical debt
- Allocating team capacity for upcoming work
- Reviewing what worked and what didn't from the previous iteration

## How It Works

The planning process ensures data-driven iteration plans:

1. **Synthesize data** - Read impact analysis and user feedback from context
2. **Categorize findings** - Group into bugs, enhancements, new features, tech debt
3. **Prioritize** - Apply RICE or MoSCoW prioritization framework
4. **Allocate capacity** - Match work items to team velocity and constraints
5. **Generate plan** - Create iteration backlog with clear priorities
6. **Close the loop** - Route new insights back to perception and design skills

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `current_sprint` | string | Yes | Current iteration identifier (e.g., "Sprint 12") |
| `impact_ref` | string | No | Reference to impact analysis results |
| `feedback_ref` | string | No | Reference to user feedback synthesis |
| `capacity` | object | No | Team capacity constraints (e.g., `{"points": 20, "weeks": 2}`) |
| `debt_ratio` | number | No | Percentage allocation for tech debt (default: 20%) |

## Output Structure

The skill generates two outputs:

1. **JSON file** (`context/iteration-plan.json`) - Structured plan for tracking
2. **Markdown report** - Human-readable iteration plan

### JSON Output Format

```json
{
  "iteration_id": "sprint-13",
  "previous_iteration": "sprint-12",
  "created_at": "2026-03-11T...",
  "planned_items": [
    {
      "id": "ITEM-001",
      "type": "bug",
      "title": "Fix login page crash",
      "priority_score": 80,
      "estimated_effort": "3pts",
      "source": "feedback",
      "rice_score": {"reach": 100, "impact": 8, "confidence": 0.8, "effort": 3}
    },
    {
      "id": "ITEM-002",
      "type": "feature",
      "title": "Add bulk export feature",
      "priority_score": 65,
      "estimated_effort": "5pts",
      "source": "impact"
    }
  ],
  "capacity_allocation": {
    "features": "60%",
    "bugs": "20%",
    "tech_debt": "20%"
  },
  "metrics_to_track": ["DAU", "conversion_rate", "NPS"],
  "next_steps": ["1. Run iteration planning meeting", "2. Update roadmap"]
}
```

### Markdown Report Structure

```markdown
# Sprint 13 Iteration Plan

## Overview
- **Iteration**: Sprint 13
- **Previous**: Sprint 12
- **Created**: YYYY-MM-DD
- **Duration**: 2 weeks
- **Total Capacity**: 20 story points

## Previous Iteration Review
### Impact Summary
- Core metrics: [from impact-analysis]
- User feedback: [from feedback-synthesis]

### Issues Identified
| Issue | Type | Source | Priority |
|:------|:-----|:-------|:----------|
| XXX | Bug | Feedback | P0 |

## This Iteration Plan
### Capacity Allocation
| Category | Allocation | Points | Items |
|:---------|:-----------|:-------|:-------|
| New Features | 60% | 12 | 3 |
| Bug Fixes | 20% | 4 | 5 |
| Tech Debt | 20% | 4 | 2 |

### Iteration Backlog
#### P0 (Must Complete)
- [ITEM-001] Fix login page crash (3pts) - Bug

#### P1 (Should Complete)
- [ITEM-002] Add bulk export feature (5pts) - Feature

#### P2 (Nice to Have)
- [ITEM-003] Refactor auth module (4pts) - Tech Debt

## Metrics to Track
This iteration, monitor:
1. DAU - Daily active users
2. Conversion Rate - Core funnel conversion
3. NPS - User satisfaction

## Feedback Loop
The following findings trigger new analysis cycles:
- New user pain points → Activate `/user-research`
- Competitor feature changes → Activate `/competitive-analysis`
- Requirement changes → Activate `/prd-gen`

## Next Steps
1. [ ] Run iteration planning meeting
2. [ ] Update product roadmap
3. [ ] Sync with engineering team
```

## RICE Prioritization

The skill uses RICE scoring for prioritization:

```
RICE = (Reach × Impact × Confidence) / Effort

- Reach: Number of users affected (0-100+)
- Impact: Impact per user (0.25-3)
- Confidence: Estimate certainty (%)
- Effort: Work required (person-months)

Example: (100 × 1 × 0.8) / 3 = 26.7
```

## Work Item Types

| Type | Symbol | Prioritization | Typical Allocation |
|:-----|:-------|:---------------|:-------------------|
| Bug | 🐛 | Severity × Impact | 20% |
| Enhancement | ⚡ | RICE score | 40% |
| Feature | ✨ | RICE score | 30% |
| Tech Debt | 🔧 | Impact × Risk | 10% |

## Quality Standards

Before delivering, the plan should:
- Total estimated effort fit within team capacity
- Include at least one item from each category (if available)
- Have priority scores for all items
- Specify metrics to track this iteration
- Identify feedback loop destinations for new insights

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Completes analysis and prioritization, generates plan automatically |
| `copilot` | Shows categorized items, waits for your confirmation on priorities |
| `manual` | Collects and categorizes findings, you complete prioritization |

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `context/impact-analysis.json` - Post-release impact data
- `context/feedback-synthesis.json` - User feedback summary
- `context/current-workflow.json` - Workflow state

**Writes:**
- `context/iteration-plan.json` - The iteration plan
- Updates `context/current-workflow.json` - State transition

**Feedback Loop:**
- New user problems discovered → Suggests `/user-research`
- Validation failed → Suggests `/prd-gen` for redesign
- Competitor research needed → Suggests `/competitive-analysis`

## Example Usage

```
User: "What should we work on in Sprint 13?"
→ Generates iteration plan based on impact and feedback

User: "Plan the next sprint"
→ Activates iteration-planning with current context

User: "Prioritize our backlog"
→ Categorizes and prioritizes pending items
```
