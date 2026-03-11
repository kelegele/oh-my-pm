---
name: quick-prd
description: Generate a complete PRD with competitive analysis in one workflow. Use this skill when the user needs a PRD with competitive context, wants to quickly document a feature, says "write a PRD with competitor comparison", or needs a comprehensive product requirements document. Activate whenever they mention PRD creation with competitive research, or say things like "analyze competitors and write requirements" or "quick PRD for X".
layer: workflow
input-from: user
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Quick PRD Workflow

Generate a complete PRD with competitive analysis in one workflow.

## What This Workflow Does

Orchestrates multiple skills to produce a complete PRD with competitive context. First analyzes competitors (if provided), then generates the PRD incorporating those insights. Saves time by automating the full research-to-documentation flow.

## When to Use

Activate this workflow when:
- User needs a PRD with competitive analysis included
- Phrases like "quick PRD", "PRD with competitor comparison", "analyze and document"
- Preparing for product review with comprehensive context
- User wants both competitive insights AND structured requirements

## How It Works

The workflow executes skills in sequence:

```
User Input → Competitor Analysis (optional) → PRD Generation → Final Document
```

### Workflow Steps

| Step | Skill | Input | Output | Skip When |
|:-----|:-----|:------|:-------|:----------|
| 1 | competitive-analysis | Competitor list | competitive-analysis.json | No competitors provided |
| 2 | prd-gen | Requirements + context | prd-draft.md | Never (core step) |

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `requirements` | string | Yes | Feature description to document |
| `competitors` | list | No | Competitors to analyze (optional) |
| `target_audience` | string | No | Target user segment |
| `mode` | string | No | `autopilot`/`copilot`/`manual` (default: `copilot`) |

## Execution Flow

### Step 1: Competitive Analysis (Optional)

If competitors are provided:

1. Activate `/competitive-analysis` with the competitor list
2. Extract feature focus from the requirements
3. Generate comparison matrix and recommendations
4. Save to `context/competitive-analysis.json`

**Skipped when**: No competitors specified or user opts out

### Step 2: PRD Generation (Required)

1. Activate `/prd-gen` with the requirements
2. Automatically reference competitive analysis (if available)
3. Generate complete PRD with all required sections
4. Save to `context/prd-draft.md`

### Step 3: Summary

1. Compile all outputs
2. Update `context/current-workflow.json` state
3. Present final results to user

## Output Format

The workflow produces:

### Terminal Summary

```markdown
## Quick PRD Workflow Complete ✅

### Execution Summary
- **Workflow ID**: wf-20260311-001
- **Mode**: copilot
- **Duration**: ~3 minutes

### Skills Executed
1. ✅ competitive-analysis (2 min)
   - Analyzed: [Competitor A, Competitor B]
   - Output: context/competitive-analysis.json

2. ✅ prd-gen (1 min)
   - Requirements: XXX
   - Output: context/prd-draft.md

### Generated Documents
📄 **PRD Draft**: context/prd-draft.md
📊 **Competitive Analysis**: context/competitive-analysis.json

### Next Steps
- [ ] Run requirement review meeting
- [ ] Activate `/prototype-design` for mockups
- [ ] Share with stakeholders
```

### State Update

```json
{
  "workflow_id": "wf-20260311-001",
  "status": "completed",
  "current_layer": "design",
  "current_skill": "prd-gen",
  "completed_skills": ["competitive-analysis", "prd-gen"],
  "mode": "copilot",
  "started_at": "2026-03-11T...",
  "updated_at": "2026-03-11T...",
  "outputs": {
    "prd": "context/prd-draft.md",
    "competitive_analysis": "context/competitive-analysis.json"
  }
}
```

## Collaboration Modes

| Mode | Step 1 (Competitive Analysis) | Step 2 (PRD Generation) |
|:-----|:------------------------------|:------------------------|
| `autopilot` | Auto-execute, no confirmation | Auto-execute, no confirmation |
| `copilot` | Show results, wait for confirmation | Show outline, confirm sections |
| `manual` | Provide suggestions, you decide | Provide template, you fill in |

## Context Integration

**Reads:**
- User input parameters

**Writes:**
- `context/competitive-analysis.json` (Step 1, if competitors provided)
- `context/prd-draft.md` (Step 2)
- `context/current-workflow.json` (state update)

## Quality Standards

Before completing, the workflow should:
- Execute prd-gen at minimum
- Have prd-draft.md generated and non-empty
- Reference competitive analysis in PRD (if analysis was run)
- Update current-workflow.json to "completed" status

## Error Handling

| Error Scenario | Handling |
|:---------------|:----------|
| Competitive analysis fails | Warn user, continue with PRD generation |
| PRD generation fails | Terminate workflow, report error |
| Context write fails | Terminate workflow, check permissions |
| User interrupts | Save progress, support resume |

## Example Usage

### With Competitor Analysis

```
User: "Quick PRD for user profile redesign, compare with Taobao and JD"
→ Analyzes Taobao/JD user profiles
→ Generates PRD with competitive insights
→ Outputs complete documentation
```

### PRD Only (Skip Competitor Analysis)

```
User: "Quick PRD for dark mode"
→ Skips competitor analysis
→ Generates PRD directly
→ Outputs documentation
```

## Notes

This is a focused workflow for design-layer output. For the complete product management cycle (all 5 layers), use `/full-pm-cycle` when available.
