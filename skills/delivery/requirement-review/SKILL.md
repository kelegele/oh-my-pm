---
name: requirement-review
description: 促进需求评审会议和干系人对齐。当用户需要与干系人评审需求、对功能达成一致、运行 PRD 评审，或说"评审这个 PRD"、"获得批准"、"需求评审会议"时使用。即使没有明确说"需求评审"，当用户正在准备干系人会议或需要对需求达成一致时也应激活。
layer: delivery
input-from: prd-gen
output-to: project-coordination,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Requirement Review

Align stakeholders on requirements before building.

## What This Skill Does

Prepares for and facilitates requirement review meetings where stakeholders validate, clarify, and commit to requirements. Ensures everyone understands what will be built, why it matters, and what success looks like.

## When to Use

Activate this skill when:
- User needs to review requirements with stakeholders
- Phrases like "review this PRD", "get sign-off", "requirement review"
- Preparing for stakeholder alignment meetings
- Validating requirements before development starts
- User says "do we agree on this" or "review meeting prep"

## How It Works

The review process ensures effective stakeholder alignment:

1. **Prepare materials** - Create review agenda and supporting documents
2. **Identify stakeholders** - Determine who needs to be involved
3. **Distribute pre-read** - Share materials in advance
4. **Facilitate meeting** - Run structured review session
5. **Capture decisions** - Document outcomes and action items
6. **Follow up** - Ensure decisions are implemented

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `prd_ref` | string | Yes | Reference to PRD being reviewed |
| `stakeholders` | list | No | Stakeholders to include (if different from PRD) |
| `focus` | string | No | Specific focus areas for review |

## Output Structure

The skill generates review outputs:

1. **Review agenda** - Structured meeting agenda
2. **Pre-read document** - Summary for stakeholders
3. **Meeting notes** - Decisions and action items
4. **Sign-off record** - Formal approval documentation

### Review Agenda Format

```markdown
# Requirement Review: [Feature Name]

## Meeting Details
- **Date**: [Date and time]
- **Duration**: 60 minutes
- **Attendees**: [Stakeholder list]
- **Location**: [Room or link]

## Preparation
- **Pre-read**: Sent [date] (attached)
- **Please review**: User stories, acceptance criteria, success metrics

## Agenda

| Time | Topic | Owner | Outcome |
|:-----|:------|:------|:--------|
| 0-5min | Welcome & purpose | PM | Align on meeting goal |
| 5-15min | Background & goals | PM | Understand why we're building this |
| 15-30min | Requirements walkthrough | PM | Clarify what we're building |
| 30-45min | Discussion & concerns | All | Raise issues, get answers |
| 45-55min | Decisions & action items | All | Commit to next steps |
| 55-60min | Wrap up | PM | Confirm sign-off |

## Preparation Checklist
- [ ] PRD finalized and shared
- [ ] Stakeholders invited
- [ ] Pre-read sent 48 hours in advance
- [ ] Prototype/demo available (if applicable)
- [ ] Questions from stakeholders collected

## Discussion Questions
1. Does this solve the right problem?
2. Are we missing any requirements?
3. Are the success metrics realistic?
4. What could go wrong?
5. What are we not building that we should?
```

### Meeting Notes Format

```markdown
# Requirement Review Notes: [Feature Name]

**Date**: [Date]
**Attendees**: [Names]

## Overview
[Quick summary of the meeting]

## Decisions Made

| Decision | Decision Maker | Rationale |
|:---------|:--------------|:----------|
| Decision 1 | [Who decided] | [Why] |
| Decision 2 | [Who decided] | [Why] |

## Requirements Clarified

| Requirement | Clarification | Impact |
|:------------|:--------------|:--------|
| Req 1 | [What was clarified] | [How it affects things] |
| Req 2 | [What was clarified] | [How it affects things] |

## Issues Raised

| Issue | Severity | Owner | Resolution |
|:------|:---------|:-------|:-----------|
| Issue 1 | High/Medium/Low | [Who owns it] | [How to resolve] |
| Issue 2 | High/Medium/Low | [Who owns it] | [How to resolve] |

## Action Items

| Action | Owner | Due Date | Status |
|:-------|:-------|:---------|:--------|
| [ ] Action 1 | [Who] | [When] | Open/Done |
| [ ] Action 2 | [Who] | [When] | Open/Done |

## Concerns / Objections
| Concern | Raised By | Response |
|:---------|:---------|:----------|
| [Concern] | [Who] | [How addressed] |

## Sign-off

| Stakeholder | Role | Approval | Date |
|:------------|:-----|:---------|:------|
| [Name] | [Role] | ✅/⚠️/❌ | [Date] |

**Next Steps**:
1. [ ] Update PRD with decisions
2. [ ] Schedule prototype review (if needed)
3. [ ] Kick off engineering planning
```

## Review Checklist

Before the review:
- [ ] PRD is complete and reviewed by PM
- [ ] User stories have acceptance criteria
- [ ] Success metrics are defined
- [ ] Dependencies are identified
- [ ] Prototype or mockup is available (if applicable)

During the review:
- [ ] Goals and context are clear
- [ ] Requirements are understood
- [ ] Questions are answered
- [ ] Concerns are addressed
- [ ] Decisions are documented

After the review:
- [ ] Notes are distributed
- [ ] PRD is updated with decisions
- [ ] Action items are assigned
- [ ] Sign-off is documented
- [ ] Next steps are scheduled

## Quality Standards

Before concluding, ensure:
- All stakeholders have had opportunity to provide input
- Decisions are documented with rationale
- Action items have clear owners and due dates
- Concerns are acknowledged with plans to address
- PRD is updated to reflect decisions
- Sign-off is obtained from key stakeholders

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates agenda, pre-read, and meeting template |
| `copilot` | Drafts materials, reviews key discussion points with you |
| `manual` | Provides templates, you customize and facilitate |

## Context Integration

**Reads:**
- `context/prd/*.md` - Requirements being reviewed
- `context/user-research.json` - User insights to reference

**Writes:**
- `context/review-notes/[feature]-[date].md` - Meeting documentation
- `context/sign-off/[feature]-signoff.md` - Approval record

**Read By:**
- `project-coordination` - Uses decisions for implementation planning

## Example Usage

```
User: "Prepare for the PRD review meeting"
→ Generates agenda, pre-read, and meeting template

User: "Document the requirement review decisions"
→ Creates structured meeting notes and action items

User: "Get stakeholder sign-off on the checkout flow"
→ Generates sign-off document and tracks approvals
```

## Best Practices

1. **Send pre-reads early** - Give stakeholders 48 hours to review
2. **Focus on outcomes** - What decisions need to be made?
3. **Capture concerns** - Even if you can't address them immediately
4. **Document decisions** - Write down the "why" not just the "what"
5. **Follow through** - Ensure action items are completed
