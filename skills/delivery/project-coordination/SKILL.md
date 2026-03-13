---
name: project-coordination
description: 协调项目执行、跟踪进度并管理风险。当用户需要管理项目、跟踪进度、协调团队间工作，或说"项目状态"、"跟踪这个项目"、"进度如何"时使用。即使没有明确说"项目协调"，当用户正在管理执行、依赖关系或跨团队工作时也应激活。
layer: delivery
input-from: requirement-review,prototype-design
output-to: release-management
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Project Coordination

Keep projects on track and teams aligned.

## What This Skill Does

Coordinates project execution by tracking progress, managing dependencies, identifying risks, and facilitating communication between teams. Ensures the project moves from requirements to release smoothly.

## When to Use

Activate this skill when:
- User needs to track project progress or status
- Phrases like "project status", "track this", "what's the progress"
- Coordinating work across multiple teams
- Managing project risks and blockers
- User says "are we on track" or "project update"

## How It Works

The coordination process ensures smooth project execution:

1. **Establish baseline** - Define scope, timeline, resources
2. **Track progress** - Monitor completion against plan
3. **Identify blockers** - Find risks and dependencies
4. **Facilitate resolution** - Help teams overcome obstacles
5. **Communicate status** - Keep stakeholders informed
6. **Adapt as needed** - Adjust plans based on reality

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `project_name` | string | Yes | Name of the project |
| `timeline` | object | No | Planned start/end dates, milestones |
| `teams` | list | No | Teams and people involved |

## Output Structure

The skill generates coordination outputs:

1. **Project plan** - Structured plan with tasks and owners
2. **Status reports** - Regular progress updates
3. **Risk register** - Identified risks and mitigations
4. **Blocker list** - Current blockers and owners

### Project Plan Format

```markdown
# Project Plan: [Project Name]

## Overview
- **Start Date**: [Date]
- **Target Release**: [Date]
- **Project Manager**: [Name]
- **Status**: On Track / At Risk / Off Track

## Teams & Responsibilities
| Team | Lead | Scope | Capacity |
|:-----|:-----|:------|:---------|
| Engineering | [Name] | Backend, frontend | 40 hrs/week |
| Design | [Name] | UI, UX | 20 hrs/week |
| QA | [Name] | Testing, automation | 20 hrs/week |

## Timeline

```
Week 1  |████████| Design complete
Week 2  |        ████████| Backend API
Week 3  |                ████████| Frontend implementation
Week 4  |                        ████| QA & bug fixes
Week 5  |                            ████| Release prep
```

## Work Breakdown

### Phase 1: Design (Week 1)
| Task | Owner | Estimate | Status | Dependencies |
|:-----|:------|:---------|:--------|:-------------|
| Wireframes | Designer | 2d | ✅ Done | - |
| Mockups | Designer | 2d | 🔄 In Progress | Wireframes |
| Design review | PM | 0.5d | ⏳ Pending | Mockups |

### Phase 2: Backend (Week 2)
| Task | Owner | Estimate | Status | Dependencies |
|:-----|:------|:---------|:--------|:-------------|
| API design | Backend Lead | 1d | ⏳ Pending | Design review |
| Implementation | Backend Dev | 3d | ⏳ Pending | API design |
| API testing | QA | 1d | ⏳ Pending | Implementation |

### Phase 3: Frontend (Week 3)
| Task | Owner | Estimate | Status | Dependencies |
|:-----|:------|:---------|:--------|:-------------|
| Component setup | Frontend Dev | 1d | ⏳ Pending | Design review |
| Implementation | Frontend Dev | 3d | ⏳ Pending | Component setup, API |
| Integration | Frontend Dev | 1d | ⏳ Pending | Implementation |

## Dependencies
| Task | Depends On | Risk Level |
|:-----|:-----------|:-----------|
| Frontend implementation | Backend API | Medium |
| QA testing | Frontend + Backend | Low |

## Milestones
| Milestone | Date | Criteria | Status |
|:----------|:-----|:---------|:--------|
| Design complete | Week 1 | All mockups approved | ✅ |
| API complete | Week 2 | All endpoints tested | 🔄 |
| Feature complete | Week 3 | All tickets done | ⏳ |
| Ready for release | Week 4 | QA signed off | ⏳ |
```

### Status Report Format

```markdown
# Project Status: [Project Name]
**Week of**: [Date]
**Reporting Period**: [Start] - [End]

## Summary
| Metric | Status |
|:-------|:--------|
| Overall | 🟢 On Track / 🟡 At Risk / 🔴 Off Track |
| Timeline | On schedule / 1 week behind / 2+ weeks behind |
| Budget | Under / On track / Over |
| Scope | Stable / Minor changes / Major changes |

## This Week's Progress
**Completed**:
- ✅ [Completed item 1]
- ✅ [Completed item 2]

**In Progress**:
- 🔄 [In progress item 1] (60%)
- 🔄 [In progress item 2] (30%)

## Blocked / At Risk
| Item | Impact | Owner | Action |
|:-----|:-------|:-------|:-------|
| [Blocker] | High/Medium/Low | [Who] | [What's being done] |

## Upcoming Week
**Planned**:
- ⏳ [Planned item 1]
- ⏳ [Planned item 2]

## Risks & Issues
| Risk | Level | Mitigation | Status |
|:-----|:------|:-----------|:--------|
| [Risk] | High/Medium/Low | [Mitigation plan] | Open/Mitigated |

## Decisions Made This Week
1. [Decision 1] - [Rationale]
2. [Decision 2] - [Rationale]

## Stakeholder Communications
- [ ] Update sent to stakeholders
- [ ] Leadership notified of risks
- [ ] Team briefed on changes
```

### Risk Register Format

```markdown
# Risk Register: [Project Name]

| ID | Risk | Probability | Impact | Score | Mitigation | Owner | Status |
|:---|:-----|:------------|:-------|:-----|:-----------|:------|:--------|
| R1 | API dependency delayed | Medium | High | 12 | Parallel work possible | Tech Lead | Open |
| R2 | Designer unavailable | Low | Medium | 6 | Contract backup | PM | Mitigated |
| R3 | Scope creep | High | High | 16 | Strict change process | PM | Open |

**Risk Score** = Probability (1-5) × Impact (1-5)
- **1-5**: Low risk (monitor)
- **6-10**: Medium risk (plan mitigation)
- **11-25**: High risk (active management)
```

## Quality Standards

Before delivering, ensure:
- Project plan has clear tasks and owners
- Status is accurate and up-to-date
- Blockers are identified with owners
- Risks have mitigation plans
- Stakeholders are informed appropriately
- Dependencies are tracked

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates project plan and status templates |
| `copilot` | Drafts plan, validates estimates with you |
| `manual` | Provides templates, you manage coordination |

## Context Integration

**Reads:**
- `context/review-notes/*.md` - Requirement review decisions
- `context/design/*.md` - Design specifications

**Writes:**
- `context/project-plan.md` - Project plan and tracking
- `context/status-reports/` - Weekly status reports

**Read By:**
- `release-management` - Uses status for release planning

## Example Usage

```
User: "Create a project plan for the onboarding feature"
→ Generates structured project plan with tasks and timeline

User: "What's the status of the checkout project?"
→ Pulls current status and generates report

User: "We're blocked on the API integration"
→ Updates blocker list and suggests mitigation options
```

## Best Practices

1. **Be visible** - Make status accessible to all stakeholders
2. **Focus on blockers** - Prioritize removing obstacles
3. **Communicate early** - Bad news should travel fast
4. **Update regularly** - Stale information is worse than none
5. **Celebrate wins** - Acknowledge progress and achievements
