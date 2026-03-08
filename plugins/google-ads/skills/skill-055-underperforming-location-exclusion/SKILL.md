---
name: skill-055-underperforming-location-exclusion
description: "Identify and recommend exclusion of geographic areas with high cost but low or zero conversions to eliminate wasted spend."
allowed-tools: Read, Grep, Glob
---
# Skill 055: Underperforming Location Exclusion

## Purpose

Geographic areas with high cost but low or zero conversions waste budget that could be spent on proven performing areas. This skill identifies exclusion candidates, quantifies waste, and provides prioritized exclusion recommendations.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include location-segmented performance metrics.

**Standard Data:**
- `data/account/campaigns/*/bid_adjustments.md` - Current location exclusions

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.id,
  geographic_view.country_criterion_id,
  geographic_view.location_type,
  segments.geo_target_region,
  segments.geo_target_city,
  segments.geo_target_metro,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM geographic_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.cost_micros > 0
```
Run via `/google-ads-get-custom` with query name `location_exclusion_analysis`.

## Analysis Steps

1. **Fetch geographic performance data:** Use custom GAQL, load current exclusions from bid_adjustments.md files.

2. **Identify exclusion candidates:** Zero conversions with Cost >$50, CPA >3x account average, CVR <0.5x account average with 100+ clicks, locations outside service area.

3. **Calculate waste and impact:** Total waste (30 days), projected annual savings, % of budget wasted.

4. **Prioritize exclusions:** High priority (zero conversions + significant spend), Medium (very high CPA >3x), Low (borderline cases).

## Thresholds

| Condition | Severity |
|-----------|----------|
| Zero conversions with cost >$100 | Critical |
| CPA >3x account average | High |
| Zero conversions with cost $50-100 | High |
| CVR <0.5x average with 100+ clicks | Warning |
| Locations outside service area (any spend) | High |

## Output

**Short (default):**
```
## Location Exclusion Audit

**Account:** [Name] | **Locations Analyzed:** [X] | **Exclusion Candidates:** [Y]
**Current Waste:** $[X]/month | **Projected Annual Savings:** $[Y]

### High Priority Exclusions ([Count])
- **[Campaign] / [Location]**: $[X] cost, 0 conversions → Exclude

### Medium Priority ([Count])
- **[Campaign] / [Location]**: CPA $[X] ([Y]x average) → Exclude

### Recommendations
1. Exclude [X] locations to save $[Y]/month
2. [Secondary action]
```

**Detailed adds:**
- Summary table (total locations, flagged for exclusion, current spend on flagged, projected savings)
- High priority exclusions table (campaign, location, impressions, clicks, cost, conversions, action)
- Medium priority exclusions table with CPA comparison to account average
- Low priority review table (borderline cases to monitor)
- Exclusion decision framework flowchart
