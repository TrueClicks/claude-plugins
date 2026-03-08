---
name: skill-006-display-network-optin
description: "Check whether Search campaigns have inadvertently opted into the Google Display Network."
allowed-tools: Read, Grep, Glob
---
# Skill 006: Display Network Opt-in Audit

## Purpose
Check whether Search campaigns have inadvertently opted into the Google Display Network. This default-on setting routes budget to low-intent display placements, reducing Search campaign efficiency.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export may not include `target_content_network` setting. Custom GAQL provides complete network settings and spend breakdown.

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.advertising_channel_type,
  campaign.network_settings.target_content_network,
  segments.ad_network_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.status = 'ENABLED'
```
Run via `/google-ads-get-custom` with query name `display_network_audit`.

## Analysis Steps

1. **Identify Search campaigns:** Filter for campaigns with `advertising_channel_type = SEARCH`
2. **Check Display setting:** Flag all Search campaigns with `target_content_network = true`
3. **Quantify Display spend:** Segment by `ad_network_type` to calculate Display spend as % of campaign total
4. **Compare performance:** Calculate Display vs Search conversion rates within each campaign
5. **Calculate waste:** Estimate budget redirectable to Search if Display is disabled

## Thresholds

| Condition | Severity |
|-----------|----------|
| Search campaign with Display Network enabled | Critical |
| Display spend >5% of Search campaign budget | Critical |
| Display conversions = 0 with >$50 spend | Critical |
| Display conv rate <50% of Search conv rate | Warning |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Display Network Opt-in Audit
**Account:** [Name] | **Analyzed:** [X] Search campaigns | **Display Enabled:** [Y]

### Critical ([Count])
- **[Campaign]**: Display Network enabled, $[X] Display spend ([Y]% of campaign) → Disable

### Warnings ([Count])
- **[Campaign]**: Display conv rate [X]% vs Search [Y]% → Review and likely disable

### Recommendations
1. Disable Display Network on [X] Search campaigns
2. Estimated monthly savings: $[Y]
3. If Display reach needed, create dedicated Display campaigns
```

**Detailed** adds:
- What Was Checked (network settings, spend segmentation)
- Campaign breakdown table (Display ON/OFF, Display Spend, Display Conv)
- Performance comparison (Display vs Search metrics)
