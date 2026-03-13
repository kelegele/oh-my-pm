---
name: market-intelligence
description: 收集市场趋势、行业报告，并识别机会。当用户需要市场研究、行业分析、趋势识别、"X 市场发生了什么"、市场规模分析，或在产品规划前需要了解竞争格局时使用。即使没有明确说"市场情报"，当用户正在研究某个市场或行业时也应激活。
layer: perception
input-from: user
output-to: product-positioning,competitive-analysis,roadmap-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Market Intelligence

Gather market insights that inform product strategy.

## What This Skill Does

Collects and analyzes market information including industry trends, market size, growth rates, key players, and emerging opportunities. The output provides the foundation for product positioning and competitive analysis.

## When to Use

Activate this skill when:
- User asks about market trends or industry developments
- Phrases like "market research", "industry analysis", "market size"
- Exploring new markets or product categories
- Need to understand market dynamics before product decisions
- User says "what's the market for X" or "analyze Y market"

## How It Works

The intelligence gathering follows a systematic approach:

1. **Define market scope** - Identify the market segment and research boundaries
2. **Search industry sources** - Gather reports, news, analyst insights
3. **Analyze trends** - Identify emerging patterns and shifts
4. **Assess market size** - Estimate TAM, SAM, SOM
5. **Identify opportunities** - Find gaps and growth areas
6. **Generate insights** - Synthesize findings into actionable intelligence

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `market` | string | Yes | Market or industry to analyze (e.g., "SaaS project management") |
| `focus_areas` | list | No | Specific areas to focus on (e.g., ["pricing", "enterprise segment"]) |
| `geography` | string | No | Geographic scope (default: global) |
| `depth` | string | No | `overview` (quick), `standard` (default), or `deep` (comprehensive) |

## Output Structure

The skill generates two outputs:

1. **JSON file** (`context/market-analysis.json`) - Structured data for other skills
2. **Markdown report** - Human-readable market intelligence

### JSON Output Format

```json
{
  "analysis": {
    "id": "uuid",
    "timestamp": "2026-03-12T...",
    "market": "SaaS project management",
    "market_size": {
      "tam": "$10B",
      "sam": "$3B",
      "som": "$300M"
    },
    "growth_rate": "15% CAGR",
    "key_trends": [
      "AI-powered automation",
      "Remote work collaboration",
      "Industry-specific solutions"
    ],
    "key_players": ["Asana", "Monday.com", "ClickUp", "Linear"],
    "opportunities": [
      "Small business segment underserved",
      "Integration ecosystem gaps"
    ],
    "threats": [
      "Market saturation in mid-market",
      "Platform vendor consolidation"
    ]
  },
  "last_updated": "2026-03-12T..."
}
```

### Markdown Report Structure

```markdown
# Market Intelligence Report

## Market Overview
- **Market**: SaaS Project Management
- **Date**: YYYY-MM-DD
- **Geography**: Global

## Market Size
| Segment | Size | Growth |
|:--------|-----:|:-------|
| TAM (Total Addressable Market) | $10B | 15% CAGR |
| SAM (Serviceable Addressable Market) | $3B | 18% CAGR |
| SOM (Serviceable Obtainable Market) | $300M | 25% CAGR |

## Key Trends
1. **AI-Powered Automation** - Teams are demanding AI assistance for task management...
2. **Remote Work Collaboration** - Post-pandemic shift continues driving demand...
3. **Industry-Specific Solutions** - Generic tools losing ground to vertical products...

## Key Players
| Company | Market Share | Strength | Weakness |
|:--------|-------------:|:---------|:---------|
| Asana | 20% | Enterprise features | Expensive |
| Monday.com | 18% | UX simplicity | Limited customization |

## Opportunities
- **Small Business Segment**: Underserved by enterprise-focused tools
- **Integration Ecosystem**: Gaps in connecting with specialized tools

## Threats
- Market saturation in mid-market segment
- Platform vendors (Microsoft, Google) adding features

## Strategic Recommendations
1. Focus on small business segment for growth
2. Build deep integrations with developer tools
3. Consider vertical specialization (e.g., for agencies)
```

## Analysis Depth Levels

| Depth | When to Use | What You Get |
|:---|:---|:---|
| `overview` | Quick market check | Market size, 3 trends, 5 key players |
| `standard` | Regular analysis (default) | Full sizing, trends, opportunities, threats, recommendations |
| `deep` | Strategic decisions | Segmentation analysis, buying patterns, vendor landscape, 10+ recommendations |

## Quality Standards

Before delivering, the intelligence should:
- Cover market size (TAM/SAM/SOM)
- Identify 5+ key trends
- List 5+ major players
- Provide 3+ actionable opportunities
- Note 2+ significant threats
- Be valid JSON for downstream skills

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Completes full analysis automatically, generates report |
| `copilot` | Shows findings, waits for your confirmation on insights |
| `manual` | Provides market data sources, you complete the analysis |

## Context Integration

**Writes:**
- `context/market-analysis.json` - Analysis results for other skills (product-positioning, competitive-analysis)

**Read By:**
- `product-positioning` - Uses market data for positioning strategy
- `competitive-analysis` - References key players for comparison
- `roadmap-planning` - Uses trends for strategic planning

## Example Usage

```
User: "What's the market for AI writing assistants?"
→ Activates market-intelligence for that market

User: "Research the project management software market"
→ Activates market-intelligence with focus on SaaS PM tools

User: "Is the fitness app market growing?"
→ Activates market-intelligence with depth=overview
```
