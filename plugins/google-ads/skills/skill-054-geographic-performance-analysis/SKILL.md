---
name: skill-054-geographic-performance-analysis
description: "Analyze conversion performance by geographic location and recommend bid adjustments to optimize spend allocation across high and low performing areas."
allowed-tools: Read, Grep, Glob
---
# Skill 054: Geographic Performance Analysis

## Purpose

Geographic performance varies significantly, and optimizing bid adjustments by location can improve overall account efficiency. This skill analyzes performance by location, identifies high and low performers, and recommends bid adjustments.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include location-segmented performance metrics.

**Standard Data:**
- `data/account/campaigns/*/bid_adjustments.md` - Current location bid modifiers

**GAQL Query:**
```sql
SELECT
  campaign.name,
  geographic_view.country_criterion_id,
  geographic_view.location_type,
  segments.geo_target_region,
  segments.geo_target_metro,
  segments.geo_target_city,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM geographic_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Run via `/google-ads:get-custom` with query name `geographic_performance`.

## Analysis Steps

1. **Gather geographic performance data:** Use custom GAQL to fetch location-level performance, load current bid adjustments.

2. **Calculate performance metrics by location:** CPA, Conversion Rate, ROAS, Cost Share, Conversion Share.

3. **Identify optimization opportunities:** High performers (CPA >20% below average), underperformers (CPA >30% above average), exclusion candidates (CPA >3x average).

4. **Generate bid adjustment recommendations:** Require minimum 10 conversions for increase recommendations, minimum 100 clicks for decrease recommendations.

## Thresholds

| Condition | Severity |
|-----------|----------|
| CPA 40%+ below average (with volume) | Critical (increase bid) |
| CPA 50%+ above average | High (decrease bid) |
| Zero conversions with $50+ spend | High (exclude) |
| CPA 20-40% below average | Warning (moderate increase) |
| CPA 30-50% above average | Warning (moderate decrease) |
| CPA within 10% of average | Info |

## Output

**Short (default):**
```
## Geographic Performance Audit

**Account:** [Name] | **Locations Analyzed:** [X] | **Optimization Opportunities:** [Y]

### Bid Increases ([Count])
- **[Location]**: CPA $[X] ([Y]% below avg), [Z] conv → Increase to +[%]

### Bid Decreases ([Count])
- **[Location]**: CPA $[X] ([Y]% above avg) → Decrease to -[%]

### Exclusion Candidates ([Count])
- **[Location]**: $[X] spend, 0 conversions → Exclude

### Recommendations
1. [Priority adjustment]
2. [Secondary adjustment]
```

**Detailed adds:**
- Account performance baseline table (total conversions, average CPA, average ROAS)
- Top performing locations table (location, conversions, CPA, vs avg, current adj, recommended)
- Underperforming locations table (location, cost, conversions, CPA, vs avg, current adj, recommended)
- Exclusion recommendations table (location, cost, conversions, reason)
