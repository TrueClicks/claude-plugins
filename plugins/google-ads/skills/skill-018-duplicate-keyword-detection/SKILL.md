---
name: skill-018-duplicate-keyword-detection
description: "Find duplicate keywords across ad groups and campaigns, considering match type and Quality Score to determine which instances to consolidate."
allowed-tools: Read, Grep, Glob
---
# Skill 018: Duplicate Keyword Detection

## Purpose
Find duplicate keywords across ad groups and campaigns, considering match type and Quality Score to determine which instances to consolidate. Duplicates fragment data, create internal competition, and waste budget.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword settings with match type and Quality Score
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.quality_info.quality_score,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need different date ranges.

## Analysis Steps

1. **Normalize and index:** Extract keywords with text (lowercase, trimmed), match type, campaign, ad group, QS
2. **Find exact duplicates:** Same keyword text + same match type in different locations
3. **Find match type variants:** Same keyword text with different match types (exact + phrase + broad)
4. **Compare performance:** For each duplicate set, compare QS, CTR, CPA, conversions
5. **Calculate waste:** Sum cost across duplicate instances; identify budget fragmentation

## Thresholds

| Condition | Severity |
|-----------|----------|
| Same keyword+match in 3+ locations | Critical |
| Duplicate across campaigns (internal competition) | Critical |
| Exact duplicate with 3+ QS difference | Warning |
| Low-QS duplicate has more spend | Warning |
| All three match types for same term | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Duplicate Keyword Audit
**Account:** [Name] | **Duplicates:** [X] sets | **Instances:** [Y]

### Critical ([Count])
- **[keyword]** ([match]): [X] instances, QS range [Y]-[Z] → Keep highest QS, pause others
- **Cross-campaign duplicate**: "[keyword]" in [Campaign A] and [Campaign B] → Consolidate

### Warnings ([Count])
- **[keyword]**: Low-QS instance getting [X]% of spend → Redirect to high-QS instance

### Recommendations
1. Consolidate [X] duplicate sets
2. Estimated efficiency gain: +[Y] avg QS, -$[Z] fragmented spend
```

**Detailed** adds:
- What Was Checked (normalization, match type comparison)
- Exact duplicates table (Keyword, Match, Instance 1, QS, Instance 2, QS, Cost Split)
- Match type variants table (Keyword, Exact QS, Phrase QS, Broad QS, Locations)
- Consolidation recommendations (Keyword, Current State, Action, Expected Impact)
