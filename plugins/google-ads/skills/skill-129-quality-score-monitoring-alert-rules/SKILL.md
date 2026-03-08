---
name: skill-129-quality-score-monitoring-alert-rules
description: "Monitor Quality Score distribution and recommend alerts for keywords dropping to QS 3 or below."
allowed-tools: Read, Grep, Glob
---
# Skill 129: Quality Score Monitoring and Alert Rules

## Purpose

Analyze Quality Score distribution across all keywords, identify critical QS issues (score 1-3), diagnose component problems (Expected CTR, Ad Relevance, Landing Page), and recommend automated monitoring alerts.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Quality Score and components
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance

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
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND ad_group_criterion.quality_info.quality_score IS NOT NULL
ORDER BY ad_group_criterion.quality_info.quality_score ASC
```
Use `/google-ads-get-custom` for historical QS tracking.

## Analysis Steps

1. **Read keyword QS data:** Extract Quality Scores and components from keywords.md
2. **Categorize by severity:** Critical (1-3), Low (4-5), Average (6-7), Good (8-10)
3. **Identify component issues:** Flag keywords with "Below Average" components
4. **Calculate spend impact:** Sum spend on low QS keywords
5. **Generate alert recommendations:** Provide rule configurations for monitoring

## Thresholds

| Condition | Severity |
|-----------|----------|
| QS 1-3 with significant spend (>$50/30d) | Critical |
| QS 4-5 with high conversion value | Warning |
| Any component "Below Average" on high-spend keyword | Warning |
| QS dropped 2+ points recently | Warning |

## Output

**Short format (default):**
```
## Quality Score Monitoring Audit

**Account:** [Name] | **Keywords with QS:** [X] | **Critical QS:** [Y]

### QS Distribution
| Range | Keywords | Spend |
|-------|----------|-------|
| 1-3 (Critical) | [X] | $[Y] |
| 4-5 (Low) | [X] | $[Y] |
| 6-7 (Average) | [X] | $[Y] |
| 8-10 (Good) | [X] | $[Y] |

### Critical QS Keywords (1-3)
- **"[Keyword]"** (QS [X]): [Component] below average → [Fix]
- **"[Keyword]"** (QS [X]): [Component] below average → [Fix]

### Recommended Alert Rules
- Alert: QS <= 3 with Impressions > 100 → Daily email
- Alert: QS drop of 2+ points → Daily email

### Spend on Low QS
$[Amount] spent on QS 1-3 keywords ([X]% of total)
```

**Detailed adds:**
- Full QS breakdown by campaign
- Component-level analysis table
- Fix procedures by component type
- Alert rule configurations for Google Ads
