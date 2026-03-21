---
name: skill-005-search-partners-performance
description: "Segment and analyze Search Partners performance separately from Google Search."
allowed-tools: Read, Grep, Glob
---
# Skill 005: Search Partners Network Performance Review

## Purpose
Segment and analyze Search Partners performance separately from Google Search. Search Partners often underperform on conversion rate by 30-50%; disabling them can immediately improve ROAS.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include network-segmented metrics.

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.network_settings.target_search_network,
  segments.ad_network_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.status = 'ENABLED'
  AND campaign.advertising_channel_type = 'SEARCH'
```
Run via `/google-ads:get-custom` with query name `search_partners_performance`.

## Analysis Steps

1. **Fetch network-segmented data:** Run custom GAQL query; separate SEARCH vs SEARCH_PARTNERS segments
2. **Calculate performance by network:** For each campaign, calculate CTR, CPC, Conv Rate, CPA, ROAS for both networks
3. **Compare performance:** Calculate delta between Search Partners and Google Search metrics
4. **Identify underperformers:** Flag campaigns where Search Partners conv rate is >30% lower than Google Search
5. **Calculate waste:** Estimate monthly savings from disabling Search Partners on underperforming campaigns

## Thresholds

| Condition | Severity |
|-----------|----------|
| Search Partners conv rate >50% lower than Google Search | Critical |
| Search Partners enabled with 0 conversions and >$100 spend | Critical |
| Search Partners conv rate >30% lower than Google Search | Warning |
| Search Partners CPA >2x Google Search CPA | Warning |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Search Partners Performance Audit
**Account:** [Name] | **Analyzed:** [X] campaigns | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]**: Search Partners CPA $[X] vs Google $[Y] (>50% worse) → Disable Search Partners

### Warnings ([Count])
- **[Campaign]**: Search Partners conv rate [X]% vs Google [Y]% → Monitor or disable

### Recommendations
1. Disable Search Partners on [X] campaigns (saves ~$[Y]/month)
2. Keep Search Partners on [X] campaigns where performance is within 15%
```

**Detailed** adds:
- What Was Checked (network segmentation, metrics calculated)
- Network comparison table (Cost, Conv, Conv Rate, CPA, ROAS by network)
- Campaign-level breakdown with performance deltas
- Total waste calculation
