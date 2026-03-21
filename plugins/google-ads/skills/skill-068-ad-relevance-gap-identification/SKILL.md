---
name: skill-068-ad-relevance-gap-identification
description: "Flag keywords where ad copy does not match keyword intent."
allowed-tools: Read, Grep, Glob
---
# Skill 068: Ad Relevance Gap Identification

## Purpose
Flag keywords where ad copy does not match keyword intent. Low Ad Relevance indicates a disconnect between what users search for and what ads show, leading to lower Quality Scores and wasted spend.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword data with Ad Relevance component
- `data/account/campaigns/*/*/ads.md` - Ad copy (headlines, descriptions)
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Performance for prioritization

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.creative_quality_score,
  metrics.impressions,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 50
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need additional fields.

## Analysis Steps

1. **Identify Below Average Ad Relevance:** Filter keywords with creative_quality_score = BELOW_AVERAGE.
2. **Analyze ad copy:** Check if keywords appear in headlines/descriptions, evaluate semantic relevance.
3. **Assess ad group structure:** Count keywords per ad group, check theme consistency.
4. **Generate gap report:** Keywords with issues, restructuring recommendations.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad Relevance Below Average + Cost > $200/30d | Critical |
| Keyword not in any ad headline or description | Critical |
| Ad group has >20 keywords with mixed themes | Critical |
| Ad Relevance Below Average | Warning |
| Intent mismatch (transactional kw, informational ad) | Warning |
| Generic ad copy for specific keywords | Warning |

## Output

**Short (default):**
```
## Ad Relevance Gap Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Below Average:** [Y]

### Critical ([Count])
- **[Keyword]** in [Ad Group]: Not in ad copy, $[Cost] -> Add to headline or split ad group

### Warnings ([Count])
- **[Keyword]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Ad group structure analysis
- Keyword-to-ad mapping
- Ad group split recommendations
- Keyword insertion opportunities
