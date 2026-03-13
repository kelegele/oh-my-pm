---
name: product-positioning
description: 定义产品定位、差异化策略和价值主张。当用户需要产品定位、与竞品差异化、定义价值主张、撰写定位声明，或说"我们如何定位 X"、"我们有什么不同"、"定义我们的定位"时使用。即使没有明确说"定位"，当用户正在制定战略、传播信息或市场差异化时也应激活。
layer: strategy
input-from: competitive-analysis,user-research,market-intelligence
output-to: roadmap-planning,prioritization,prd-gen
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Product Positioning

Define how your product wins in the market.

## What This Skill Does

Creates compelling product positioning based on market insights, competitive landscape, and user needs. Defines value proposition, differentiation strategy, target market, and positioning statements that guide all product and marketing decisions.

## When to Use

Activate this skill when:
- User asks about product positioning or differentiation
- Phrases like "how do we position", "what makes us different", "value proposition"
- Defining target market or customer segments
- Creating messaging for launches or campaigns
- User says "define our positioning" or "positioning statement"

## How It Works

The positioning process ensures clear, compelling market positioning:

1. **Analyze context** - Review market, competitive, and user research
2. **Identify differentiation** - Find unique value and competitive advantages
3. **Define target market** - Specify ideal customer profile
4. **Craft positioning statement** - Create clear, memorable positioning
5. **Develop messaging** - Build supporting messaging hierarchy
6. **Validate** - Ensure positioning is credible and defensible

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `product_name` | string | Yes | Name of the product |
| `category` | string | Yes | Product category or market segment |
| `stage` | string | No | `new` (0-1), `pivot` (repositioning), `refine` (optimization) |

## Output Structure

The skill generates positioning outputs:

1. **Positioning document** (`context/positioning.md`) - Complete positioning strategy
2. **Messaging guide** - Key messages for different audiences

### Positioning Document Format

```markdown
# Product Positioning: [Product Name]

## Positioning Statement
For [target customer]
Who [statement of need/opportunity],
[Product Name] is a [product category]
That [key benefit/differentiator].
Unlike [primary competitive alternative],
We [statement of primary differentiation].

## Target Market
### Ideal Customer Profile (ICP)
- **Company Size**: [X-Y employees]
- **Industry**: [Specific industries]
- **Role**: [Decision maker title]
- **Geography**: [Target regions]
- **Tech Stack**: [Key technologies]

### Customer Segments
| Segment | Description | Priority |
|:--------|:-------------|:---------|
| Segment A | Description | P0 |
| Segment B | Description | P1 |

## Value Proposition
### Primary Value
[Core value delivered - the "why us" in one sentence]

### Value Ladder
| Level | Value | Proof |
|:------|:------|:------|
| Functional | [What it does] | [Feature/capability] |
| Economic | [ROI/benefit] | [Metric/outcome] |
| Emotional | [How it feels] | [User sentiment] |

## Differentiation Strategy
### Competitive Advantages
| Advantage | Description | Sustainability |
|:----------|:-------------|:---------------|
| Advantage 1 | What makes us different | [Moat: tech/scale/network] |
| Advantage 2 | What makes us different | [Moat] |

### Differentiation vs Competitors
| Competitor | Their Positioning | Our Differentiation |
|:-----------|:------------------|:--------------------|
| Competitor A | [Their positioning] | [How we're different] |
| Competitor B | [Their positioning] | [How we're different] |

## Key Messages
### Tagline
[Short, memorable phrase - 5-7 words]

### Elevator Pitch
[30-second pitch - 75 words]

### Messages by Audience
| Audience | Key Message | Supporting Points |
|:---------|:------------|:------------------|
| End Users | [Primary user benefit] | [3 supporting points] |
| Buyers | [Business value] | [3 supporting points] |
| Partners | [Partnership value] | [3 supporting points] |

## Proof Points
### Social Proof
- Customer logos/testimonials
- Case studies
- Ratings/reviews

### Technical Proof
- Performance metrics
- Security certifications
- Integration ecosystem

### Business Proof
- Growth metrics
- Retention rates
- ROI statistics
```

## Positioning Frameworks

### Triangle Positioning
Choose one point to lead, avoid trying to be all three:

```
      Cheaper
        /\
       /  \
      /    \
Better /      \ Faster
```

### Value Proposition Canvas

| Customer Profile | Value Proposition |
|:-----------------|:------------------|
| **Jobs-to-be-done** | **Products & Services** |
| What users are trying to accomplish | What we offer |
| **Pains** | **Pain Relievers** |
| Frustrations, obstacles | How we eliminate pain |
| **Gains** | **Gain Creators** |
| Desired outcomes | How we create value |

## Quality Standards

Before delivering, the positioning should:
- Be clear and specific (not "for everyone")
- Highlight true differentiation, not table stakes
- Be credible and defensible
- Resonate with target customer
- Guide product and marketing decisions
- Include proof points

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates complete positioning from research data |
| `copilot` | Drafts positioning, validates key points with you |
| `manual` | Provides positioning frameworks, you complete |

## Context Integration

**Reads:**
- `context/market-analysis.json` - Market trends and size
- `context/competitive-analysis.json` - Competitive landscape
- `context/user-research.json` - User needs and personas

**Writes:**
- `context/positioning.md` - Complete positioning document

**Read By:**
- `roadmap-planning` - Uses positioning for strategic alignment
- `prioritization` - References positioning for prioritization decisions
- `prd-gen` - Incorporates positioning into requirements

## Example Usage

```
User: "Define our positioning for the project management tool"
→ Generates complete positioning document

User: "How do we differentiate from Asana and Monday?"
→ Creates competitive positioning analysis

User: "What's our value proposition for small businesses?"
→ Develops segment-specific value proposition
```

## Best Practices

1. **Be specific** - "For developers" not "for everyone"
2. **Focus on one thing** - Lead with one clear differentiator
3. **Speak customer language** - Use their words, not yours
4. **Make it credible** - Back claims with proof
5. **Keep it simple** - Complex positioning fails in the market
