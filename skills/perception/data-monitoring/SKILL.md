---
name: data-monitoring
description: 监控产品指标、检测异常并跟踪 KPI。当用户需要设置监控、跟踪产品指标、分析数据趋势、创建仪表板、检测异常，或说"跟踪 X 指标"、"Y 表现如何"、"设置监控"时使用。即使没有明确说"数据监控"，当用户正在处理指标、分析或性能跟踪时也应激活。
layer: perception
input-from: prd-gen
output-to: impact-analysis,iteration-planning
mode-support: [autopilot, copilot, manual]
version: 0.1.0
---

# Data Monitoring

Track metrics that matter for product success.

## What This Skill Does

Sets up and monitors product metrics including core KPIs, user behavior metrics, and business indicators. Detects anomalies, tracks trends, and generates alerts. The output provides the data foundation for impact analysis and iteration planning.

## When to Use

Activate this skill when:
- User wants to track product metrics or KPIs
- Phrases like "monitor X", "track Y metric", "how is it performing"
- Setting up dashboards or alerting
- Analyzing trends or detecting anomalies
- User says "set up monitoring" or "create dashboard"

## How It Works

The monitoring process ensures comprehensive metric tracking:

1. **Define metrics** - Identify what to measure based on product goals
2. **Set up tracking** - Configure data collection and storage
3. **Establish baselines** - Determine normal ranges and thresholds
4. **Configure alerts** - Set up anomaly detection and notifications
5. **Monitor trends** - Track changes over time
6. **Generate insights** - Identify patterns and issues

## Input Parameters

| Parameter | Type | Required | Description |
|:---|:---|:---|:---|
| `metric_type` | string | Yes | Type of metric (e.g., "engagement", "revenue", "technical") |
| `kpi_name` | string | Yes | Specific KPI to monitor |
| `threshold` | object | No | Alert thresholds (e.g., `{"min": 100, "max": 1000}`) |
| `frequency` | string | No | Check frequency (default: "daily") |

## Metric Categories

| Category | Example Metrics | Use For |
|:---|:---|:---|
| `engagement` | DAU, WAU, MAU, session length | User engagement |
| `acquisition` | Signups, conversion rate, CAC | Growth tracking |
| `retention` | Day-7, Day-30, churn rate | User retention |
| `revenue` | MRR, ARPU, LTV | Business health |
| `technical` | Error rate, latency, uptime | System health |
| `feature` | Feature adoption, usage frequency | Feature success |

## Output Structure

The skill generates monitoring outputs:

1. **Alert notifications** - Real-time alerts when thresholds breached
2. **Trend reports** - Regular summaries of metric performance
3. **Dashboard specifications** - Dashboard configuration recommendations

### Alert Format

```json
{
  "alert": {
    "id": "alert-uuid",
    "timestamp": "2026-03-12T10:30:00Z",
    "severity": "warning",
    "metric": "daily_active_users",
    "current_value": 850,
    "threshold": {"min": 1000},
    "change": "-15%",
    "message": "DAU dropped below threshold",
    "suggested_actions": [
      "Check if deployment caused issues",
      "Review recent feature changes",
      "Analyze user feedback channels"
    ]
  }
}
```

### Trend Report Format

```json
{
  "report": {
    "period": "2026-03-06 to 2026-03-12",
    "metrics": [
      {
        "name": "daily_active_users",
        "current": 1050,
        "previous": 1000,
        "change": "+5%",
        "trend": "up",
        "status": "healthy"
      },
      {
        "name": "conversion_rate",
        "current": "3.2%",
        "previous": "3.5%",
        "change": "-8.6%",
        "trend": "down",
        "status": "warning"
      }
    ],
    "anomalies": [
      {
        "metric": "conversion_rate",
        "detected_at": "2026-03-10",
        "description": "Unusual drop after deployment"
      }
    ],
    "recommendations": [
      "Investigate conversion rate drop",
      "Consider A/B testing checkout flow"
    ]
  }
}
```

## Anomaly Detection

| Type | Description | Detection Method |
|:---|:---|:---|
| **Spike** | Sudden increase | Value > 3σ from mean |
| **Drop** | Sudden decrease | Value < 3σ from mean |
| **Trend** | Gradual change | Linear regression slope |
| **Pattern** | Repeating pattern | Time series analysis |

## Quality Standards

Before delivering, the monitoring setup should:
- Define clear metrics with business relevance
- Set appropriate thresholds based on historical data
- Include actionable alert messages
- Provide context for metric interpretation
- Specify data sources and collection methods

## Collaboration Modes

| Mode | How It Works |
|:---|:---|
| `autopilot` | Sets up monitoring with recommended thresholds |
| `copilot` | Proposes metrics and thresholds, confirms with you |
| `manual` | Provides monitoring templates, you configure |

## Context Integration

**Reads:**
- `context/prd/*.md` - Success metrics defined in PRDs

**Writes:**
- `context/metrics.json` - Current metric values and trends

**Read By:**
- `impact-analysis` - Uses metric data for post-release analysis
- `iteration-planning` - References trends for planning decisions

## Example Usage

```
User: "Monitor our daily active users"
→ Sets up DAU monitoring with alerts

User: "Create a dashboard for key metrics"
→ Generates dashboard specification with core KPIs

User: "Why did conversion rate drop yesterday?"
→ Analyzes anomaly, provides root cause suggestions
```
