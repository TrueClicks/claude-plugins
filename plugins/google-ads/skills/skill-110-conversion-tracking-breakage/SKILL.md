---
name: skill-110-conversion-tracking-breakage
description: "Detect conversion tag firing drops below expected thresholds indicating tracking breakage."
allowed-tools: Read, Grep, Glob
---
# Skill 110: Conversion Tracking Breakage Detection

## Purpose
Detect when conversion tracking breaks or degrades. Even brief outages feed incorrect data to Smart Bidding, causing persistent optimization damage that takes weeks to recover.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Daily conversion trends

**Reference GAQL - Daily traffic vs conversions:**
```sql
SELECT
  segments.date,
  metrics.conversions,
  metrics.clicks
FROM campaign
WHERE segments.date DURING LAST_14_DAYS
```

**Reference GAQL - Conversions by action:**
```sql
SELECT
  segments.date,
  segments.conversion_action_name,
  metrics.conversions
FROM campaign
WHERE segments.date DURING LAST_14_DAYS
```
Use `/google-ads-get-custom` for detailed daily breakdown.

## Analysis Steps

1. **Establish Baselines:** Calculate daily/weekly conversion averages and standard deviation
2. **Identify Anomalies:** Find sudden drops (>50% day-over-day), zero-conversion periods
3. **Cross-Reference Traffic:** Compare clicks trend to conversions - stable clicks + dropped conversions = breakage
4. **Analyze by Conversion Action:** Identify which specific actions are affected

## Thresholds

| Condition | Severity |
|-----------|----------|
| Zero conversions for 24+ hours (with normal traffic) | Critical |
| Conversion drop >50% day-over-day | Critical |
| Conversion rate drops while traffic stable | Warning |
| Specific conversion action goes silent | Warning |

## Output

**Short (default):**
```
## Conversion Tracking Health Check
**Account:** [name] | **Baseline Conv/Day:** [X] | **Status:** [Healthy/Alert]

### Critical
- **Zero conversions on [date]** - Tracking likely broken
- **[X]% drop on [date]** - Investigate immediately

### Warnings
- **[conversion action] silent for [X] hours** - Check tag implementation

### Recommendations
1. Verify conversion tag in Google Tag Assistant
2. Check for recent website/GTM changes
3. Apply data exclusion for [date range] if breakage confirmed
```

**Detailed adds:**
- Daily conversion trend table with anomaly flags
- Conversion action health by action
- Recovery procedure checklist
- Smart Bidding recovery timeline estimates
