---
name: prd-gen
description: Generate structured Product Requirements Documents (PRDs) from feature requirements. Use this skill whenever the user wants to create a PRD, document new features, write product specs, formalize user stories, says "write a PRD for X", needs to document requirements, or is preparing for product review meetings. Even if they don't say "PRD" explicitly, activate when they need structured product documentation with user stories, acceptance criteria, and success metrics.
layer: design
input-from: product-positioning,prioritization,competitive-analysis
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# PRD Generation

Generate structured Product Requirements Documents from feature ideas.

## What This Skill Does

Transforms informal feature requests into complete PRDs with user stories, acceptance criteria, functional requirements, success metrics, and delivery timelines. The output is ready for engineering teams to implement and stakeholders to review.

## When to Use

Activate this skill when:
- User wants to document a new feature or product idea
- Phrases like "write a PRD", "create requirements", "document this feature"
- Preparing for product review, stakeholder alignment, or engineering handoff
- User mentions user stories, acceptance criteria, or success metrics
- Need to formalize a rough idea into structured documentation

## How It Works

The generation process ensures complete, actionable PRDs:

1. **Parse requirements** - Structure the user's feature request into key components
2. **Gather context** - Read market analysis, competitive insights, user research
3. **Assemble sections** - Build each PRD section with appropriate detail
4. **Verify completeness** - Check against quality standards
5. **Generate output** - Write to `context/prd-draft.md`

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `requirements` | string | Yes | Feature description or user story to document |
| `target_audience` | string | No | Target user segment or persona |
| `context_refs` | list | No | Related context files to reference |

## Output Structure

The PRD follows this structure for consistency:

```markdown
# [Feature Name] PRD

## Document Info
- **Created**: YYYY-MM-DD
- **Status**: Draft/Review/Approved

## 1. Background & Goals
### 1.1 Business Context
[Market and competitive background from context files]

### 1.2 Objectives
- **Primary**: [Quantified core objective]
- **Secondary**: [Supporting objectives]

### 1.3 Success Metrics
| Metric | Baseline | Target | How to Measure |
|:-------||:---------|:-------|:---------------|
| XXX | 0 | 100 | Event tracking |

## 2. User Stories
### 2.1 Target Users
| Role | Description | Core Needs |
|:-----|:-----------|:-----------|
| User A | [From user-research] | XXX |

### 2.2 User Stories
- **US-1**: As a [role], I want [feature], so that [value]
  - Acceptance: Given [context], When [action], Then [outcome]

- **US-2**: ...

## 3. Functional Requirements
### 3.1 Core Features
| ID | Description | Priority | Dependencies |
|:---|:-----------|::--------|:-------------|
| F-001 | XXX | P0 | None |

### 3.2 Feature Details
#### F-001: [Feature Name]
**Description**: [Detailed description]

**Interaction Flow**:
1. Step one
2. Step two

**Edge Cases**:
- Normal: ...
- Exception: ...

### 3.3 Non-Functional Requirements
- **Performance**: Response time < 200ms
- **Security**: Encrypted data storage
- **Compatibility**: iOS 14+, Android 10+

## 4. Constraints & Dependencies
### 4.1 Technical Constraints
- [List technical limitations]

### 4.2 Business Constraints
- [List business limitations]

### 4.3 External Dependencies
- [External systems/services required]

## 5. Milestones & Timeline
| Phase | Deliverable | Timeline |
|:------|:------------|:---------|
| Design | Prototype | Week 1 |
| Development | Feature launch | Week 3 |

## 6. Risks & Mitigation
| Risk | Probability | Impact | Mitigation |
|:-----|:------------|:-------|:-----------|
| XXX | Medium | High | XXX |

## Appendix
- References: [links]
- Competitive analysis: [link]
```

## User Story Format

Each user story follows this template:

```
US-{NN}: [Brief feature description]

As a [user role]
I want [feature description]
So that [business value]

**Acceptance Criteria**:
- Given [precondition]
- When [I do X]
- Then [expected outcome]

**Priority**: P0/P1/P2
**Estimate**: X story points
```

## Quality Standards

Before delivering, the PRD should include:
- All 6 required sections (background, user stories, features, non-functional, constraints, milestones)
- User stories in "As a... I want... So that..." format
- 3+ quantifiable success metrics
- Dependencies and constraints clearly identified
- References to context sources

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates complete PRD automatically, writes to file |
| `copilot` | Shows PRD outline, confirms each section with you before finalizing |
| `manual` | Provides PRD template, you fill in the content |

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `context/market-analysis.json` - Market background
- `context/competitive-analysis.json` - Competitive comparison
- `context/user-research.json` - User insights

**Writes:**
- `context/prd-draft.md` - The generated PRD

## Example Usage

```
User: "Write a PRD for dark mode"
→ Generates complete PRD with user stories, requirements, metrics

User: "Document the user onboarding feature"
→ Activates prd-gen to create structured requirements

User: "I need user stories for the checkout flow"
→ Generates PRD section focused on checkout user stories
```
