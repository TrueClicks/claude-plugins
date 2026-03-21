---
name: skill-067-expected-ctr-improvement
description: "Find keywords with 'Below Average' Expected CTR and recommend improvements."
allowed-tools: Read, Grep, Glob
---
# Skill 067: Expected CTR Improvement

## Purpose
Find keywords with "Below Average" Expected CTR and recommend improvements. Expected CTR is based on historical click-through rates and is a key Quality Score component that directly impacts ad costs and positions.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword QS components including Expected CTR
- `data/account/campaigns/*/*/ads.md` - Ad copy to review for CTR issues
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - CTR performance data

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.search_predicted_ctr,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 100
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```
Use `/google-ads:get-custom` if you need additional CTR metrics.

## Analysis Steps

1. **Identify Below Average Expected CTR:** Filter keywords with search_predicted_ctr = BELOW_AVERAGE.
2. **Analyze associated ads:** Check if keyword appears in headlines, evaluate ad copy quality.
3. **Review actual CTR:** Compare to ad group and campaign averages.
4. **Generate recommendations:** Ad copy improvements, extensions, restructuring.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Expected CTR Below Average + Cost > $500/30d | Critical |
| >30% of keywords have Below Average Expected CTR | Critical |
| Keyword not appearing in any ad headline | Critical |
| Expected CTR Below Average + high impressions | Warning |
| Missing ad extensions in ad group | Warning |
| Actual CTR below 1% for Search | Warning |

## Output

**Short (default):**
```
## Expected CTR Improvement Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Below Average CTR:** [Y]

### Critical ([Count])
- **[Keyword]** in [Ad Group]: Below Avg Expected CTR, $[Cost] -> Add keyword to headline

### Warnings ([Count])
- **[Keyword]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Keywords with ad copy analysis
- Ad extension gaps
- Headline recommendations
- Ad testing suggestions
