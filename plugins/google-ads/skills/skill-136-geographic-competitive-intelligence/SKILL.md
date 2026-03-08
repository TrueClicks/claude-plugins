---
name: skill-136-geographic-competitive-intelligence
description: "Analyze regional competitive dynamics and identify geographic opportunities based on impression share by location."
allowed-tools: Read, Grep, Glob
---
# Skill 136: Geographic Competitive Intelligence

## Purpose

Analyze competitive dynamics by geography to identify regions with strong positioning (defend), underserved markets (expand), and areas with poor ROI (evaluate). Geographic insights enable location-based bid adjustments and budget allocation.

## Data Requirements

**Data Source:** Custom GAQL Required

Geographic performance data requires custom GAQL queries.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  geographic_view.country_criterion_id,
  segments.geo_target_region,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM geographic_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Run via `/google-ads-get-custom` with query name `geo_performance`.

## Analysis Steps

1. **Fetch geographic data:** Run GAQL query for location-level metrics
2. **Map performance by region:** Calculate IS, CPA, and conversion rate per location
3. **Identify competition patterns:** Low IS indicates high competition; high IS suggests dominance
4. **Create strategy matrix:** Categorize regions (Defend, Expand, Optimize, Evaluate)
5. **Recommend bid adjustments:** Suggest location modifiers based on efficiency

## Thresholds

| Condition | Severity |
|-----------|----------|
| High-converting region with IS < 40% | Critical |
| Region with CPA > 2x account average | Warning |
| Strong IS region with declining conversion rate | Warning |
| Low IS + low conversion rate region | Info |

## Output

**Short format (default):**
```
## Geographic Competitive Audit

**Account:** [Name] | **Regions Analyzed:** [X] | **Opportunities:** [Y]

### Geographic Performance Overview
| Region | Impressions | IS | Conv Rate | CPA | Strategy |
|--------|-------------|-----|-----------|-----|----------|
| California | [X] | [Y]% | [Z]% | $[A] | Expand |
| Texas | [X] | [Y]% | [Z]% | $[A] | Defend |
| New York | [X] | [Y]% | [Z]% | $[A] | Optimize |

### Expansion Opportunities (Low IS + Good Performance)
- **[Region]**: [X]% IS, [Y]% conv rate → Increase bids +[Z]%

### Defensive Priorities (High IS + Good Performance)
- **[Region]**: Maintain current strategy

### Optimization Needed (High IS + Poor Performance)
- **[Region]**: [X]% IS but poor CPA → Improve targeting/copy

### Recommendations
1. Increase bid modifier +[X]% for [Region]
2. Reduce spend in [Region] (poor ROI)
```

**Detailed adds:**
- Full regional performance table
- Bid modifier recommendations
- Regional competitive inference
- Geographic expansion strategy
