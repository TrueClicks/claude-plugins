---
name: skill-123-budget-pacing-daily-allocation-scripts
description: "Analyze day-of-week performance to recommend daily budget allocation and monthly pacing strategies."
allowed-tools: Read, Grep, Glob
---
# Skill 123: Budget Pacing and Daily Allocation

## Purpose

Analyze day-of-week performance patterns to optimize daily budget allocation and ensure proper monthly budget pacing. This helps capture more conversions on high-efficiency days while avoiding under/overspend.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include day-of-week segmented data.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.id,
  segments.day_of_week,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE segments.date BETWEEN '{start_date}' AND '{end_date}'
  AND campaign.status = 'ENABLED'
ORDER BY campaign.name, segments.day_of_week
```
Run via `/google-ads:get-custom` with query name `day_of_week_performance`.

## Analysis Steps

1. **Fetch day-of-week data:** Run custom GAQL query for 90 days of segmented data
2. **Calculate efficiency indices:** Compare CPA/ROAS by day vs weekly average
3. **Identify patterns:** Flag high-efficiency days (low CPA) and low-efficiency days (high CPA)
4. **Design allocation strategy:** Create day-based budget multipliers
5. **Check monthly pacing:** Compare spend-to-date vs budget-to-date

## Thresholds

| Condition | Severity |
|-----------|----------|
| Day CPA > 50% above average | Critical |
| Monthly underpacing > 20% | Warning |
| Monthly overpacing > 10% | Warning |
| Day efficiency variance > 30% | Info |

## Output

**Short format (default):**
```
## Budget Pacing Audit

**Account:** [Name] | **Monthly Budget:** $[X] | **Pacing:** [On Track/Under/Over]

### Day-of-Week Efficiency
| Day | CPA | Efficiency | Recommended Multiplier |
|-----|-----|------------|----------------------|
| Monday | $[X] | +20% | 1.2x |
| Saturday | $[X] | -30% | 0.7x |

### Pacing Status
- Days remaining: [X]
- Budget remaining: $[X]
- Required daily: $[X] (current avg: $[Y])

### Recommendations
1. Increase [Day] budget by [X]% (best efficiency)
2. Reduce [Day] budget by [X]% (lowest efficiency)
```

**Detailed adds:**
- Full day-of-week performance table by campaign
- Monthly pacing week-by-week breakdown
- Script configuration for automated adjustments
- Seasonal pattern observations
