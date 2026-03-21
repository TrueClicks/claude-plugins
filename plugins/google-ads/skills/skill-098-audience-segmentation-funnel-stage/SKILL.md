---
name: skill-098-audience-segmentation-funnel-stage
description: "Audit audience segments based on funnel position: homepage visitors, product viewers, cart abandoners, and past purchasers."
allowed-tools: Read, Grep, Glob
---
# Skill 098: Audience Segmentation by Funnel Stage

## Purpose
Audit audience segments based on user funnel position. Segmented remarketing delivers up to 150% higher conversion rates compared to generic lists by matching messaging and bids to user intent.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Campaign-level audiences
- `data/account/campaigns/*/*/audience_targeting.md` - Ad group-level audiences

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.user_list.user_list,
  ad_group_criterion.type,
  ad_group_criterion.status,
  ad_group_criterion.bid_modifier
FROM ad_group_audience_view
WHERE segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need audience sizes or additional details.

## Analysis Steps

1. **Inventory Current Audiences:** Read all audience_targeting.md files; compile complete list
2. **Classify by Funnel Stage:** Map each audience to Top (awareness), Mid (consideration), Bottom (intent), Post-conversion
3. **Identify Segmentation Gaps:** Check for missing critical segments (cart abandoners, purchasers)
4. **Evaluate Membership Durations:** Review if durations match buying cycle

## Thresholds

| Condition | Severity |
|-----------|----------|
| No cart abandoner audience (e-commerce) | Critical |
| No past purchaser exclusion list | Critical |
| No product viewer audience (e-commerce) | Warning |
| Only "All Visitors" audience (no segmentation) | Warning |
| Missing form abandoner audience (lead gen) | Warning |

## Output

**Short (default):**
```
## Audience Segmentation Audit
**Account:** [name] | **Audiences Found:** [count] | **Funnel Gaps:** [count]

### Critical
- **No cart abandoner audience** - Create 7-14 day cart abandoner list
- **No purchaser exclusion** - Wasting budget on recent converters

### Warnings
- **No product viewer audience** - Missing mid-funnel targeting
- **Only generic "All Visitors"** - Segment for better performance

### Recommendations
1. Create cart abandoner audience (7-14 day window)
2. Create purchaser exclusion list (30 days minimum)
3. Add product viewer audiences for dynamic remarketing
```

**Detailed adds:**
- Funnel stage distribution table
- Audience list with classifications and durations
- Recommended segmentation structure for business type
- Bid adjustment recommendations by funnel stage
