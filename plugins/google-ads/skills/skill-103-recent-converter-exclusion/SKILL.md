---
name: skill-103-recent-converter-exclusion
description: "Maintain exclusion lists for users who converted within an appropriate window (7-30 days)."
allowed-tools: Read, Grep, Glob
---
# Skill 103: Recent Converter Exclusion Lists

## Purpose
Maintain exclusion lists for recent converters. Showing ads to recent buyers wastes 5-15% of remarketing budgets and can irritate customers who just purchased.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Audience targeting and exclusions
- `data/account/campaigns/*/*/audience_targeting.md` - Ad group audiences

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group_criterion.user_list.user_list,
  ad_group_criterion.negative
FROM ad_group_audience_view
WHERE ad_group_criterion.negative = true
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` for complete exclusion inventory.

## Analysis Steps

1. **Identify Conversion-Based Audiences:** Find purchaser/converter lists
2. **Evaluate Exclusion Coverage:** Check which campaigns have converter exclusions
3. **Determine Appropriate Windows:** Match exclusion duration to repurchase cycle
4. **Identify Gaps:** Campaigns missing exclusions, windows too short/long

## Thresholds

| Condition | Severity |
|-----------|----------|
| No converter exclusion on any campaign | Critical |
| Remarketing campaign without purchaser exclusion | Critical |
| Exclusion window shorter than buying cycle | Warning |
| Exclusion on some campaigns but not all | Warning |

## Output

**Short (default):**
```
## Converter Exclusion Audit
**Account:** [name] | **Remarketing Campaigns:** [count] | **With Exclusions:** [count]

### Critical
- **No purchaser exclusion on remarketing** - Wasting budget on converters
- **[count] campaigns missing converter exclusion** - Add immediately

### Warnings
- **Exclusion at 7 days, buying cycle ~30 days** - Extend to 30+ days

### Recommendations
1. Create "Purchasers - Last 30 Days" exclusion list
2. Apply to all remarketing and prospecting Display campaigns
3. Consider 90-day exclusion for acquisition campaigns
```

**Detailed adds:**
- Exclusion coverage table by campaign
- Recommended exclusion windows by product type
- Estimated budget waste from missing exclusions
- Exclusion structure for e-commerce vs. lead gen
