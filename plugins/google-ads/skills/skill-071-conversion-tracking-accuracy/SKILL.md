---
name: skill-071-conversion-tracking-accuracy
description: "Cross-reference Google Ads conversion data with actual business data (CRM, e-commerce platform, order system) to verify tracking accuracy."
allowed-tools: Read, Grep, Glob
---
# Skill 071: Conversion Tracking Accuracy

## Purpose
Cross-reference Google Ads conversion data with actual business data (CRM, e-commerce platform, order system) to verify tracking accuracy. Inaccurate tracking leads to poor bidding decisions, incorrect ROAS reporting, and flawed budget allocation.

## Data Requirements

**Data Source:** Standard (plus external business data)

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion action configuration
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion counts and values

**Reference GAQL:**
```sql
SELECT
  segments.date,
  segments.conversion_action_name,
  metrics.conversions,
  metrics.conversions_value,
  metrics.all_conversions,
  metrics.all_conversions_value
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
ORDER BY segments.date DESC
```
Use `/google-ads-get-custom` for date-level conversion data.

Note: Accuracy verification requires comparing to external business system data (CRM, OMS).

## Analysis Steps

1. **Gather Google Ads conversion data:** Extract total conversions and values for analysis period.
2. **Request business system data:** Compare against CRM, e-commerce platform, or order system.
3. **Calculate variance:** Compare counts and values, identify discrepancy patterns.
4. **Diagnose root causes:** Duplicate tracking, attribution differences, consent blocking.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Conversion count variance > 20% | Critical |
| Conversion value variance > 20% | Critical |
| Google Ads shows more conversions than business system | Critical |
| Sudden accuracy change (tracking breakage) | Critical |
| Conversion count variance 10-20% | Warning |
| Daily patterns don't correlate | Warning |

## Output

**Short (default):**
```
## Conversion Tracking Accuracy Audit

**Account:** [Name] | **Period:** Last 30 days | **Variance:** [X]%

### Accuracy Summary
| Metric | Google Ads | Business Data | Variance |
|--------|------------|---------------|----------|
| Conversions | [X] | [Y] | [%] |
| Revenue | $[X] | $[Y] | [%] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Daily comparison table
- Root cause analysis
- Overcounting vs undercounting diagnosis
- Fix implementation steps
