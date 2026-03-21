---
name: skill-064-quality-score-distribution-analysis
description: "Monitor Quality Score distribution across keywords and flag keywords with QS of 3 or below."
allowed-tools: Read, Grep, Glob
---
# Skill 064: Quality Score Distribution Analysis

## Purpose
Monitor Quality Score distribution across keywords and flag keywords with QS of 3 or below. Low Quality Scores indicate poor ad relevance, landing page experience, or expected CTR, leading to higher CPCs and lower ad positions.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword Quality Score data including overall QS and components
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance metrics

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.creative_quality_score,
  ad_group_criterion.quality_info.post_click_quality_score,
  ad_group_criterion.quality_info.search_predicted_ctr,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need additional metrics or different date ranges.

## Analysis Steps

1. **Load keyword QS data:** Read all keywords.md files and extract Quality Score values.
2. **Calculate distribution:** Count keywords by QS bucket (1-3, 4-5, 6-7, 8-10, N/A).
3. **Calculate weighted average:** Weight by impressions, target weighted avg QS > 6.
4. **Flag critical issues:** High-spend keywords with QS 1-3 are priority fixes.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Keyword QS 1-3 with Cost > $100/30d | Critical |
| Keyword QS 1-3 with Impressions > 1,000 | Critical |
| >20% of keywords have QS 1-3 | Critical |
| Weighted average QS < 5 | Critical |
| Keyword QS 4-5 with Cost > $200/30d | Warning |
| Weighted average QS 5-6 | Warning |

## Output

**Short (default):**
```
## Quality Score Distribution Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Weighted Avg QS:** [Y]

### Distribution
| QS Range | Count | % |
|----------|-------|---|
| 8-10 | [X] | [%] |
| 6-7 | [X] | [%] |
| 4-5 | [X] | [%] |
| 1-3 | [X] | [%] |

### Critical ([Count])
- **[Keyword]** in [Ad Group]: QS [X], $[Cost] -> [Primary issue component]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Full keyword list with QS and components
- QS by campaign breakdown
- Component analysis (CTR, Relevance, LP)
- Estimated CPC savings from QS improvements
