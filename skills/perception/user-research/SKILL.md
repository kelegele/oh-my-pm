---
name: user-research
description: Conduct user research including interviews, surveys, and persona creation. Use this skill when the user needs to understand user needs, create personas, analyze user feedback, conduct user interviews, or says "talk to users", "what do users want", "user research". Even if they don't explicitly say "user research", activate when they're trying to understand user behavior, needs, or pain points.
layer: perception
input-from: market-intelligence
output-to: product-positioning,prd-gen,prioritization
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# User Research

Understand users to build products they love.

## What This Skill Does

Conducts user research through various methods including interviews, surveys, persona creation, and user behavior analysis. The output provides deep user insights that drive product decisions and feature prioritization.

## When to Use

Activate this skill when:
- User asks about understanding user needs or behaviors
- Phrases like "user research", "talk to users", "what do users want"
- Creating or updating user personas
- Analyzing user feedback or interview data
- Need to validate product ideas with real users
- User says "who is our target user" or "create personas"

## How It Works

The research process ensures comprehensive user understanding:

1. **Define research goals** - Identify what you need to learn
2. **Select methods** - Choose appropriate research methods
3. **Create instruments** - Design interview guides, surveys
4. **Gather data** - Conduct research sessions
5. **Analyze findings** - Identify patterns and insights
6. **Create artifacts** - Generate personas, journey maps, insights

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `research_goal` | string | Yes | What you want to learn about users |
| `target_segment` | string | No | Specific user segment to study |
| `method` | string | No | `interviews`, `surveys`, `personas`, `all` (default) |
| `sample_size` | number | No | Target number of participants |

## Research Methods

| Method | When to Use | Output |
|:---|:---|:---|
| `interviews` | Deep understanding of needs | Interview transcripts, key quotes |
| `surveys` | Broad pattern validation | Survey results, statistical insights |
| `personas` | User archetype creation | Persona profiles |
| `journey-mapping` | Experience optimization | User journey maps |

## Output Structure

The skill generates two outputs:

1. **JSON file** (`context/user-research.json`) - Structured research data
2. **Markdown report** - Human-readable research summary

### JSON Output Format

```json
{
  "research": {
    "id": "uuid",
    "timestamp": "2026-03-12T...",
    "goal": "Understand onboarding pain points",
    "method": "interviews",
    "participants": 8,
    "personas": [
      {
        "name": "Product Manager Alice",
        "role": "PM at B2B SaaS",
        "goals": ["Ship features faster", "Align team"],
        "pain_points": ["Too many tools", "Unclear priorities"],
        "behaviors": ["Checks Jira first thing", "Prefers async comms"]
      }
    ],
    "key_insights": [
      "Users spend 40% of time context-switching between tools",
      "Onboarding drop-off occurs at step 3 (team invitation)"
    ],
    "quotes": [
      {"user": "PM Alice", "quote": "I just wish everything was in one place"},
      {"user": "Eng Bob", "quote": "Setting up a new project takes too long"}
    ],
    "recommendations": [
      "Add integrations with popular tools",
      "Simplify onboarding flow"
    ]
  },
  "last_updated": "2026-03-12T..."
}
```

### Markdown Report Structure

```markdown
# User Research Report

## Research Overview
- **Goal**: Understand onboarding pain points
- **Method**: User Interviews
- **Participants**: 8 users
- **Date**: YYYY-MM-DD

## User Personas

### Product Manager Alice
**Role**: PM at B2B SaaS company (50-200 employees)

**Goals**:
- Ship features faster without breaking things
- Keep team aligned on priorities
- Get visibility into what engineering is working on

**Pain Points**:
- Too many tools to check (Jira, Slack, GitHub, Notion)
- Unclear priorities lead to context-switching
- Hard to track progress without micromanaging

**Behaviors**:
- Checks Jira first thing every morning
- Prefers async communication over meetings
- Creates detailed specs but engineers don't read them

**Quote**: *"I just wish everything was in one place instead of checking 5 different apps."*

### Engineer Bob
**Role**: Senior developer at startup

**Goals**:
- Focus on coding, not process overhead
- Understand what to work on next
- Get unblocked quickly when stuck

**Pain Points**:
- Requirement ambiguity leads to rework
- Waiting for PM clarification blocks progress
- Too many meetings interrupt flow

**Quote**: *"By the time I get clarification, I've lost my flow state."*

## Key Insights

### Insight 1: Context-Switching Friction
**Finding**: Users spend 40% of time switching between tools
**Evidence**: 6/8 participants mentioned this as top frustration
**Opportunity**: Unified workspace could save hours daily

### Insight 2: Onboarding Drop-off
**Finding**: Users abandon setup at team invitation step
**Evidence**: 50% of interviews cited setup complexity
**Opportunity**: Simplify or defer team setup

### Insight 3: Async Preference
**Finding**: Knowledge workers prefer async updates
**Evidence**: 7/8 prefer written over meetings
**Opportunity**: Build async status updates

## Recommendations

1. **Short-term**: Add status page showing all work in one view
2. **Medium-term**: Build integrations with Jira, GitHub, Slack
3. **Long-term**: Create AI-powered priority recommendations

## Next Steps
- [ ] Validate persona hypotheses with more users
- [ ] Run A/B test on simplified onboarding
- [ ] Prototype unified status view
```

## Persona Template

```markdown
### [Name]
**Role**: [Job title] at [Company type]

**Goals**:
- [Primary goal]
- [Secondary goal]

**Pain Points**:
- [Key frustration 1]
- [Key frustration 2]

**Behaviors**:
- [Observable behavior 1]
- [Observable behavior 2]

**Quote**: *"[Direct user quote]"*

**Demographics**:
- Company size: [X-Y employees]
- Tech stack: [Key tools]
- Experience level: [Years]
```

## Interview Guide Template

```markdown
## Interview Questions

### Warm-up
1. Tell me about your role
2. What does a typical day look like?

### Discovery
3. How do you currently [solve problem X]?
4. What tools do you use?
5. What works well? What doesn't?

### Deep Dive
6. Walk me through the last time you [encountered problem]
7. What was frustrating about that?
8. What did you try instead?

### Closing
9. If you could change one thing, what would it be?
10. Is there anything else I should know?
```

## Quality Standards

Before delivering, the research should:
- Include 3+ personas (if applicable)
- Provide 5+ key insights
- Include direct user quotes
- Link insights to actionable recommendations
- Be valid JSON for downstream skills

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Generates personas and insights from provided data |
| `copilot` | Drafts personas, waits for your validation |
| `manual` | Provides research templates, you conduct analysis |

## Context Integration

**Reads:**
- `context/market-analysis.json` - Market context for user segments

**Writes:**
- `context/user-research.json` - Research results for other skills

**Read By:**
- `product-positioning` - Uses personas for positioning strategy
- `prd-gen` - References user needs in requirements
- `prioritization` - Uses insights for feature prioritization

## Example Usage

```
User: "Create personas for our product"
→ Activates user-research with method=personas

User: "What are our users' biggest pain points?"
→ Activates user-research with research_goal="identify pain points"

User: "Analyze these user interviews"
→ Activates user-research to analyze provided interview data
```
