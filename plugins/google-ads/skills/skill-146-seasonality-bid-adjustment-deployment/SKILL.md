---
name: skill-146-seasonality-bid-adjustment-deployment
description: "Use Seasonality Adjustments for expected conversion rate changes during 1-7 day events."
allowed-tools: Read, Grep, Glob
---
# Skill 146: Seasonality Bid Adjustment Deployment

## Purpose
Audit upcoming events and historical performance to recommend Seasonality Adjustments for Smart Bidding. These adjustments tell the algorithm to expect conversion rate changes during short events (1-7 days) like flash sales, product launches, or holidays, allowing immediate bidding optimization.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export lacks seasonality adjustment configuration and prior-year event data for comparison.

**GAQL Query (Historical Event Performance):**
```sql
SELECT
  campaign.name,
  segments.date,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros,
  metrics.all_conversions
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date BETWEEN '[PRIOR_YEAR_EVENT_START]' AND '[PRIOR_YEAR_EVENT_END]'
```
Run via `/google-ads-get-custom` with appropriate date ranges for prior-year events.

**Additional Requirements:**
- Business promotional calendar with upcoming events
- Access to Google Ads bid strategy settings (for viewing current adjustments)

## Analysis Steps

1. **Map upcoming events:** Identify flash sales, holidays, product launches within next 60 days
2. **Pull historical data:** Query prior-year performance for each event period using custom GAQL
3. **Calculate conversion rate uplift:** Compare event periods vs. surrounding baseline periods
4. **Review existing adjustments:** Check for gaps in Tools > Bid Strategies > Seasonality Adjustments
5. **Validate adjustment parameters:** Verify duration (1-7 days), CR change estimate, device/campaign coverage

## Thresholds

| Condition | Severity |
|-----------|----------|
| Event within 14 days with no seasonality adjustment configured | Critical |
| Adjustment CR estimate differs from historical by >20 points | Warning |
| Adjustment duration >7 days | Warning |
| Adjustment applied to wrong campaigns or missing key campaigns | Warning |
| No historical data available for upcoming event | Info |

## Output

**Short format (default):**
```
## Seasonality Adjustment Audit
**Account:** [Name] | **Events (60d):** [X] | **Gaps:** [Y]

### Critical ([Count])
- **[Event]**: [Date range] - No adjustment configured -> Create +[X]% CR adjustment

### Warnings ([Count])
- **[Event]**: Estimate ([X]%) differs from historical ([Y]%) -> Revise to [Z]%

### Recommendations
1. [Priority action with specific dates and CR percentages]
```

**Detailed adds:**
- Historical event performance table (YoY comparison)
- Event-by-event configuration checklist
- Campaign coverage matrix for each adjustment
