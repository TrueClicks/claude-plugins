---
name: skill-148-seasonal-keyword-calendar-planning
description: "Build and execute a seasonal keyword calendar 4-6 weeks before peak periods."
allowed-tools: Read, Grep, Glob
---
# Skill 148: Seasonal Keyword Calendar Planning

## Purpose
Ensure seasonal keywords are created and active 4-6 weeks before peak periods. Late keyword launches miss the critical learning period - Smart Bidding needs 2-4 weeks to optimize, and Quality Score requires impression history. Launching during the peak means competing at a disadvantage.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard 30-day export may not include prior-year seasonal queries. Need historical search term data for seasonal periods.

**Standard Data:**
- `data/account/campaigns/*/ad_groups/*/keywords.md` - Current keyword coverage
- `data/performance/campaigns/*/ad_groups/*/search_terms_metrics_30_days.md` - Recent search terms

**GAQL Query (Historical Seasonal Queries):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  search_term_view.search_term,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM search_term_view
WHERE campaign.status = 'ENABLED'
  AND segments.date BETWEEN '[PRIOR_YEAR_SEASON_START]' AND '[PRIOR_YEAR_SEASON_END]'
  AND metrics.conversions > 0
ORDER BY metrics.conversions DESC
LIMIT 500
```
Run via `/google-ads:get-custom` to identify high-converting seasonal queries from prior years.

## Analysis Steps

1. **Map seasonal calendar:** Identify all seasonal periods (holidays, industry peaks) for next 60 days
2. **Check current keyword coverage:** Search existing keywords for seasonal modifiers (e.g., "black friday," "christmas," "2026")
3. **Pull historical queries:** Query prior-year search terms during seasonal periods
4. **Identify gaps:** Find high-converting seasonal queries not covered by existing keywords
5. **Verify timing:** Confirm seasonal keywords are active 4+ weeks before event start

## Thresholds

| Condition | Severity |
|-----------|----------|
| Event within 4 weeks with no seasonal keywords active | Critical |
| High-converting prior-year query not covered as keyword | Warning |
| Seasonal keywords launching <4 weeks before peak | Warning |
| No seasonal ad copy variations prepared | Warning |
| Year-specific keywords (e.g., "2025") still active | Info |

## Output

**Short format (default):**
```
## Seasonal Keyword Planning Audit
**Account:** [Name] | **Events (60d):** [X] | **Keyword gaps:** [Y]

### Critical ([Count])
- **[Event]**: Within [X] weeks, 0 seasonal keywords -> Create "[keyword]" variations

### Warnings ([Count])
- **[Query]**: [X] conversions last year, no keyword -> Add as [match type]

### Recommendations
1. [Specific keyword to create with match type and target date]
```

**Detailed adds:**
- Seasonal keyword calendar by event with launch/pause dates
- Prior-year converting queries not yet covered
- Recommended ad copy seasonal messaging variations
