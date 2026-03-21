---
name: skill-060-in-market-custom-intent-layering
description: "Evaluate usage of in-market segments and custom intent audiences to improve targeting precision."
allowed-tools: Read, Grep, Glob
---
# Skill 060: In-Market and Custom Intent Audience Layering

## Purpose

In-market segments and custom intent audiences help reach users with demonstrated purchase intent. This skill evaluates current usage, identifies performance patterns, and recommends additional segments to add or custom intent audiences to create.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export includes audience targeting setup but not audience-level performance metrics.

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Current audience setup

**GAQL Query:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.user_interest.user_interest_category,
  ad_group_criterion.custom_intent.custom_intent,
  ad_group_criterion.bid_modifier,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM ad_group_audience_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Run via `/google-ads:get-custom` with query name `audience_performance`.

## Analysis Steps

1. **Review current audience setup:** Read audience targeting files, identify in-market audiences in use, identify custom intent audiences, note targeting mode.

2. **Evaluate in-market audience performance:** Fetch performance data, calculate CPA/ROAS vs non-audience traffic, identify high and low performers.

3. **Identify missing opportunities:** Relevant in-market segments not used, custom intent audiences not created, high-performing audiences underutilized.

4. **Generate recommendations:** In-market segments to add, custom intent audiences to create, bid adjustments for existing audiences.

## Thresholds

| Condition | Severity |
|-----------|----------|
| No in-market or custom intent audiences used | High |
| In-market audience CPA >30% below average | High (increase bid) |
| In-market audience CPA >50% above average | Warning (decrease/remove) |
| Missing relevant in-market category for business | Warning |
| Custom intent audience not created for competitors | Info |

## Output

**Short (default):**
```
## In-Market & Custom Intent Audit

**Account:** [Name] | **In-Market Segments Used:** [X] | **Custom Intent Audiences:** [Y]

### High Priority ([Count])
- **[Campaign]**: No in-market audiences → Add [relevant categories]

### In-Market Performance
| Segment | Cost | Conv | CPA | vs Avg |
|---------|------|------|-----|--------|
| [Category] | $[X] | [Y] | $[Z] | [%] |

### Recommended Custom Intent Audiences
1. **Competitor Intent**: [competitor1], [competitor2] keywords
2. **Product Intent**: [product + buy], [product + price] keywords

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Current audience setup summary table (campaign, in-market used, custom intent used, mode)
- In-market audience performance table (segment, impressions, clicks, cost, conv, CPA, vs avg)
- Recommended in-market segments by industry
- Custom intent audience recommendations with purpose, keywords, and URLs
- Layering strategy recommendations by campaign type
- Targeting vs Observation mode guidance
