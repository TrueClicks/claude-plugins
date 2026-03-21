---
name: skill-056-device-performance-analysis
description: "Analyze performance segmented by device type (desktop, mobile, tablet) and recommend bid adjustments to optimize spend allocation."
allowed-tools: Read, Grep, Glob
---
# Skill 056: Device Performance Analysis

## Purpose

Device performance varies significantly by business type. This skill analyzes performance by device (desktop, mobile, tablet), identifies efficiency differences, and recommends bid adjustments for Manual CPC campaigns or exclusions for Smart Bidding.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include device-segmented performance metrics.

**Standard Data:**
- `data/account/campaigns/*/bid_adjustments.md` - Current device bid modifiers

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.id,
  segments.device,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value,
  metrics.average_cpc
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Run via `/google-ads:get-custom` with query name `device_performance`. Device values: DESKTOP, MOBILE, TABLET, CONNECTED_TV.

## Analysis Steps

1. **Load device performance data:** Use custom GAQL, load current bid adjustments from bid_adjustments.md files.

2. **Calculate device performance metrics:** Impression/Click/Cost/Conversion share by device, CPA, CVR, ROAS per device.

3. **Analyze device efficiency:** Device Efficiency Index = (Campaign Avg CPA / Device CPA) - 1. Positive = outperforms, Negative = underperforms.

4. **Generate bid adjustment recommendations:** Based on efficiency index. Note: For Smart Bidding, only -100% (exclude) is honored.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Device with zero conversions + >$200 spend | Critical |
| Device efficiency index < -0.40 | High |
| Device efficiency index > +0.40 | High (increase opportunity) |
| Device efficiency index -0.40 to -0.20 | Warning |
| Device efficiency index +0.20 to +0.40 | Warning (increase opportunity) |
| Device efficiency within +/-0.10 | Info |

## Output

**Short (default):**
```
## Device Performance Audit

**Account:** [Name] | **Campaigns Analyzed:** [X]

### Account-Level Summary
| Device | Cost | Conv | CPA | vs Avg |
|--------|------|------|-----|--------|
| Desktop | $[X] | [Y] | $[Z] | [%] |
| Mobile | $[X] | [Y] | $[Z] | [%] |
| Tablet | $[X] | [Y] | $[Z] | [%] |

### Recommendations ([Count])
- **[Campaign]**: Mobile CPA [X]% above average → Adjust to -[Y]%
- **[Campaign]**: Desktop outperforming → Increase to +[Y]%

Note: Device bid adjustments (except -100%) are ignored on Smart Bidding campaigns.
```

**Detailed adds:**
- Account-level device summary table (device, impressions, clicks, cost, conversions, CPA, CVR, ROAS)
- Campaign-level device analysis (campaign, device, cost, conv, CPA, vs avg, current adj, recommended)
- Recommendations summary table per campaign (desktop, mobile, tablet adjustments)
- Industry benchmark comparison
