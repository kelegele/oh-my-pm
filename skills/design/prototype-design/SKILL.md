---
name: prototype-design
description: 创建交互式原型和 UI 流程以验证设计方案。当用户需要设计 UI/UX、创建原型、设计用户流程，或说"创建原型"、"设计这个功能"、"UI 原型"时使用。即使没有明确说"原型"，当用户正在处理用户界面设计、交互设计或需要可视化某事物如何工作时也应激活。
layer: design
input-from: prd-gen,user-research
output-to: project-coordination,requirement-review
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Prototype Design

Visualize and validate design solutions before building.

## What This Skill Does

Creates interactive prototypes, wireframes, and user flows that bring PRDs to life. Enables early validation with stakeholders and users, reducing rework and ensuring the final product meets user needs.

## When to Use

Activate this skill when:
- User needs to design or prototype a feature
- Phrases like "create prototype", "design this", "UI mockup", "wireframe"
- Visualizing user flows or interaction patterns
- Validating design concepts before development
- User says "show me how it looks" or "design the UX"

## How It Works

The prototype design process ensures user-centered designs:

1. **Understand requirements** - Review PRD, user research, constraints
2. **Map user flow** - Define the happy path and edge cases
3. **Sketch wireframes** - Create low-fidelity layouts
4. **Design UI** - Apply visual design, interactions, animations
5. **Make interactive** - Add click-throughs and state changes
6. **Validate** - Test with users, gather feedback

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `prd_ref` | string | Yes | Reference to PRD being designed |
| `fidelity` | string | No | `wireframe` (low), `mockup` (medium), `prototype` (high, default) |
| `platform` | string | No | `web`, `ios`, `android` (default: from context) |

## Output Structure

The skill generates design outputs:

1. **User flows** - Flow diagrams showing screen sequences
2. **Wireframes/Mockups** - Screen designs at appropriate fidelity
3. **Interactive prototype** - Clickable prototype for testing
4. **Design specs** - Annotations for developers

### User Flow Format

```markdown
## User Flow: [Feature Name]

### Happy Path
```
Login → Dashboard → [Feature] → [Action] → Success → Confirmation
```

### Edge Cases
| Scenario | Flow |
|:---------|:-----|
| No permission → Error screen → Suggested action |
| Network error → Retry dialog → Resume on success |
| First-time use → Onboarding → Main flow |

### Screen Inventory
| Screen | Purpose | Key Elements |
|:-------|:--------|:-------------|
| Screen 1 | [Purpose] | [Element list] |
```

### Design Spec Format

```markdown
## Design Specs: [Screen Name]

### Layout
- **Dimensions**: 375 × 812 (iPhone X)
- **Safe area**: Top 44pt, bottom 34pt
- **Grid**: 8pt columns, 16pt gutters

### Components
| Component | Specs | Interaction |
|:----------|:------|:------------|
| Primary Button | 48pt height, 16pt padding, blue background | Tap action |
| Text Input | 44pt height, 12pt padding, light border | Focus expands, shows validation |

### Typography
| Element | Font | Size | Weight | Color |
|:--------|:-----|:-----|:-------|:------|
| Headline | SF Pro | 24pt | Semibold | #1A1A1A |
| Body | SF Pro | 16pt | Regular | #666666 |

### Colors
| Usage | Color | Hex |
|:------|:-----|:-----|
| Primary | Blue | #007AFF |
| Success | Green | #34C759 |
| Error | Red | #FF3B30 |
| Background | Gray | #F5F5F5 |

### States
| Component | Normal | Hover/Focus | Disabled | Error |
|:----------|:-------|:-----------|:---------|:------|
| Button | Blue | Dark blue | Light gray | N/A |
| Input | Gray border | Blue border | Lighter gray | Red border |

### Interactions
| Element | Action | Transition | Feedback |
|:--------|:-------|:-----------|:---------|
| Button | Tap | Scale 0.98 → 1.0 (0.1s) | Haptic |
| Form | Submit | Fade to success | Toast message |
```

## Fidelity Levels

| Level | When to Use | Output |
|:---|:---|:---|
| `wireframe` | Early exploration, concept validation | Box layouts, no visuals |
| `mockup` | Stakeholder review, user testing | Visual design, static |
| `prototype` | Final validation, developer handoff | Interactive, annotated |

## Design Tools Integration

The skill can work with various tools:
- **Figma** - Generate design specs and prototype links
- **Sketch** - Create symbols and shared styles
- **Pen and paper** - Photo documentation of sketches
- **Code prototypes** - HTML/CSS for web concepts

## Quality Standards

Before delivering, the design should:
- Address all requirements from the PRD
- Follow established design system (if exists)
- Be accessible (contrast, touch targets, screen readers)
- Handle edge cases and error states
- Include annotations for developers
- Be testable with users

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates complete design from PRD |
| `copilot` | Drafts flow and key screens, validates with you |
| `manual` | Provides templates, you create design |

## Context Integration

**Reads:**
- `context/prd/*.md` - Requirements to design
- `context/user-research.json` - User needs and behaviors
- `context/positioning.md` - Brand guidelines (if available)

**Writes:**
- `context/design/*.md` - Design documentation
- `context/design/flows/` - User flow diagrams

**Read By:**
- `project-coordination` - Uses designs for implementation planning
- `requirement-review` - Validates designs meet requirements

## Example Usage

```
User: "Create a prototype for the onboarding flow"
→ Generates user flow, wireframes, and interactive prototype

User: "Design the settings screen"
→ Creates mockup with component specs

User: "Show me the checkout flow"
→ Produces user flow diagram with screens
```

## Best Practices

1. **Start with flows** - Don't jump straight to screens
2. **Design for edge cases** - Error states, empty states, loading
3. **Use design systems** - Don't reinvent components
4. **Make it interactive** - Static designs hide usability issues
5. **Test early** - Validate with real users before finalizing
