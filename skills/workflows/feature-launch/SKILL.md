---
name: feature-launch
description: 编排从 PRD 到上线后分析的完整功能发布工作流。当准备发布功能、协调功能发布，或用户说"发布这个功能"、"功能发布计划"、"从 PRD 到上线"时使用。
layer: workflow
input-from: prd-gen
output-to: impact-analysis,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Feature Launch Workflow

Ship features successfully from start to finish.

## What This Workflow Does

Orchestrates the end-to-end feature launch process spanning:
- **Design**: PRD finalization, prototype validation
- **Delivery**: Requirement review, project coordination, release management
- **Validation**: Impact analysis, feedback synthesis

## When to Use

Activate this workflow when:
- Launching a new feature
- Coordinating a feature release
- User says "launch this feature", "feature launch plan", "coordinate release"
- Need structured process from PRD to post-launch

## How It Works

The workflow progresses through launch stages:

```
┌─────────────────────────────────────────────────────────────┐
│                   FEATURE LAUNCH WORKFLOW                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  STAGE 1: DESIGN (Finalize)                                 │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │ PRD         │→ │ Prototype   │                          │
│  │ Finalization│  │ Validation  │                          │
│  └─────────────┘  └─────────────┘                          │
│         ↓                ↓                                   │
│  STAGE 2: PREPARE (Align)                                  │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │ Requirement │→ │ Project     │                          │
│  │ Review      │  │ Planning    │                          │
│  └─────────────┘  └─────────────┘                          │
│         ↓                ↓                                   │
│  STAGE 3: RELEASE (Ship)                                     │
│  ┌─────────────────────┐                                   │
│  │ Release Management  │                                   │
│  └─────────────────────┘                                   │
│         ↓                                                     │
│  STAGE 4: VALIDATE (Learn)                                   │
│  ┌─────────────────────┐  ┌─────────────────────┐          │
│  │ Impact             │→ │ Feedback            │          │
│  │ Analysis           │  │ Synthesis           │          │
│  └─────────────────────┘  └─────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Workflow Stages

### Stage 1: Design Finalization
**Skills invoked**: `prd-gen` (final version) → `prototype-design` (validation)

**Activities**:
- Finalize PRD with all requirements
- Create or validate prototype
- Test prototype with users if needed

**Outputs**:
- `context/prd/[feature]-final-v1.md`
- `context/design/[feature]/`

**Gate**: PRD approved, prototype validated

### Stage 2: Preparation
**Skills invoked**: `requirement-review` → `project-coordination`

**Activities**:
- Conduct requirement review meeting
- Get stakeholder sign-off
- Create detailed project plan
- Assign tasks and timeline

**Outputs**:
- `context/review-notes/[feature]-review.md`
- `context/project-plan-[feature].md`
- Sign-off documentation

**Gate**: Review complete, project plan approved

### Stage 3: Release
**Skills invoked**: `release-management`

**Activities**:
- Create release plan and checklist
- Prepare communications
- Execute deployment
- Monitor for issues

**Outputs**:
- `context/release-plan-[feature].md`
- Release notes and communications
- Deployment confirmation

**Gate**: Feature successfully deployed

### Stage 4: Validation
**Skills invoked**: `impact-analysis` → `feedback-synthesis`

**Activities**:
- Measure post-launch metrics
- Analyze goal achievement
- Collect and synthesize feedback
- Generate recommendations

**Outputs**:
- `context/impact-analysis-[feature].json`
- `context/feedback-synthesis-[feature].json`
- Post-launch report

**Gate**: Impact assessed, next steps identified

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `feature_name` | string | Yes | Name of the feature being launched |
| `prd_ref` | string | Yes | Reference to existing PRD |
| `launch_date` | string | No | Target launch date |
| `scope` | string | No | Scope of launch (beta, phased, full) |

## Workflow Tracking

```json
{
  "workflow_id": "launch-[feature]-20260312",
  "workflow_name": "feature-launch",
  "feature_name": "[Feature Name]",
  "status": "in_progress",
  "current_stage": "preparation",
  "completed_stages": ["design-finalization"],
  "launch_date": "2026-04-15",
  "started_at": "2026-03-12T10:00:00Z",
  "updated_at": "2026-03-12T14:30:00Z",
  "mode": "copilot",
  "milestones": {
    "prd_approved": "2026-03-15",
    "review_complete": "2026-03-20",
    "code_complete": "2026-04-05",
    "launch": "2026-04-15"
  }
}
```

## Stage Details

### Stage 1: Design Finalization (T-4 to T-3 weeks)

**Checklist**:
- [ ] PRD includes all sections complete
- [ ] Success metrics defined and measurable
- [ ] Edge cases identified
- [ ] Prototype created and reviewed
- [ ] User testing completed (if applicable)

**Decision Points**:
- Feature scope confirmed?
- Timeline realistic?
- Resources available?

**Stage Output**: Ready-for-review PRD + validated prototype

### Stage 2: Preparation (T-3 to T-1 weeks)

**Requirement Review Meeting**:
1. Distribute PRD and prototype 48 hours prior
2. Walk through requirements
3. Discuss concerns and edge cases
4. Document decisions
5. Obtain sign-off

**Project Planning**:
1. Break down into tasks
2. Assign owners and estimates
3. Identify dependencies
4. Plan for risks
5. Establish status reporting

**Checklist**:
- [ ] Stakeholders invited to review
- [ ] Project plan with tasks and owners
- [ ] Risk register created
- [ ] Communication plan prepared

**Stage Output**: Approved requirements + project plan

### Stage 3: Release (T-1 week to T+1 day)

**Pre-Release (T-7 to T-1 days)**:
- [ ] Code complete and reviewed
- [ ] QA testing complete
- [ ] Performance tested
- [ ] Security review complete
- [ ] Release notes drafted
- [ ] Communications prepared
- [ ] Support team briefed

**Release Day (T-day)**:
- [ ] Deploy to staging, smoke test
- [ ] Deploy to production
- [ ] Smoke test production
- [ ] Enable feature (or ramp up)
- [ ] Monitor metrics closely
- [ ] Be ready to rollback

**Post-Release (T+1 day)**:
- [ ] Verify all systems
- [ ] Send announcements
- [ ] Monitor support channels
- [ ] Check metrics

**Stage Output**: Feature live and stable

### Stage 4: Validation (T+1 to T+14 days)

**Immediate (T+1 to T+7 days)**:
- Monitor error rates and performance
- Track adoption metrics
- Respond to issues quickly
- Collect initial feedback

**Analysis (T+7 to T+14 days)**:
- Compare to success metrics
- Analyze user feedback
- Identify improvements
- Document learnings

**Checklist**:
- [ ] Impact analysis complete
- [ ] Feedback synthesized
- [ ] Success/failure determined
- [ ] Next steps identified

**Stage Output**: Impact report + recommendations

## Launch Strategies

| Strategy | When to Use | Pros | Cons |
|:---|:---|:---|:---|
| **Big Bang** | Small changes, low risk | Simple, clear message | Higher risk, harder rollback |
| **Phased Rollout** | Larger features, higher risk | Controlled, learn early | Longer time to full launch |
| **Feature Flag** | Very risky, complex | Instant rollback | Complex infrastructure |
| **Beta Release** | Need validation, feedback | Get feedback early | Leakage, support burden |

## Output Structure

### Final Deliverables

1. **Launch Package** (pre-launch)
   - Finalized PRD
   - Validated prototype
   - Project plan
   - Release plan

2. **Release Package** (at launch)
   - Release notes
   - Communications
   - Support documentation

3. **Post-Launch Package** (after launch)
   - Impact analysis report
   - Feedback synthesis
   - Lessons learned
   - Recommendations

## Quality Gates

| Stage | Gate Criteria |
|:------|:--------------|
| **Design** | PRD complete, prototype validated |
| **Prep** | Review complete, sign-off obtained |
| **Release** | Deployed successfully, no critical issues |
| **Validation** | Impact measured, feedback collected |

## Collaboration Modes

| Mode | Description |
|:---|:---|
| `autopilot` | Executes all stages with standard timelines |
| `copilot` | Each stage requires approval before proceeding |
| `manual` | Provides templates and checklists, you execute |

## Example Usage

```
User: "Launch the new onboarding feature"
→ Executes full launch workflow from PRD to analysis

User: "Plan the feature launch for checkout redesign"
→ Creates comprehensive launch plan with timeline

User: "Coordinate the Q2 feature releases"
→ Manages multiple feature launches in sequence
```

## Risk Management

Common launch risks and mitigations:

| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| Critical bug | Medium | High | Thorough QA, rollback plan |
| Low adoption | High | High | Internal testing, marketing push |
| Performance issues | Low | High | Load testing, gradual rollout |
| Negative feedback | Medium | Medium | Beta testing, support prep |
| Scope creep | Medium | Medium | Strict change process |

## Context Integration

**Reads From**:
- `context/prd/*.md` - Requirements to launch
- `context/design/` - Prototype and specs
- Existing project plans

**Writes To**:
- `context/launch-[feature]/` - All launch artifacts
- `context/current-workflow.json` - Workflow state
- Updates feature-specific context files

**Triggers**:
- May trigger `iteration-planning` for follow-up work
- May trigger additional research based on findings
