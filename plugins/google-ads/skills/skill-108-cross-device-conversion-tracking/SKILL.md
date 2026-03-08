---
name: skill-108-cross-device-conversion-tracking
description: "Evaluate whether cross-device conversion paths are captured through Enhanced Conversions."
allowed-tools: Read, Grep, Glob
---
# Skill 108: Cross-Device Conversion Tracking

## Purpose
Evaluate whether cross-device conversion paths are captured. Multi-device journeys are the norm; single-device attribution undervalues initiating campaigns and causes budget misallocation.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/account_summary.md` - Enhanced Conversions status
- `data/account/conversion_actions.md` - Conversion settings

**Reference GAQL:**
```sql
SELECT
  segments.device,
  segments.conversion_action_name,
  metrics.conversions,
  metrics.all_conversions
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` for device-level conversion analysis.

## Analysis Steps

1. **Assess Tracking Capability:** Check Google Signals, Enhanced Conversions, User-ID status
2. **Review Enhanced Conversions Status:** Identify which conversions have enhanced tracking
3. **Analyze Cross-Device Patterns:** Compare mobile vs. desktop conversion rates
4. **Evaluate Attribution Settings:** Check if DDA and cross-device conversions enabled

## Thresholds

| Condition | Severity |
|-----------|----------|
| Enhanced Conversions not enabled | Critical |
| Large gap between conversions and all_conversions | Warning |
| Mobile bid adjustments heavily negative (compensating) | Warning |
| Last-click attribution still in use | Warning |
| Google Signals disabled | Info |

## Output

**Short (default):**
```
## Cross-Device Tracking Audit
**Account:** [name] | **Enhanced Conv:** [On/Off] | **DDA:** [On/Off] | **Issues:** [count]

### Critical
- **Enhanced Conversions not enabled** - Missing cross-device paths

### Warnings
- **Mobile -50% bid adjustment** - May be compensating for tracking gap
- **Last-click attribution** - Undervalues mobile/initiating touchpoints

### Recommendations
1. Enable Enhanced Conversions for web
2. Switch to Data-Driven Attribution
3. Review mobile bid adjustments after cross-device tracking enabled
```

**Detailed adds:**
- Cross-device tracking capability matrix
- Device performance comparison
- Expected impact of Enhanced Conversions
- Mobile bid adjustment implications
