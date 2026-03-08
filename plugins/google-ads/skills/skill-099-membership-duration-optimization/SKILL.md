---
name: skill-099-membership-duration-optimization
description: "Optimize audience membership durations (7-365 days) aligned to the business's buying cycle."
allowed-tools: Read, Grep, Glob
---
# Skill 099: Membership Duration Optimization

## Purpose
Optimize audience membership durations aligned to the business's buying cycle. Shorter windows capture urgency; longer windows re-engage users for high-consideration purchases.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Audience configurations
- `data/account/campaigns/*/*/audience_targeting.md` - Ad group audiences

**Reference GAQL:**
```sql
SELECT
  user_list.name,
  user_list.membership_life_span,
  user_list.size_for_display,
  user_list.size_for_search
FROM user_list
WHERE user_list.membership_status = 'OPEN'
```
Use `/google-ads-get-custom` for conversion lag analysis:
```sql
SELECT
  segments.conversion_lag_bucket,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE segments.date BETWEEN '{start_date}' AND '{end_date}'
  AND campaign.advertising_channel_type = 'DISPLAY'
```

## Analysis Steps

1. **Determine Business Buying Cycle:** Quick (7-30 days), Medium (30-90 days), Long (90-365 days)
2. **Review Current Durations:** Extract membership durations from audience configurations
3. **Map Durations to Funnel Stage:** High-intent = shorter, low-intent = longer
4. **Identify Mismatches:** Cart abandoners >30 days, B2B audiences <60 days

## Thresholds

| Condition | Severity |
|-----------|----------|
| Cart abandoner duration >30 days | Warning |
| B2B audiences <60 days | Warning |
| All durations identical (no optimization) | Info |
| Exclusion list shorter than buying cycle | Warning |
| High-intent segment >90 days | Warning |

## Output

**Short (default):**
```
## Membership Duration Audit
**Account:** [name] | **Business Type:** [type] | **Est. Buying Cycle:** [X days] | **Issues:** [count]

### Warnings
- **Cart abandoners at 60 days** - Reduce to 7-14 days for urgency
- **All audiences at 30 days** - No duration optimization applied

### Recommendations
1. Set cart abandoners to 7-14 days
2. Set product viewers to 30-60 days
3. Extend purchaser exclusion to [X days] to match buying cycle
```

**Detailed adds:**
- Duration audit table by audience
- Recommended durations by industry vertical
- Conversion lag analysis if available
- Duration testing strategy
