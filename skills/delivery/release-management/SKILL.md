---
name: release-management
description: 规划并执行产品发布，包含质量检查和沟通。当用户需要规划发布、创建发布检查清单、管理上线，或说"规划发布"、"上线检查清单"、"发布管理"时使用。即使没有明确说"发布管理"，当用户正在准备发布功能或部署到生产环境时也应激活。
layer: delivery
input-from: project-coordination
output-to: impact-analysis
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Release Management

Ship features with confidence.

## What This Skill Does

Plans and executes product releases including pre-release checks, deployment coordination, release communications, and post-release monitoring. Ensures launches are smooth and successful.

## When to Use

Activate this skill when:
- User needs to plan or execute a release
- Phrases like "plan the release", "launch checklist", "go live"
- Preparing to deploy to production
- Coordinating release communications
- User says "are we ready to launch" or "release plan"

## How It Works

The release process ensures successful deployments:

1. **Define release** - Specify scope, timeline, success criteria
2. **Pre-release checks** - Verify quality and readiness
3. **Plan deployment** - Coordinate technical rollout
4. **Prepare communications** - Create announcements and docs
5. **Execute release** - Deploy and monitor
6. **Post-release** - Verify success and handle issues

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `release_name` | string | Yes | Name or version of the release |
| `scope` | string | No | What's being released (features, fixes, etc.) |
| `type` | string | No | `major`, `minor`, `patch`, `hotfix` |

## Output Structure

The skill generates release outputs:

1. **Release plan** - Detailed plan with timeline and owners
2. **Release checklist** - Pre-flight verification items
3. **Communications** - Announcements and documentation
4. **Runbook** - Step-by-step execution guide

### Release Plan Format

```markdown
# Release Plan: [Release Name]

## Overview
- **Version**: [Version number]
- **Type**: Major / Minor / Patch / Hotfix
- **Target Date**: [Date and time]
- **Release Owner**: [Name]
- **Status**: Planning / Ready / In Progress / Complete

## Scope
### Features
| Feature | Description | Tickets | Status |
|:--------|:-------------|:--------|:--------|
| Feature A | [Description] | [Links] | ✅ Ready |
| Feature B | [Description] | [Links] | 🔄 In Progress |

### Fixes
| Fix | Description | Tickets | Status |
|:----|:-------------|:--------|:--------|
| Fix A | [Description] | [Links] | ✅ Ready |

### Known Issues
| Issue | Impact | Workaround | Fix Version |
|:------|:-------|:-----------|:------------|
| [Issue] | [Impact] | [Workaround] | [Version] |

## Timeline

```
Pre-release: ███████████ (T-7 days)
Code freeze: █ (T-3 days)
QA sign-off: █ (T-1 day)
Deploy: █ (T-day)
Monitor: ████████ (T+7 days)
```

| Date | Milestone | Owner | Status |
|:-----|:---------|:-------|:--------|
| T-7 days | Release planning complete | PM | ✅ |
| T-5 days | Feature complete | Engineering | 🔄 |
| T-3 days | Code freeze | Tech Lead | ⏳ |
| T-1 day | QA sign-off | QA | ⏳ |
| T-day | Deploy to production | DevOps | ⏳ |
| T+1 day | Verify release | PM | ⏳ |
| T+7 days | Post-release review | PM | ⏳ |

## Pre-Release Checklist

### Engineering
- [ ] All code reviewed and merged
- [ ] Tests passing (unit, integration, e2e)
- [ ] No critical bugs outstanding
- [ ] Performance tested
- [ ] Security review complete
- [ ] Database migrations prepared
- [ ] Rollback plan documented

### Quality
- [ ] QA testing complete
- [ ] Acceptance criteria met
- [ ] Edge cases tested
- [ ] Browser/device compatibility verified
- [ ] Accessibility tested

### Product
- [ ] PRD requirements verified
- [ ] Success metrics defined
- [ ] Analytics events implemented
- [ ] Feature flags configured

### Documentation
- [ ] User documentation updated
- [ ] API documentation current
- [ ] Release notes drafted
- [ ] Internal runbook prepared

### Communications
- [ ] Announcement email drafted
- [ ] In-app notification prepared
- [ ] Support team briefed
- [ ] Sales/CS informed
- [ ] Stakeholders notified

### Legal/Compliance
- [ ] Privacy review complete
- [ ] Terms updated if needed
- [ ] Compliance verified

## Deployment Plan

### Rollout Strategy
- **Approach**: Big bang / Gradual rollout / Feature flag
- **Phases**: [If gradual, describe phases]
- **Target users**: [Initial audience if gradual]

### Deployment Steps
| Step | Action | Owner | ETA | Status |
|:-----|:------|:-------|:----|:--------|
| 1 | Deploy to staging | DevOps | 15 min | ⏳ |
| 2 | Smoke test staging | QA | 10 min | ⏳ |
| 3 | Enable feature flag | Engineering | 5 min | ⏳ |
| 4 | Deploy to production | DevOps | 30 min | ⏳ |
| 5 | Smoke test production | QA | 10 min | ⏳ |
| 6 | Ramp up to 100% | Engineering | 1 hour | ⏳ |
| 7 | Monitor metrics | PM | 2 hours | ⏳ |

### Rollback Plan
| Condition | Action | Owner |
|:----------|:-------|:-------|
| Critical bug detected | Rollback to previous version | DevOps |
| Error rate > 5% | Rollback, investigate | DevOps |
| Performance degraded | Rollback, scale | DevOps |

## Communications

### Release Notes
```markdown
## What's New

### Feature Highlight
[Main feature description]

### Improvements
- [Improvement 1]
- [Improvement 2]

### Bug Fixes
- [Fix 1]
- [Fix 2]

### Known Issues
- [Known issue 1]
```

### Announcement Template
**Subject**: [Feature Name] is now available!

**Body**: [Benefits and how to use]

## Post-Release

### Monitoring (First 24 hours)
| Metric | Target | Alert Threshold | Owner |
|:-------|:-------|:----------------|:-------|
| Error rate | < 0.5% | > 1% | Engineering |
| Latency (p95) | < 500ms | > 1s | Engineering |
| Conversion | Maintained | -10% baseline | PM |
| Support tickets | Normal | > 2x baseline | Support |

### Success Criteria
- [ ] No critical bugs in production
- [ ] Performance within acceptable range
- [ ] Success metrics tracking correctly
- [ ] User feedback positive
- [ ] Support can handle inquiries

## Risk Assessment
| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| [Risk] | Low/Med/High | Low/Med/High | [Mitigation] |
```

## Release Types

| Type | Description | Preparation Time | Risk Level |
|:---|:---|:---|:---|
| **Hotfix** | Urgent production fix | Hours | High |
| **Patch** | Bug fixes only | Days | Low |
| **Minor** | New features, backward compatible | 1-2 weeks | Medium |
| **Major** | Breaking changes, significant features | 1-2 months | High |

## Quality Standards

Before releasing, ensure:
- All checklist items are verified
- Rollback plan is documented and tested
- Communications are prepared and approved
- Stakeholders are informed of timeline
- Monitoring and alerting are configured
- Success criteria are defined and measurable

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates complete release plan from project status |
| `copilot` | Drafts plan, validates key decisions with you |
| `manual` | Provides templates, you customize |

## Context Integration

**Reads:**
- `context/project-plan.md` - Project status and scope
- `context/metrics.json` - Baseline metrics for comparison

**Writes:**
- `context/release-plan.md` - Release plan and checklist
- `context/release-notes/[version].md` - Release notes

**Read By:**
- `impact-analysis` - Uses release data for post-release analysis

## Example Usage

```
User: "Create a release plan for v2.5"
→ Generates comprehensive release plan with checklist

User: "Are we ready to launch?"
→ Runs through pre-release checklist and reports status

User: "Draft release notes for the onboarding feature"
→ Creates user-facing release notes

User: "Plan the hotfix for the login bug"
→ Creates expedited release plan for hotfix
```

## Best Practices

1. **Plan early** - Start release planning well before target date
2. **Test rollback** - Know you can undo the release
3. **Communicate proactively** - Keep stakeholders informed
4. **Monitor closely** - Watch production like a hawk post-release
5. **Learn from each release** - Document lessons learned
