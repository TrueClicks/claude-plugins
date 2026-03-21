---
name: skill-115-display-youtube-placement-performance-review
description: "Conduct placement reports to identify high-impression, low-conversion placements for optimization or exclusion."
allowed-tools: Read, Grep, Glob
---
# Skill 115: Display/YouTube Placement Performance Review

## Purpose
Conduct placement reports to identify high-impression, low-conversion placements for optimization or exclusion. Monthly placement reviews can recover 10-30% of Display/Video spend.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query - Display Placements:**
```sql
SELECT
  detail_placement_view.display_name,
  detail_placement_view.placement,
  detail_placement_view.placement_type,
  detail_placement_view.target_url,
  campaign.name,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM detail_placement_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```

**GAQL Query - YouTube Placements:**
```sql
SELECT
  detail_placement_view.display_name,
  detail_placement_view.placement,
  campaign.name,
  campaign.advertising_channel_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM detail_placement_view
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.advertising_channel_type = 'VIDEO'
```
Note: CTR and view rate not directly available on `detail_placement_view` — calculate client-side from clicks/impressions.
Run via `/google-ads:get-custom` with query name `placement_review`.

## Analysis Steps

1. **Pull Placement Performance:** Get top placements by spend and impressions
2. **Identify Red Flags:** High spend + zero conversions, abnormal CTR, low video view rates
3. **Categorize Placements:** Top performers, potential, underperformers, exclude
4. **Calculate Waste:** Total spend on non-converting placements

## Thresholds

| Condition | Severity |
|-----------|----------|
| Placement with >$100 spend and 0 conversions | Critical |
| CTR >5% (potential click fraud) | Warning |
| Video view rate <10% | Warning |
| >20% spend on non-converting placements | Warning |

## Output

**Short (default):**
```
## Placement Performance Review
**Account:** [name] | **Period:** Last 30 days | **Placements Analyzed:** [count]

### Summary
- **Total Display/Video Spend:** $[amount]
- **Non-Converting Placement Spend:** $[amount] ([%])

### Critical - Exclude Immediately
| Placement | Type | Cost | Conv | Reason |
|-----------|------|------|------|--------|
| [name] | [type] | $[amount] | 0 | Zero conversions |

### Warnings
- **[count] placements with suspicious CTR** - Potential click fraud
- **[count] YouTube placements with <10% view rate** - Poor engagement

### Recommendations
1. Exclude [count] zero-conversion placements - Save $[amount]/month
2. Investigate [count] high-CTR placements for fraud
3. Set up monthly placement review
```

**Detailed adds:**
- Top 20 placements by spend with performance
- Placement type distribution table
- Month-over-month comparison if available
- Targeting refinement suggestions
