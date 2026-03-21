---
name: skill-124-performance-anomaly-alert-configuration
description: "Identify performance anomalies and recommend automated alert configurations for key metric deviations."
allowed-tools: Read, Grep, Glob
---
# Skill 124: Performance Anomaly Alert Configuration

## Purpose

Establish baseline metrics and detect significant deviations that indicate problems requiring immediate attention. Configure alert thresholds to catch issues like conversion drops, impression losses, or cost spikes before they cause major damage.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Campaign performance
- `data/performance/campaigns/*/*/ad_group_metrics_30_days.md` - Ad group performance
- `data/account/campaigns/*/campaign.md` - Budget settings

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.ctr,
  metrics.average_cpc
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.status = 'ENABLED'
```
Use `/google-ads:get-custom` for period comparisons or daily granularity.

## Analysis Steps

1. **Calculate baselines:** Compute 30-day averages and standard deviations for key metrics
2. **Define normal ranges:** Set upper/lower bounds at mean +/- 2 standard deviations
3. **Detect current anomalies:** Compare recent performance against baselines
4. **Categorize by severity:** Critical (immediate action) vs Warning (monitor)
5. **Generate alert rules:** Provide specific configurations for automated monitoring

## Thresholds

| Condition | Severity |
|-----------|----------|
| Impressions -50% day-over-day | Critical |
| Conversions -80% week-over-week | Critical |
| CPA +100% vs target | Critical |
| CTR -50% day-over-day | Critical |
| Impressions -25% week-over-week | Warning |
| Conversions -30% week-over-week | Warning |

## Output

**Short format (default):**
```
## Anomaly Alert Audit

**Account:** [Name] | **Period:** Last 30 days | **Anomalies:** [X]

### Critical Alerts ([Count])
- **[Campaign]**: Impressions -[X]% vs baseline → Investigate immediately
- **[Campaign]**: Conversions dropped [X]% → Check tracking

### Warnings ([Count])
- **[Campaign]**: CTR declining [X]% week-over-week → Monitor ad fatigue

### Recommended Alert Configuration
| Metric | Threshold | Frequency |
|--------|-----------|-----------|
| Impression drop | -50% DoD | Daily |
| Conversion drop | -30% WoW | Daily |
| CPA spike | +100% vs target | Daily |
```

**Detailed adds:**
- Baseline metrics table with normal ranges
- Full anomaly detection results
- Alert rule specifications for Google Ads
- False positive mitigation strategies
