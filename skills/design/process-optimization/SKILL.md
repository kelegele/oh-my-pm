---
name: process-optimization
description: Analyze and optimize business processes and workflows. Use this skill when the user needs to improve processes, eliminate waste, streamline workflows, or says "optimize this process", "how can we be more efficient", "workflow improvement". Even if they don't explicitly say "process optimization", activate when they're analyzing how work gets done or looking for efficiency gains.
layer: design
input-from: feedback-synthesis,impact-analysis
output-to: prd-gen,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Process Optimization

Improve how work gets done.

## What This Skill Does

Analyzes business processes and workflows to identify inefficiencies, eliminate waste, and design optimized processes. Uses techniques like value stream mapping, bottleneck analysis, and continuous improvement principles.

## When to Use

Activate this skill when:
- User wants to improve a process or workflow
- Phrases like "optimize this", "be more efficient", "workflow improvement"
- Analyzing how work currently gets done
- Identifying and removing process bottlenecks
- User says "this process is broken" or "how can we streamline"

## How It Works

The optimization process ensures systematic improvement:

1. **Map current state** - Document the existing process
2. **Identify issues** - Find bottlenecks, waste, pain points
3. **Analyze root causes** - Understand why problems exist
4. **Design future state** - Create optimized process
5. **Plan implementation** - Define changes and rollout
6. **Measure impact** - Track improvements

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `process_name` | string | Yes | Name of process to optimize |
| `scope` | string | No | Process boundaries and scope |
| `stakeholders` | list | No | People involved in the process |
| `metrics` | object | No | Current performance metrics |

## Process Analysis Techniques

### Value Stream Mapping
Identify value-added vs. non-value-added activities:

| Activity Type | Definition | Action |
|:---|:---|:---|
| **Value-Added** | Customer is willing to pay for | Keep and optimize |
| **Non-Value Added** | Necessary but no direct value | Minimize |
| **Waste** | No value, not necessary | Eliminate |

### The 8 Wastes (DOWNTIME)
| Waste | Description | Examples |
|:---|:---|:---|
| **D**efects | Mistakes requiring rework | Bugs, errors, rework |
| **O**verproduction | Creating more than needed | Unused features, excess reports |
| **W**aiting | Delays between steps | Approval queues, dependencies |
| **N**on-utilized talent | Not using people's skills | Manual work that could be automated |
| **T**ransportation | Moving things unnecessarily | File transfers, handoffs |
| **I**nventory | Hoarding work in progress | Large backlogs, stale branches |
| **M**otion | Unnecessary movement | Switching between tools |
| **E**xtra processing | Doing more than required | Redundant approvals |

## Output Structure

The skill generates optimization outputs:

1. **Current state analysis** - Documentation of existing process
2. **Problem identification** - List of issues with root causes
3. **Future state design** - Optimized process definition
4. **Implementation plan** - Steps to achieve optimization

### Analysis Format

```markdown
# Process Optimization: [Process Name]

## Current State

### Process Map
```
[Step 1] → [Step 2] → [Step 3] → [Step 4] → [Step 5]
   ↓           ↓           ↓           ↓           ↓
(2 min)    (1 day)    (2 min)    (3 days)   (5 min)
```

### Metrics
| Metric | Current Value | Target |
|:-------|:--------------|:-------|
| Cycle time | 5 days | 1 day |
| Touch points | 5 | 3 |
| Rework rate | 30% | <5% |
| Satisfaction | 4/10 | 8/10 |

### Stakeholders
| Role | Involvement | Pain Points |
|:-----|:-----------|:------------|
| Role 1 | Steps 1, 4 | [Their complaints] |
| Role 2 | Steps 2, 3, 5 | [Their complaints] |

## Problems Identified

| Problem | Impact | Root Cause | Type |
|:--------|:-------|:-----------|:-----|
| Approval bottleneck | +3 days | Single approver | Waiting |
| Rework from errors | +1 day | Unclear requirements | Defects |
| Manual data entry | +30 min | No integration | Non-value added |

## Future State

### Optimized Process Map
```
[Step 1] → [Step 2] → [Step 3]
   ↓           ↓           ↓
(2 min)    (1 hour)    (5 min)
```

### Changes
| Change | Impact | Effort |
|:-------|:-------|:-------|
| Parallel approvals | -2 days | Medium |
| Automated validation | -1 day | Low |
| Remove redundant step | -30 min | Low |

### Expected Metrics
| Metric | Current | Target | Improvement |
|:-------|:--------|:-------|:------------|
| Cycle time | 5 days | 1 day | 80% |
| Touch points | 5 | 3 | 40% |
| Rework rate | 30% | <5% | 83% |

## Implementation Plan

### Phase 1: Quick Wins (Week 1)
- [ ] Remove redundant approval step
- [ ] Add automated validation
- [ ] Create process documentation

### Phase 2: System Changes (Week 2-3)
- [ ] Build integration between systems
- [ ] Implement parallel approval workflow
- [ ] Update UI for new process

### Phase 3: Training & Rollout (Week 4)
- [ ] Train stakeholders on new process
- [ ] Monitor and adjust
- [ ] Measure results

## Risks & Mitigation
| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| Resistance to change | Medium | Medium | Involve stakeholders early |
| Technical issues | Low | High | Pilot before rollout |
| Process breaks | Low | High | Maintain rollback option |
```

## Quality Standards

Before delivering, the optimization should:
- Quantify current and future performance
- Identify specific root causes, not symptoms
- Propose realistic, implementable solutions
- Consider stakeholder perspectives
- Include measurement plan
- Balance automation with human judgment

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Analyzes process, generates optimization plan |
| `copilot` | Identifies issues, validates solutions with you |
| `manual` | Provides analysis frameworks, you complete |

## Context Integration

**Reads:**
- `context/feedback-synthesis.json` - User pain points and complaints
- `context/impact-analysis.json` - Process performance data

**Writes:**
- `context/process-optimization.md` - Analysis and recommendations

**Read By:**
- `prd-gen` - Incorporates process improvements into requirements
- `iteration-planning` - Includes optimization work in sprints

## Example Usage

```
User: "Our code review process takes too long"
→ Analyzes current process, identifies bottlenecks, proposes improvements

User: "Optimize the customer onboarding workflow"
→ Maps current state, designs streamlined future state

User: "Why does deployment take so many steps?"
→ Identifies waste, creates implementation plan for CI/CD improvement
```

## Best Practices

1. **Map before changing** - Understand current state first
2. **Go to gemba** - Observe the process where it happens
3. **Ask why 5 times** - Find root causes, not symptoms
4. **Start with quick wins** - Build momentum with easy fixes
5. **Measure everything** - You can't improve what you don't measure
