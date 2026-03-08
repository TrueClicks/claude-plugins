---
name: skill-007-campaign-settings-hygiene
description: "Audit all campaign-level settings including location targeting method, start/end dates, and network settings."
allowed-tools: Read, Grep, Glob
---
# Skill 007: Campaign Settings Hygiene Check

## Purpose
Audit all campaign-level settings including location targeting method, start/end dates, and network settings. A single misconfigured setting (e.g., targeting "interest in" rather than "presence in" a location) can waste significant budget.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard data includes basic campaign settings but may lack `geo_target_type_setting`. Custom GAQL provides complete settings.

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.status,
  campaign.start_date_time,
  campaign.end_date_time,
  campaign.geo_target_type_setting.positive_geo_target_type,
  campaign.geo_target_type_setting.negative_geo_target_type,
  campaign.network_settings.target_google_search,
  campaign.network_settings.target_search_network,
  campaign.network_settings.target_content_network
FROM campaign
WHERE campaign.status != 'REMOVED'
```
Run via `/google-ads-get-custom` with query name `campaign_settings_audit`.

## Analysis Steps

1. **Check location targeting:** Flag campaigns using `PRESENCE_OR_INTEREST` (should be `PRESENCE` for most businesses)
2. **Check start/end dates:** Flag enabled campaigns with past end dates or verify future start dates are intentional
3. **Check network settings:** Verify Search campaigns don't have Display enabled; check Search Partners settings
4. **Review device targeting:** Flag -100% device adjustments (fully excluded devices)

## Thresholds

| Condition | Severity |
|-----------|----------|
| Location method = PRESENCE_OR_INTEREST | Critical |
| Search campaign with Display enabled | Critical |
| End date in past, campaign still enabled | Warning |
| No language targeting set | Warning |
| Device 100% excluded | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Campaign Settings Hygiene Audit
**Account:** [Name] | **Analyzed:** [X] campaigns | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]**: Location targeting includes "interest in" → Change to PRESENCE only
- **[Campaign]**: Display Network enabled on Search → Disable

### Warnings ([Count])
- **[Campaign]**: End date [Date] has passed → Pause or remove end date

### Recommendations
1. Fix location targeting on [X] campaigns
2. Disable Display on Search campaigns
3. Review expired promotion campaigns
```

**Detailed** adds:
- What Was Checked (location settings, network settings, dates, device adjustments)
- Settings matrix table (Campaign, Location Method, Networks, End Date, Issues)
- Issues grouped by category with campaign counts
