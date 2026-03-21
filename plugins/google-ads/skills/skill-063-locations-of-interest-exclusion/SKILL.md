---
name: skill-063-locations-of-interest-exclusion
description: "Verify that local businesses use 'Presence' targeting instead of 'Presence or Interest' to avoid serving ads to users who cannot physically visit."
allowed-tools: Read, Grep, Glob
---
# Skill 063: Locations of Interest Exclusion

## Purpose
Verify that local businesses use "Presence" targeting instead of "Presence or Interest" to avoid serving ads to users who cannot physically visit. Using "Presence or Interest" for local businesses wastes budget on users outside the service area.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export includes geo targeting locations but not the targeting method (Presence vs Interest).

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign settings including geo targeting
- `data/account/campaigns/*/bid_adjustments.md` - Location targeting details

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.geo_target_type_setting.positive_geo_target_type,
  campaign.geo_target_type_setting.negative_geo_target_type,
  campaign.status
FROM campaign
WHERE campaign.status != 'REMOVED'
```
Run via `/google-ads:get-custom` with query name `geo_targeting_methods`.

## Analysis Steps

1. **Identify local business campaigns:** Look for location extensions, local keywords, service area targeting.
2. **Check location targeting settings:** Extract positive_geo_target_type (PRESENCE_OR_INTEREST vs PRESENCE).
3. **Flag misconfigured campaigns:** Local business + PRESENCE_OR_INTEREST = wasted spend.
4. **Estimate impact:** Calculate potential savings from switching to PRESENCE only.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Local business using PRESENCE_OR_INTEREST | Critical |
| Service area campaign with interest targeting | Critical |
| High local intent keywords with interest targeting | Warning |
| E-commerce using PRESENCE only (too restrictive) | Info |

## Output

**Short (default):**
```
## Locations of Interest Audit

**Account:** [Name] | **Campaigns Analyzed:** [X] | **Misconfigured:** [Y]

### Critical ([Count])
- **[Campaign Name]**: Using "Presence or Interest" for local business -> Change to "Presence" only

### Warnings ([Count])
- **[Campaign Name]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Campaign-by-campaign targeting settings
- Business type assessment
- Expected impact metrics (impressions, cost, CPA)
- Implementation steps
