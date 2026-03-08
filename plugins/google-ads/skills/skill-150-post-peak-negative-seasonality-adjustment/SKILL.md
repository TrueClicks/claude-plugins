---
name: skill-150-post-peak-negative-seasonality-adjustment
description: "Apply negative seasonality adjustments after events when conversion rates drop."
allowed-tools: Read, Grep, Glob
---
# Skill 150: Post-Peak Negative Seasonality Adjustment

## Purpose
Audit recently completed events and recommend negative seasonality adjustments to prevent Smart Bidding from overspending during post-event conversion rate drops. After promotional peaks, algorithms continue bidding based on elevated historical performance, leading to overpayment for traffic that is now less likely to convert.

## Data Requirements

**Data Source:** Custom GAQL Required

Need to compare event period vs. post-event period performance, which requires specific date range queries.

**GAQL Query (Post-Event Performance):**
```sql
SELECT
  campaign.name,
  segments.date,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros,
  metrics.average_cpc
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date BETWEEN '[EVENT_END_DATE]' AND '[POST_EVENT_END]'
```
Run via `/google-ads-get-custom` with event period and post-event period queries for comparison.

**Additional Requirements:**
- Knowledge of recently completed events (within past 30 days)
- Access to bid strategy seasonality adjustment settings

## Analysis Steps

1. **Identify recently completed events:** Review calendar for events ended within past 30 days
2. **Compare performance periods:** Query event period vs. post-event period conversion rates
3. **Calculate CR decline:** Measure conversion rate drop percentage post-event
4. **Check negative adjustments:** Verify adjustments are configured for significant declines
5. **Monitor CPC trends:** Identify elevated CPCs indicating algorithmic overbidding

## Thresholds

| Condition | Severity |
|-----------|----------|
| Post-event CR drop >30% with no negative adjustment | Critical |
| CPCs elevated >15% post-event while CR declined | Critical |
| Negative adjustment weaker than actual CR decline | Warning |
| Adjustment duration too short for recovery period | Warning |
| Minor event (<15% CR change) without adjustment | Info |

## Output

**Short format (default):**
```
## Post-Peak Adjustment Audit
**Account:** [Name] | **Recent events:** [X] | **Adjustment gaps:** [Y]

### Critical ([Count])
- **Post-[Event]**: CR dropped [X]%, no adjustment -> Create -[Y]% adjustment for [dates]

### Warnings ([Count])
- **[Event]**: Adjustment -[X]% but actual drop -[Y]% -> Increase to -[Z]%

### Recommendations
1. [Specific negative adjustment with percentage, dates, and campaigns]
```

**Detailed adds:**
- Event vs. post-event performance comparison table
- CPC trend analysis showing algorithmic overbidding
- Playbook template for future post-event adjustments
