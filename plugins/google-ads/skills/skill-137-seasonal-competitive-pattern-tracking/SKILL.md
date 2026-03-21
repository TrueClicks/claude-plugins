---
name: skill-137-seasonal-performance-pattern-tracking
description: "Analyze month-over-month performance patterns to identify seasonal trends, plan budgets, and set benchmarks."
allowed-tools: Read, Grep, Glob
---
# Skill 137: Seasonal Performance Pattern Tracking

## Purpose

Analyze your own seasonal performance patterns across 12+ months to identify recurring trends, plan budget allocation, and set realistic targets. Understanding when impressions, costs, and conversions naturally rise or fall prevents overreacting to expected fluctuations.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  campaign.name,
  segments.month,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.search_impression_share
FROM campaign
WHERE campaign.advertising_channel_type = 'SEARCH'
  AND segments.date BETWEEN '{start_date}' AND '{end_date}'
```
Run via `/google-ads:get-custom`. Use 12+ month date range for meaningful seasonal patterns.

## Analysis Steps

1. **Fetch historical data:** Run GAQL query covering 12+ months
2. **Build monthly profiles:** Aggregate metrics by month to identify peaks and valleys
3. **Identify seasonal patterns:** Holiday ramps, summer dips, Q1 resets, etc.
4. **Assess impression share trends:** Months where IS drops may indicate increased competition
5. **Plan budget allocation:** Recommend shifting budget toward high-performing months

## Thresholds

| Condition | Severity |
|-----------|----------|
| Conversion rate drops >30% in specific months repeatedly | Warning |
| Impression share drops >15% during peak months | Warning |
| Budget flat despite clear seasonal performance swings | Warning |
| CPA increases >25% in specific months year-over-year | Info |

## Output

**Short format (default):**
```
## Seasonal Performance Audit

**Account:** [Name] | **Period:** [start] to [end] | **Campaigns:** [X]

### Monthly Performance Summary
| Month | Impressions | Clicks | Cost | Conv | IS | Trend |
|-------|-------------|--------|------|------|----|-------|
| Jan   | [X] | [X] | $[X] | [X] | [X]% | Low season |
| ...   | ... | ... | ... | ... | ... | ... |

### Seasonal Patterns Identified
- **Peak months:** [months] — Conversions +[X]% above average
- **Low months:** [months] — Conversions -[X]% below average
- **IS dips:** [months] — Competition increases

### Recommendations
1. Increase budget [X]% for [peak months] to capture additional volume
2. Reduce budget [X]% during [low months] to improve efficiency
3. Apply seasonality bid adjustments for [months] with predictable swings
```

**Detailed adds:**
- Campaign-level monthly breakdown
- Year-over-year comparison if 24+ months available
- Budget reallocation calendar
- Seasonality adjustment recommendations by month
