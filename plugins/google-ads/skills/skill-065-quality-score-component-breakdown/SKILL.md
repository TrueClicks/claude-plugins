---
name: skill-065-quality-score-component-breakdown
description: "Track the three Quality Score components separately: Expected CTR, Ad Relevance, and Landing Page Experience."
allowed-tools: Read, Grep, Glob
---
# Skill 065: Quality Score Component Breakdown

## Purpose
Track the three Quality Score components separately: Expected CTR, Ad Relevance, and Landing Page Experience. Understanding which component is causing low QS enables targeted optimization.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Contains QS components (Expected CTR, Ad Relevance, Landing Page Experience)
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Performance metrics for prioritization

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.search_predicted_ctr,
  ad_group_criterion.quality_info.creative_quality_score,
  ad_group_criterion.quality_info.post_click_quality_score,
  metrics.impressions,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 100
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` if you need additional fields or filters.

## Analysis Steps

1. **Extract component ratings:** Read keywords.md files for Expected CTR, Ad Relevance, Landing Page ratings.
2. **Classify by component:** Count keywords with Below Average for each component.
3. **Identify primary issues:** Which component has the most Below Average ratings?
4. **Prioritize by spend:** Focus on high-spend keywords with component issues.

## Thresholds

| Condition | Severity |
|-----------|----------|
| All 3 components Below Average | Critical |
| 2 components Below Average | Critical |
| Landing Page Below Average (account-wide) | Critical |
| Expected CTR Below Average + high spend | Warning |
| Ad Relevance Below Average | Warning |
| >30% of keywords with any Below Average | Warning |

## Output

**Short (default):**
```
## Quality Score Component Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Issues:** [Y]

### Component Summary
| Component | Below Avg | Avg | Above Avg |
|-----------|-----------|-----|-----------|
| Expected CTR | [X] | [Y] | [Z] |
| Ad Relevance | [X] | [Y] | [Z] |
| Landing Page | [X] | [Y] | [Z] |

### Critical ([Count])
- **[Keyword]**: All 3 components Below Average -> Full restructure needed

### Recommendations
1. [Priority action based on most common issue]
2. [Secondary action]
```

**Detailed adds:**
- Keywords grouped by component issue
- Ad group-level patterns
- Component-specific fix checklists
- Priority matrix by spend and severity
