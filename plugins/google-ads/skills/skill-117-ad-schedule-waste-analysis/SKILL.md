---
name: skill-117-ad-schedule-waste-analysis
description: "Identify time periods (hours and days) with high spend but low or zero conversions to optimize ad scheduling."
allowed-tools: Read, Grep, Glob
---
# Skill 117: Ad Schedule Waste Analysis

## Purpose
Identify time periods with high spend but low or zero conversions to optimize ad scheduling. Time-based optimization can reduce waste by 10-20% while maintaining conversion volume.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  campaign.name,
  segments.hour,
  segments.day_of_week,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 0
ORDER BY campaign.name, segments.day_of_week, segments.hour
```
Run via `/google-ads:get-custom` with query name `ad_schedule_analysis`.

## Analysis Steps

1. **Pull Hourly Performance:** Get performance by hour and day of week
2. **Analyze Day-of-Week Patterns:** Identify high-CPA days, zero-conversion days
3. **Analyze Hour-of-Day Patterns:** Find zero-conversion hours, off-hours waste
4. **Create Performance Heatmap:** Identify worst day/hour combinations

## Thresholds

| Condition | Severity |
|-----------|----------|
| Day with zero conversions and >$100 spend | Critical |
| Hours with zero conversions (multiple days) | Warning |
| Weekend CPA >2x weekday CPA | Warning |
| Off-hours (12am-6am) spend >10% of budget | Info |

## Output

**Short (default):**
```
## Ad Schedule Waste Analysis
**Account:** [name] | **Period:** Last 30 days | **Account CPA:** $[amount]

### Day-of-Week Performance
| Day | Spend | Conv | CPA | vs. Avg |
|-----|-------|------|-----|---------|
| [worst day] | $[amount] | [count] | $[amount] | +[%] |

### Zero-Conversion Periods
- **[day] [hours]**: $[amount] spent, 0 conversions
- **Off-hours (12am-6am)**: $[amount] spent, [count] conversions

### Recommendations
1. Exclude [time periods] - Save $[amount]/month
2. Reduce bids -50% on [days/hours] with high CPA
3. Increase bids +20% on [best performing periods]
```

**Detailed adds:**
- Full day-of-week performance table
- Hour-of-day performance table
- Performance heatmap (day x hour)
- Bid adjustment schedule recommendations
