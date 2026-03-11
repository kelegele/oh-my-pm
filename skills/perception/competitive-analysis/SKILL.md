---
name: competitive-analysis
description: Analyze competitor products, generate feature comparison matrices, and identify strategic opportunities. Use this skill whenever the user mentions competitors, competitive research, feature comparison, "what do competitors offer", "compare with [product]", market positioning, or needs to understand the competitive landscape. Even if they don't explicitly say "competitive analysis", activate when they're clearly evaluating their product against others.
layer: perception
input-from: market-intelligence
output-to: product-positioning,prioritization,prd-gen
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Competitive Analysis

Generate competitive intelligence that drives product decisions.

## What This Skill Does

Analyzes competitor products to identify what features they have, where they excel, and where opportunities exist for differentiation. The output helps prioritize features and refine product positioning.

## When to Use

Activate this skill when:
- User mentions competitor names or asks "what do competitors offer"
- Comparing features between products ("does X have feature Y?")
- Evaluating market differentiation for a new feature
- Preparing product positioning or strategy documents
- User says things like "competitive analysis", "market research", "competitor comparison"

## How It Works

The analysis follows a systematic approach:

1. **Identify competitors** - Map user-provided names to known products
2. **Gather feature data** - Collect information about what competitors offer
3. **Build comparison matrix** - Create side-by-side feature comparison
4. **Analyze gaps** - Identify missing features, unique advantages, opportunities
5. **Generate recommendations** - Provide actionable strategic insights

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `competitors` | list | Yes | Competitor products or company names to analyze |
| `feature_focus` | string | No | Specific feature area to focus on (e.g., "pricing", "user management") |
| `analysis_depth` | string | No | `overview` (quick), `detailed` (standard, default), or `deep-dive` (comprehensive) |

## Output Structure

The skill generates two outputs:

1. **JSON file** (`context/competitive-analysis.json`) - Structured data for other skills to consume
2. **Markdown report** - Human-readable analysis with tables and recommendations

### JSON Output Format

```json
{
  "analyses": [{
    "id": "uuid",
    "timestamp": "2026-03-11T...",
    "competitors": ["Competitor A", "Competitor B"],
    "feature_matrix": {
      "Feature 1": {
        "our_product": "supported",
        "competitor_a": "supported",
        "competitor_b": "partial"
      }
    },
    "gaps": {
      "missing_features": ["Feature X", "Feature Y"],
      "unique_advantages": ["Feature Z"]
    },
    "opportunities": ["Opportunity 1", "Opportunity 2"],
    "recommendations": ["Recommendation 1", "Recommendation 2"]
  }],
  "last_updated": "2026-03-11T..."
}
```

### Markdown Report Structure

```markdown
# Competitive Analysis Report

## Overview
- Competitors analyzed: X
- Date: YYYY-MM-DD
- Focus area: XXX

## Feature Comparison Matrix
| Feature | Our Product | Competitor A | Competitor B |
|:--------|:------------|:-------------|:-------------|
| Feature 1 | ✅ | ✅ | ⚠️ |

## Gap Analysis
### Missing Features
- Feature X: Supported by competitors A and B, indicates market expectation...

### Unique Advantages
- Feature Z: Only we offer this, potential differentiator...

## Strategic Recommendations
1. Short-term: Address missing feature X for parity
2. Medium-term: Leverage unique advantage Z in marketing
3. Long-term: Consider差异化方向 Y
```

## Analysis Depth Levels

Choose the appropriate depth based on your needs:

| Depth | When to Use | What You Get |
|:---|:---|:---|
| `overview` | Quick competitive check | Core features compared, 3 recommendations |
| `detailed` | Standard analysis (default) | Full feature matrix, gap analysis, 5 recommendations |
| `deep-dive` | Strategic decisions | User experience review, pricing analysis, user sentiment, 10 recommendations |

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Completes full analysis automatically, generates report |
| `copilot` | Shows comparison matrix, waits for your confirmation on recommendations |
| `manual` | Provides competitor information, you complete the analysis |

## Quality Standards

Before delivering, the analysis should:
- Cover at least 2 competitors
- Compare 5+ core features
- Provide 3+ actionable recommendations
- Distinguish between "missing features" and "strategic omissions"
- Be valid JSON for downstream skills to consume

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `context/market-analysis.json` - Market trends that inform competitive landscape

**Writes:**
- `context/competitive-analysis.json` - Analysis results for other skills (prd-gen, product-positioning)

## Example Usage

```
User: "How does our pricing compare to Stripe and Braintree?"
→ Activates competitive-analysis with feature_focus="pricing"

User: "What features do ClickUp and Asana have that we don't?"
→ Activates competitive-analysis for those competitors

User: "Do competitors offer dark mode?"
→ Activates competitive-analysis with feature_focus="dark mode"
```
