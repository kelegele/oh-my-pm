---
name: competitive-analysis
description: 竞品功能对比分析，生成对比矩阵并识别战略机会。当用户提到竞品、竞品研究、功能对比、"竞品有什么"、"对比XX产品"、市场定位，或需要了解竞争格局时使用。即使没有明确说"竞品分析"，当用户明显在评估自己产品与竞品差异时也应激活。
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

## Anti-Hallucination Rules

本 Skill 必须遵守 `skills/shared/anti-hallucination-rules.md` 中的约束：
- **搜索先行**: 输出任何竞品数据前必须先使用 WebSearch/WebReader 访问竞品官网或文档
- **来源必注**: 每个功能声明、定价、用户评价必须有 URL 来源
- **未知可接受**: 无法确认的功能标注 "Unknown"，禁止编造
- **置信度**: 每个功能声明标注 confidence (high/medium/low)
- **事实与推断分离**: 明确区分已验证功能和推断

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `competitors` | list | Yes | Competitor products or company names to analyze |
| `feature_focus` | string | No | Specific feature area to focus on (e.g., "pricing", "user management") |
| `analysis_depth` | string | No | `overview` (quick), `detailed` (standard, default), or `deep-dive` (comprehensive) |

## Output Structure

The skill generates two outputs:

1. **JSON file** (`context/competitive-analysis/{feature-name}-{date}.json`) - Structured data for other skills to consume
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
        "competitor_a": { "status": "supported", "confidence": "high", "source": { "url": "https://competitor-a.com/features", "fetched_at": "2026-03-11T..." } },
        "competitor_b": { "status": "partial", "confidence": "high", "source": { "url": "https://competitor-b.com/pricing", "fetched_at": "2026-03-11T..." } }
      }
    },
    "gaps": {
      "missing_features": [
        { "feature": "Feature X", "supported_by": ["Competitor A", "Competitor B"], "confidence": "high" }
      ],
      "unique_advantages": [
        { "feature": "Feature Z", "confidence": "medium", "basis": "No competitor found offering this" }
      ]
    },
    "opportunities": [{ "opportunity": "Opportunity 1", "confidence": "medium", "basis": "..." }],
    "recommendations": [{ "recommendation": "Recommendation 1", "priority": "high" }]
  }],
  "search_record": {
    "search_queries_used": ["Competitor A features 2026", "Competitor B pricing page"],
    "sources_accessed": [{ "url": "https://...", "title": "Competitor A Features", "used_for": "feature verification" }]
  },
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
- Compare 5+ core feature areas
- **ALL** feature claims have source URLs (competitor official page, docs, or verified third-party)
- **ALL** data points have confidence rating (high/medium/low)
- Features that cannot be verified are marked "Unknown" — do NOT fabricate
- Facts and inferences are clearly distinguished
- Search record is included proving searches were executed
- Provide 3+ actionable recommendations based on real data
- Distinguish between "missing features" and "strategic omissions"
- Be valid JSON for downstream skills to consume

## Context Integration

This skill reads from and writes to the shared context:

**Reads:**
- `context/market-analysis.json` - Market trends that inform competitive landscape

**Writes:**
- `context/competitive-analysis/{feature-name}-{date}.json` - Analysis results for other skills (prd-gen, product-positioning)
- `context/competitive-analysis/{feature-name}-{date}.md` - Human-readable markdown report
- Legacy: `context/competitive-analysis.json` for backward compatibility

## Example Usage

```
User: "How does our pricing compare to Stripe and Braintree?"
→ Activates competitive-analysis with feature_focus="pricing"

User: "What features do ClickUp and Asana have that we don't?"
→ Activates competitive-analysis for those competitors

User: "Do competitors offer dark mode?"
→ Activates competitive-analysis with feature_focus="dark mode"
```
