---
name: skill-069-landing-page-experience-assessment
description: "Evaluate landing pages for relevance, speed, and mobile-friendliness."
allowed-tools: Read, Grep, Glob
---
# Skill 069: Landing Page Experience Assessment

## Purpose
Evaluate landing pages for relevance, speed, and mobile-friendliness. Landing Page Experience is a key Quality Score component that affects ad costs and positions. Poor landing pages waste ad spend on traffic that bounces.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword QS components including Landing Page Experience
- `data/account/campaigns/*/*/ads.md` - Final URLs for landing pages
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Performance data

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.post_click_quality_score,
  metrics.impressions,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 50
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need URL-level aggregation.

## Analysis Steps

1. **Identify Below Average LP Experience:** Filter keywords with post_click_quality_score = BELOW_AVERAGE.
2. **Catalog landing pages:** List unique final URLs and count keywords pointing to each.
3. **Group by landing page:** Calculate spend per landing page with LP issues.
4. **Prioritize fixes:** Focus on high-spend landing pages with Below Average ratings.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Landing Page Below Average + Cost > $500/30d | Critical |
| >50% of keywords have Below Average LP | Critical |
| Single landing page affecting multiple keywords | Critical |
| Landing Page Below Average | Warning |
| Page load time > 5 seconds (if testable) | Warning |
| Mobile unfriendly (if testable) | Warning |

## Output

**Short (default):**
```
## Landing Page Experience Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Below Average LP:** [Y]

### Critical ([Count])
- **[Landing Page URL]**: [X] keywords, $[Cost] -> Test with PageSpeed Insights

### Warnings ([Count])
- **[URL]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Landing page inventory with keyword counts
- Spend per landing page
- PageSpeed testing recommendations
- Mobile-friendliness check guidance
