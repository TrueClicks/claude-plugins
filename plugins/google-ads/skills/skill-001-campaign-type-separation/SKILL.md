---
name: skill-001-campaign-type-separation
description: "Verify that Search, Display, Shopping, Video, and Performance Max campaigns are never mixed in ways that compromise optimization signals."
allowed-tools: Read, Grep, Glob
---
# Skill 001: Campaign Type Separation

## Purpose
Verify that Search, Display, Shopping, Video, and Performance Max campaigns are never mixed in ways that compromise optimization signals. Mixing network types prevents accurate performance analysis and dilutes bidding signals.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign settings including type, network settings

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.advertising_channel_type,
  campaign.advertising_channel_sub_type,
  campaign.network_settings.target_google_search,
  campaign.network_settings.target_search_network,
  campaign.network_settings.target_content_network,
  campaign.status
FROM campaign
WHERE campaign.status != 'REMOVED'
```
Use `/google-ads-get-custom` if you need additional fields or different filters.

## Analysis Steps

1. **Load all campaign files:**
   - Read each `campaign.md` file from `data/account/campaigns/*/`
   - Extract: Campaign Name, Type, Network Settings, Status

2. **Classify campaigns by type:**
   - SEARCH: Standard Search campaigns
   - DISPLAY: Display Network campaigns
   - SHOPPING: Standard Shopping campaigns
   - VIDEO: YouTube/Video campaigns
   - PERFORMANCE_MAX: PMax campaigns
   - DISCOVERY/DEMAND_GEN: Discovery/Demand Gen campaigns

3. **Check for network mixing issues:**
   - Search campaigns with Display Network enabled (target_content_network = true)
   - Search campaigns with Search Partners enabled (may dilute signals)
   - Unclear or hybrid campaign configurations

4. **Identify naming inconsistencies:**
   - Campaign names that don't reflect their actual type
   - Mixed signals in naming vs configuration

## Thresholds

| Condition | Severity |
|-----------|----------|
| Search campaign with Display Network enabled | Critical |
| Search campaign with Search Partners enabled | Warning |
| Campaign name doesn't match actual type | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Campaign Type Separation Audit
**Account:** [Name] | **Analyzed:** [X] campaigns | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]**: [Issue] → [Fix]

### Warnings ([Count])
- **[Campaign]**: [Issue] → [Fix]

### Recommendations
1. [Action]
```

**Detailed** adds:
- What Was Checked (campaign types, network settings, naming)
- Impact and evidence for each issue
- Summary table
