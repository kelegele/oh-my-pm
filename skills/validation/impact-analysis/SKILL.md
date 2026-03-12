---
name: impact-analysis
description: Analyze post-release impact and measure success against goals. Use this skill when the user needs to evaluate launch results, measure feature success, analyze post-release metrics, or says "how did it perform", "measure impact", "post-launch analysis". Even if they don't explicitly say "impact analysis", activate when they're evaluating the results of a release or feature.
layer: validation
input-from: release-management,data-monitoring
output-to: iteration-planning,feedback-synthesis
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Impact Analysis

Measure what matters after launch.

## What This Skill Does

Analyzes post-release data to determine if features achieved their goals, measures business impact, and identifies learnings for future iterations. Connects release outcomes to the metrics that matter.

## When to Use

Activate this skill when:
- User needs to evaluate launch or feature performance
- Phrases like "how did it perform", "measure impact", "post-launch analysis"
- Reviewing success against PRD goals
- Preparing post-release retrospective
- User says "what were the results" or "did it work"

## How It Works

The analysis process ensures comprehensive impact measurement:

1. **Define measurement period** - Determine appropriate analysis window
2. **Collect metrics** - Gather data from monitoring systems
3. **Compare to baseline** - Measure change from pre-release state
4. **Evaluate goals** - Check if success criteria were met
5. **Identify insights** - Find patterns, surprises, learnings
6. **Generate recommendations** - Propose next steps

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `release_ref` | string | Yes | Reference to release being analyzed |
| `prd_ref` | string | Yes | Reference to PRD with success metrics |
| `period` | string | No | Analysis period (default: "7 days post-launch") |

## Output Structure

The skill generates analysis outputs:

1. **Impact report** - Comprehensive analysis with findings
2. **Scorecard** - Summary of how goals performed
3. **Recommendations** - Actions based on findings

### Impact Report Format

```markdown
# Impact Analysis: [Feature/Release Name]

## Overview
- **Release Version**: [Version]
- **Launch Date**: [Date]
- **Analysis Period**: [Start] - [End] (X days post-launch)
- **Analysis Date**: [Date]
- **Status**: 🟢 Success / 🟡 Mixed / 🔴 Below Expectations

## Executive Summary
[2-3 sentence summary of overall performance]

## Goal Achievement

### Success Metrics from PRD

| Metric | Target | Actual | Achievement | Status |
|:-------|:-------|:-------|:------------|:--------|
| Activation Rate | 40% | 52% | +12 pts | ✅ Exceeded |
| Retention (Day 7) | 60% | 58% | -2 pts | ⚠️ Slightly Below |
| NPS Score | +20 | +25 | +5 pts | ✅ Exceeded |
| Revenue Impact | $10K/mo | $8K/mo | -20% | ⚠️ Below |

**Overall**: 3 of 4 primary goals achieved

## Metric Analysis

### Core Metrics

| Metric | Before | After | Change | Significance |
|:-------|:------|:------|:-------|:-------------|
| Daily Active Users | 1,000 | 1,200 | +20% | ✅ Significant |
| Feature Adoption | - | 35% | - | New metric |
| Session Length | 8.5 min | 9.2 min | +8% | ✅ Positive |
| Error Rate | 0.8% | 0.5% | -37.5% | ✅ Improved |
| Support Tickets | 50/day | 55/day | +10% | ⚠️ Slight increase |

### Conversion Funnel

| Step | Before | After | Change |
|:-----|:-------|:------|:-------|
| View | 10,000 | 12,000 | +20% |
| Click | 2,000 (20%) | 3,000 (25%) | +5 pts |
| Sign up | 400 (20%) | 900 (30%) | +10 pts |
| Activate | 200 (50%) | 468 (52%) | +2 pts |

**Key Insight**: Feature improved sign-up-to-activate conversion by 2 percentage points.

### User Segments

| Segment | Adoption | Satisfaction | Retention |
|:--------|:--------|:-------------|:----------|
| New Users | 45% | 4.5/5 | 62% |
| Power Users | 28% | 4.2/5 | 75% |
| Enterprise | 52% | 4.7/5 | 80% |

**Key Insight**: Enterprise segment shows highest adoption and satisfaction.

## Qualitative Feedback

### Positive Themes
1. **Ease of Use**: "Finally, this is so much easier"
2. **Time Savings**: "Cut my workflow time in half"
3. **Value**: "Worth the wait, very useful"

### Negative Themes
1. **Discovery**: "Couldn't find it at first"
2. **Learning Curve**: "Took me a while to understand"
3. **Missing Feature**: "Wish it could also do X"

### Representative Quotes
> "This feature alone makes the subscription worth it"
> — Enterprise customer, 2 weeks post-launch

> "I didn't even know this existed until support told me"
> — New user, 1 week post-launch

## Technical Performance

| Metric | Target | Actual | Status |
|:-------|:-------|:-------|:--------|
| Uptime | 99.9% | 99.95% | ✅ |
| Response Time (p95) | < 500ms | 380ms | ✅ |
| Error Rate | < 1% | 0.5% | ✅ |
| API Load | Normal | +15% | ⚠️ Monitor |

## Surprises & Anomalies

| Finding | Description | Impact |
|:--------|:-------------|:--------|
| Unexpected use case | Users using for [unexpected purpose] | Consider supporting |
| Geographic difference | EMEA adoption 2x higher | Investigate why |
| Device preference | Mobile adoption 3x desktop | Optimize mobile UX |

## Recommendations

### Immediate Actions (This Week)
1. **Improve discovery**: Add in-app tutorial/tooltip
2. **Address feedback**: Top 3 user-requested enhancements
3. **Monitor API**: Increased load requires capacity planning

### Short-term (This Month)
1. **Expand documentation**: Help users understand full capabilities
2. **A/B test discovery**: Test different onboarding approaches
3. **Analyze enterprise success**: Understand and replicate

### Long-term (This Quarter)
1. **Consider missing feature**: Evaluate top user request
2. **Optimize for mobile**: Mobile users show high engagement
3. **International expansion**: EMEA shows strong potential

## Learnings for Next Release

### What Went Well
- ✅ Performance targets met or exceeded
- ✅ User satisfaction high
- ✅ Low bug rate

### What Could Be Improved
- ⚠️ Feature discovery needs work
- ⚠️ Onboarding could be clearer
- ⚠️ Some edge cases not covered

### What We'd Change
- → Start with smaller beta to test discovery
- → Invest more in onboarding UX
- → Include power users in testing earlier

## Conclusion

[Summary paragraph - overall assessment and next steps]

---
**Prepared by**: [Name]
**Reviewed by**: [Name]
**Next review**: [Date]
```

## Analysis Frameworks

### Goal-Based Analysis
Compare actuals to targets defined in PRD:
| Goal Type | Example | Success Criteria |
|:---|:---|:---|
| Acquisition | New signups | Did we acquire target users? |
| Engagement | DAU, session length | Are users engaging more? |
| Retention | Day-7, Day-30 | Are users staying? |
| Revenue | ARPU, MRR | Did we drive business value? |
| Satisfaction | NPS, CSAT | Are users happy? |

### Cohort Analysis
Track performance by user cohort:
| Cohort | Definition | Key Metric |
|:---|:---|:---|
| Acquired Pre | Users before launch | Baseline comparison |
| Acquired Post | Users after launch | Feature impact |
| Early Adopters | First week adopters | Engagement patterns |
| Late Adopters | Later adopters | Barriers to adoption |

## Quality Standards

Before delivering, ensure analysis:
- Uses actual data, not guesses
- Compares to appropriate baseline
- Identifies both positive and negative findings
- Provides actionable recommendations
- Connects to original PRD goals
- Includes qualitative feedback

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Gathers metrics, generates full analysis |
| `copilot` | Drafts analysis, validates insights with you |
| `manual` | Provides templates, you complete analysis |

## Context Integration

**Reads:**
- `context/prd/*.md` - Success metrics and goals
- `context/metrics.json` - Pre and post-release data
- `context/release-plan.md` - Release scope and timeline

**Writes:**
- `context/impact-analysis.json` - Structured analysis data
- `context/impact-reports/[release]-[date].md` - Full report

**Read By:**
- `iteration-planning` - Uses impact data for planning
- `feedback-synthesis` - Combines with user feedback

## Example Usage

```
User: "How did the onboarding feature perform?"
→ Analyzes metrics, generates impact report

User: "Did we hit our goals for v2.5?"
→ Compares actuals to targets, summarizes achievement

User: "What's the post-launch analysis?"
→ Generates comprehensive impact report with recommendations
```

## Best Practices

1. **Wait for data** - Don't analyze too early (7 days minimum)
2. **Compare to baseline** - Relative change matters more than absolute
3. **Look beyond averages** - Segment by user type, geography, etc.
4. **Combine quantitative and qualitative** - Metrics + feedback = insights
5. **Focus on actionable** - Every finding should suggest a next step
