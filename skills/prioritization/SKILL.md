---
name: prioritization
description: 使用 RICE、MoSCoW 等框架对功能和计划进行优先级排序。当用户需要对待办事项排序、决定构建什么、对功能排名，或说"给这个排优先级"、"我们应该先构建什么"、"如何对这些排名"时使用。即使没有明确说"优先级排序"，当用户正在决定接下来做什么或对竞争项目进行排名时也应激活。
layer: strategy
input-from: user-research,feedback-synthesis,market-intelligence
output-to: roadmap-planning,prd-gen,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Prioritization

Decide what to build and in what order.

## What This Skill Does

Prioritizes features, initiatives, and backlog items using proven frameworks like RICE, MoSCoW, and Kano. Applies structured decision-making to balance conflicting priorities and allocate resources effectively.

## When to Use

Activate this skill when:
- User needs to prioritize or rank items
- Phrases like "prioritize this", "what should we build first", "rank these"
- Managing backlog or deciding between features
- Allocating limited resources across competing initiatives
- User says "how do we decide" or "priority ranking"

## How It Works

The prioritization process ensures systematic, defensible decisions:

1. **Collect items** - Gather all features/initiatives to prioritize
2. **Choose framework** - Select appropriate prioritization method
3. **Gather data** - Collect estimates for reach, impact, effort
4. **Calculate scores** - Apply the prioritization formula
5. **Review and adjust** - Consider strategic factors, dependencies
6. **Generate ranking** - Produce prioritized list with rationale

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `items` | list | Yes | Items to prioritize (features, initiatives) |
| `framework` | string | No | `rice` (default), `moscow`, `kano`, `value-effort` |
| `constraints` | object | No | Resource constraints (e.g., `{"capacity": 20, "timeframe": "Q2"}) |

## Prioritization Frameworks

### RICE (Recommended)
```
RICE = (Reach × Impact × Confidence) / Effort

- Reach: How many users affected (0-100+)
- Impact: Impact per user (0.25 = Tiny, 0.5 = Small, 1 = Medium, 2 = Large, 3 = Massive)
- Confidence: How confident in estimates (0-100%)
- Effort: Person-months of work

Example: (1000 users × 2 impact × 80% confidence) / 2 months = 800
```

### MoSCoW
| Category | Definition | % of Items |
|:---------|:-----------|:-----------|
| **Must Have** | Critical for success | 20-30% |
| **Should Have** | Important but not critical | 30-40% |
| **Could Have** | Nice to have if time permits | 20-30% |
| **Won't Have** | Explicitly out of scope | 10-20% |

### Value-Effort Matrix
```
Quadrants based on Value (High/Low) and Effort (High/Low):

High Value, Low Effort  → QUICK WINS (Do first)
High Value, High Effort → MAJOR PROJECTS (Plan carefully)
Low Value, Low Effort  → FILL-INS (Do when convenient)
Low Value, High Effort → THANKLESS TASKS (Avoid or eliminate)
```

### Kano Model
| Category | Description | Priority |
|:---------|:-----------|:---------|
| **Must-be** | Basic expectations, taken for granted | Baseline |
| **Performance** | More is better | Competitive |
| **Attractive** | Delighters, unexpected bonuses | Differentiators |

## Output Structure

The skill generates prioritization outputs:

1. **Prioritized list** (`context/prioritization.json`) - Ranked items with scores
2. **Summary report** - Explanation of rankings and recommendations

### Prioritization Format

```json
{
  "prioritization": {
    "framework": "RICE",
    "timestamp": "2026-03-12T...",
    "constraints": {
      "capacity": 50,
      "timeframe": "Q2 2026"
    },
    "items": [
      {
        "id": "FEAT-001",
        "name": "User onboarding flow",
        "rice_score": 85,
        "reach": 1000,
        "impact": 2,
        "confidence": 0.85,
        "effort": 2,
        "rank": 1,
        "category": "Must Have",
        "rationale": "High reach, high impact, moderate effort"
      },
      {
        "id": "FEAT-002",
        "name": "Dark mode",
        "rice_score": 45,
        "reach": 500,
        "impact": 1,
        "confidence": 0.9,
        "effort": 1,
        "rank": 2,
        "category": "Should Have",
        "rationale": "Moderate reach, medium impact, low effort"
      }
    ],
    "summary": {
      "total_items": 15,
      "must_have": 3,
      "should_have": 5,
      "could_have": 4,
      "wont_have": 3
    }
  }
}
```

### Summary Report Format

```markdown
# Prioritization Summary

## Framework Used
RICE scoring with capacity constraint of 50 points for Q2 2026

## Top Priorities

### 1. User Onboarding Flow (RICE: 85)
**Category**: Must Have
**Effort**: 2 person-months

**Rationale**: Affects all new users (1000/month), high impact on activation,
confident in estimates, moderate effort.

**Dependencies**: None
**Risk**: Low

---

### 2. Dark Mode (RICE: 45)
**Category**: Should Have
**Effort**: 1 person-month

**Rationale**: Highly requested feature, moderate reach, low effort quick win.

**Dependencies**: Design system update
**Risk**: Low

---

## Category Breakdown
| Category | Count | % of Total |
|:---------|------:|:-----------|
| Must Have | 3 | 20% |
| Should Have | 5 | 33% |
| Could Have | 4 | 27% |
| Won't Have | 3 | 20% |

## Capacity Analysis
- **Total capacity**: 50 points
- **Must Have items**: 30 points (60%)
- **Should Have items**: 15 points (30%)
- **Remaining**: 5 points (10%) for Could Have or buffer

## Recommendations

1. **Quick Wins**: Start with dark mode (low effort, high demand)
2. **Core Value**: Then tackle onboarding flow (high impact)
3. **Strategic**: Plan major projects for next quarter

## Considerations

- **Strategic alignment**: All top items support growth goal
- **Technical dependencies**: Onboarding depends on auth system v2
- **Market timing**: Competitors launching similar features in Q2
```

## Quality Standards

Before delivering, the prioritization should:
- Use consistent scoring methodology
- Provide clear rationale for rankings
- Consider strategic factors beyond the formula
- Identify dependencies and risks
- Be defensible and explainable to stakeholders
- Leave room for unexpected opportunities

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Applies framework, generates ranked list |
| `copilot` | Shows scores, gets your input on strategic factors |
| `manual` | Provides framework templates, you complete scoring |

## Context Integration

**Reads:**
- `context/user-research.json` - User needs for impact assessment
- `context/feedback-synthesis.json` - User feedback for validation
- `context/market-analysis.json` - Market trends for strategic alignment

**Writes:**
- `context/prioritization.json` - Prioritized item list

**Read By:**
- `roadmap-planning` - Uses prioritization for roadmap sequencing
- `prd-gen` - References priority for feature scope
- `iteration-planning` - Uses rankings for sprint planning

## Example Usage

```
User: "Prioritize our backlog"
→ Applies RICE to all backlog items

User: "What should we build first with our limited budget?"
→ Prioritizes with value-effort matrix

User: "Rank these features by impact"
→ Uses impact-focused prioritization
```

## Best Practices

1. **Don't prioritize in isolation** - Consider strategic context
2. **Quantify when possible** - Use real data, not guesses
3. **Revisit regularly** - Priorities change as you learn
4. **Explain the why** - Rationale matters more than the score
5. **Leave capacity buffer** - Don't plan 100% utilization
