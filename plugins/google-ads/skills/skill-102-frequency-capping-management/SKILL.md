---
name: skill-102-frequency-capping-management
description: "Set appropriate frequency caps (typically 3-5 impressions per user per week) to prevent ad fatigue and wasted impressions."
allowed-tools: Read, Grep, Glob
---
# Skill 102: Frequency Capping Management

## Purpose
Set appropriate frequency caps to prevent ad fatigue and wasted impressions. Uncapped remarketing wastes spend on users who have decided not to convert and damages brand perception.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.frequency_caps,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM campaign
WHERE campaign.advertising_channel_type IN ('DISPLAY', 'VIDEO')
  AND campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `frequency_analysis`.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign settings

## Analysis Steps

1. **Identify Display/Video Campaigns:** Filter for campaigns where frequency capping applies
2. **Check Current Cap Settings:** Review frequency cap configurations
3. **Analyze Reach vs. Frequency:** Compare impressions to estimated unique reach
4. **Benchmark Against Best Practices:** 3-5/week for remarketing, 2-3/week for prospecting

## Thresholds

| Condition | Severity |
|-----------|----------|
| No frequency cap on remarketing campaign | Critical |
| Caps above 10 impressions/week | Warning |
| No frequency cap on any Display campaign | Warning |
| Caps below 2/week (under-exposure) | Info |

## Output

**Short (default):**
```
## Frequency Capping Audit
**Account:** [name] | **Display/Video Campaigns:** [count] | **Without Caps:** [count]

### Critical
- **[campaign]**: No frequency cap - Unlimited impressions per user

### Warnings
- **[campaign]**: Cap at 15/week - Reduce to 5/week
- **[count] campaigns without caps** - Add 3-5 impressions/week

### Recommendations
1. Set 5 impressions/week cap on all remarketing campaigns
2. Set 3 impressions/week cap on prospecting Display
3. Consider 3/week cap for YouTube TrueView
```

**Detailed adds:**
- Campaign frequency cap inventory
- Recommended caps by campaign type table
- Estimated wasted impressions from over-exposure
- Layered approach recommendation (weekly + daily)
