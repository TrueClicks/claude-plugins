---
name: skill-118-click-fraud-invalid-traffic-monitoring
description: "Monitor for suspicious click patterns and implement IP exclusions to protect against click fraud."
allowed-tools: Read, Grep, Glob
---
# Skill 118: Click Fraud and Invalid Traffic Monitoring

## Purpose
Monitor for suspicious click patterns indicating click fraud or invalid traffic. Early detection prevents budget waste and protects Smart Bidding from learning on fraudulent data.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query - Click Analysis:**
```sql
SELECT
  campaign.name,
  segments.date,
  metrics.clicks,
  metrics.impressions,
  metrics.cost_micros,
  metrics.conversions,
  metrics.invalid_clicks,
  metrics.invalid_click_rate
FROM campaign
WHERE segments.date DURING LAST_14_DAYS
  AND campaign.status = 'ENABLED'
```

**GAQL Query - Geographic Analysis:**
```sql
SELECT
  campaign.name,
  geographic_view.country_criterion_id,
  metrics.clicks,
  metrics.impressions,
  metrics.cost_micros,
  metrics.conversions
FROM geographic_view
WHERE segments.date DURING LAST_30_DAYS
```
Run via `/google-ads-get-custom` with query name `fraud_detection`.

## Analysis Steps

1. **Check Invalid Click Metrics:** Review Google's invalid click data and refunds
2. **Identify CTR Anomalies:** Flag campaigns/periods with CTR >5-10%
3. **Analyze Click Patterns:** Look for click bursts, unusual geographic concentration
4. **Cross-Reference Conversions:** High clicks with zero conversions = suspicious

## Thresholds

| Condition | Severity |
|-----------|----------|
| Invalid click rate >5% | Critical |
| CTR >10% on Search, >2% on Display | Warning |
| Click burst (>2 std dev above average) | Warning |
| High clicks from non-target geographies | Warning |

## Output

**Short (default):**
```
## Click Fraud Analysis
**Account:** [name] | **Period:** Last 14 days | **Invalid Click Rate:** [%]

### Summary
- **Total Clicks:** [count]
- **Invalid Clicks:** [count] ([%])
- **Google Refunds:** $[amount]

### Suspicious Activity
- **[campaign]**: CTR [%] - Abnormally high
- **[date] [hour]**: [count] clicks in 1 hour - Possible click burst
- **Clicks from [location]**: [count] - Not in target geography

### Recommendations
1. Request manual review from Google for [campaign]
2. Add geographic exclusions for [locations]
3. Consider third-party click fraud protection
```

**Detailed adds:**
- Invalid click summary by campaign
- CTR anomaly table with dates/hours
- Geographic click distribution analysis
- IP exclusion and monitoring setup guide
