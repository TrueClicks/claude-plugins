---
name: skill-058-demographic-performance-analysis
description: "Review performance by demographic segments (age, gender, household income) and recommend targeting adjustments."
allowed-tools: Read, Grep, Glob
---
# Skill 058: Demographic Performance Analysis

## Purpose

Demographic performance varies by business and product type. This skill analyzes performance by age, gender, and household income segments, identifies high and low performers, and recommends bid adjustments or exclusions.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include demographic-segmented performance metrics.

**Standard Data:**
- `data/account/campaigns/*/bid_adjustments.md` - Current demographic adjustments

**GAQL Queries:**

**Age Performance:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.age_range.type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM age_range_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```

**Gender Performance:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.gender.type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM gender_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```

**Household Income (US Only):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.income_range.type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM income_range_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Run via `/google-ads-get-custom`.

## Analysis Steps

1. **Fetch demographic performance data:** Run age, gender, and income queries, load current bid adjustments.

2. **Calculate performance metrics per segment:** Cost Share, Conversion Share, CPA, CVR, ROAS, Efficiency Index = Conversion Share / Cost Share.

3. **Identify patterns and opportunities:** Strong performers (Efficiency >1.2), weak performers (<0.8), exclusion candidates.

4. **Generate adjustment recommendations:** Bid increases/decreases. Note "Unknown" segment limitations (cannot exclude).

## Thresholds

| Condition | Severity |
|-----------|----------|
| Demographic with zero conversions + >$200 spend | Critical |
| Efficiency Index <0.50 | High |
| Efficiency Index >1.50 | High (increase opportunity) |
| Efficiency Index 0.50-0.70 | Warning |
| Efficiency Index 1.30-1.50 | Warning (increase opportunity) |
| Efficiency Index 0.85-1.15 | Info |

## Output

**Short (default):**
```
## Demographic Performance Audit

**Account:** [Name] | **Campaigns Analyzed:** [X]

### Age Performance
| Age Range | Cost | Conv | CPA | Efficiency | Recommendation |
|-----------|------|------|-----|------------|----------------|
| 25-34 | $[X] | [Y] | $[Z] | [E] | +[%] |
| 65+ | $[X] | [Y] | $[Z] | [E] | -[%] |

### Gender Performance
| Gender | CPA | Efficiency | Recommendation |
|--------|-----|------------|----------------|

### Recommendations
1. [Priority adjustment]
2. [Secondary adjustment]
```

**Detailed adds:**
- Full age performance table (all ranges with impressions, clicks, cost, conv, CPA, efficiency)
- Full gender performance table
- Household income performance table (US only)
- Recommended adjustments table per campaign (segment, current, recommended, rationale)
- Data limitations notes (Unknown segment, privacy restrictions, modeled data)
