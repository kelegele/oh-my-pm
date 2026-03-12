---
name: quick-prd
description: Generate a complete PRD with competitive analysis in one workflow. Use this skill when the user needs a PRD with competitive context, wants to quickly document a feature, says "write a PRD with competitor comparison", or needs a comprehensive product requirements document. Activate whenever they mention PRD creation with competitive research, or say things like "analyze competitors and write requirements" or "quick PRD for X".
layer: workflow
input-from: user
output-to: requirement-review,prototype-design
mode-support: [autopilot, copilot, manual]
version: 0.2.0
context-requirements:
  - scenario: iteration
    required: [current_feature_desc, ui_state, iteration_goal]
    ui_state_options: [screenshot, html_file, online_url]
  - scenario: new_feature
    required: [product_architecture, design_specs, entry_point]
  - scenario: new_product
    required: [background, constraints, reference_products]
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
| 0 | scenario-detection | User input | Scenario type + required context | Never (critical first step) |
| 1 | competitive-analysis | Competitor list | competitive-analysis.json + .md | No competitors provided |
| 2 | prd-gen | Requirements + context + benchmarks | prd-{name}-{date}-v{version}.md | Never (core step) |

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `requirements` | string | Yes | Feature description to document |
| `competitors` | list | No | Competitors to analyze (optional) |
| `target_audience` | string | No | Target user segment |
| `mode` | string | No | `autopilot`/`copilot`/`manual` (default: `copilot`) |

## Execution Flow

### Step 0: Scenario Detection (REQUIRED - CRITICAL)

**Before any PRD generation, you MUST identify the scenario.**

1. Use `AskUserQuestion` to determine scenario type:
   - **迭代更新** - Iterating on existing feature
   - **新功能** - Adding new module to existing product
   - **0-1 新产品** - Building product from scratch

2. Collect required context based on scenario:

| Scenario | Required Information | Collection Method |
|:---------|:--------------------|:------------------|
| 迭代更新 | Current feature desc, UI state, iteration goal | User input + AskUserQuestion for UI option |
| 新功能 | Product architecture, design specs, entry point | Read from `context/` or user input |
| 0-1 新产品 | Background, constraints, reference products | User input + competitive analysis |

3. For **迭代更新**, ask user how to provide UI state:
   - **截图** (Screenshot) - Use image analysis tools
   - **HTML 文件** (HTML file) - Use Read tool
   - **在线链接** (Online URL) - Use web_reader (if accessible)

**Skipped when**: NEVER - This step is mandatory

### Step 1: Competitive Analysis (Optional)

If competitors are provided:

1. Activate `/competitive-analysis` with the competitor list
2. Extract feature focus from the requirements
3. Generate comparison matrix and recommendations
4. Save to `context/competitive-analysis/{feature-name}-{date}.json` + `.md`

**Skipped when**: No competitors specified or user opts out

### Step 2: PRD Generation (Required)

1. Activate `/prd-gen` with the requirements, scenario type, and collected context
2. Automatically reference competitive analysis (if available)
3. Include industry benchmarks research (user-specified + agent search)
4. Generate complete PRD with all required sections including scenario-specific context
5. Save to `context/prd/{feature-name}-{date}-v{version}.md`

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
- **Scenario**: [iteration/new-feature/new-product]
- **Duration**: ~3 minutes

### Skills Executed
1. ✅ scenario-detection (30 sec)
   - Scenario: [迭代更新/新功能/0-1新产品]
   - Context collected: [UI state/architecture/background]

2. ✅ competitive-analysis (2 min)
   - Analyzed: [Competitor A, Competitor B]
   - Output: context/competitive-analysis/{name}-{date}.json + .md

3. ✅ prd-gen (1 min)
   - Requirements: XXX
   - Benchmarks: 3+ industry references
   - Output: context/prd/{name}-{date}-v{version}.md

### Generated Documents
📄 **PRD**: context/prd/{feature-name}-{date}-v{version}.md
📊 **Competitive Analysis (JSON)**: context/competitive-analysis/{name}-{date}.json
📊 **Competitive Analysis (MD)**: context/competitive-analysis/{name}-{date}.md

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
  "completed_skills": ["scenario-detection", "competitive-analysis", "prd-gen"],
  "mode": "copilot",
  "scenario": "iteration",
  "started_at": "2026-03-11T...",
  "updated_at": "2026-03-11T...",
  "outputs": {
    "prd": "context/prd/{feature-name}-{date}-v{version}.md",
    "competitive_analysis_json": "context/competitive-analysis/{name}-{date}.json",
    "competitive_analysis_md": "context/competitive-analysis/{name}-{date}.md"
  }
}
```

## Collaboration Modes

| Mode | Step 0 (Scenario Detection) | Step 1 (Competitive Analysis) | Step 2 (PRD Generation) |
|:-----|:---------------------------|:------------------------------|:------------------------|
| `autopilot` | Ask once, proceed | Auto-execute, no confirmation | Auto-execute, no confirmation |
| `copilot` | Ask and confirm each input | Show results, wait for confirmation | Show outline, confirm sections |
| `manual` | Provide guidance, you decide | Provide suggestions, you decide | Provide template, you fill in |

## Context Integration

**Reads:**
- User input parameters

**Writes:**
- `context/competitive-analysis/{feature-name}-{date}.json` (Step 1, if competitors provided)
- `context/competitive-analysis/{feature-name}-{date}.md` (Step 1, human-readable report)
- `context/prd/{feature-name}-{date}-v{version}.md` (Step 2)
- `context/current-workflow.json` (state update)

## Quality Standards

Before completing, the workflow should:
- Execute scenario-detection (MANDATORY - never skip)
- Scenario type confirmed with user
- All required context for that scenario collected
- Execute prd-gen at minimum
- Have PRD generated with scenario field and benchmarks
- Reference competitive analysis in PRD (if analysis was run)
- Update current-workflow.json to "completed" status with scenario field

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
