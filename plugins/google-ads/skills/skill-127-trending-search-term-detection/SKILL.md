---
name: skill-127-trending-search-term-detection
description: "Track week-over-week search query volume shifts to identify emerging opportunities and declining terms."
allowed-tools: Read, Grep, Glob
---
# Skill 127: Trending Search Term Detection

## Purpose

Analyze search term data across time periods to identify rising trends (opportunities to add as keywords), declining terms (investigate relevance), and new emerging queries worth capturing.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Recent search terms

**GAQL Query (for trend analysis):**
```sql
SELECT
  search_term_view.search_term,
  campaign.name,
  ad_group.name,
  segments.date,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_14_DAYS
  AND metrics.impressions > 0
ORDER BY search_term_view.search_term, segments.date
```
Run via `/google-ads-get-custom` with query name `search_term_trends`.

## Analysis Steps

1. **Fetch multi-period data:** Get search term data segmented by date for trend analysis
2. **Calculate week-over-week changes:** Compare this week vs last week impressions/clicks
3. **Identify rising trends:** Terms with >50% impression increase
4. **Flag declining terms:** Terms with >30% impression decrease
5. **Spot new terms:** First-time appearances with conversion potential

## Thresholds

| Condition | Severity |
|-----------|----------|
| New term with conversion, not added as keyword | Critical |
| Rising term (>100% increase) with good CTR | Warning |
| Declining term (>50% drop) with high spend | Warning |
| High-volume term not in keyword list | Info |

## Output

**Short format (default):**
```
## Search Term Trends Audit

**Account:** [Name] | **Period:** Last 14 days | **Trending Terms:** [X]

### Rising Trends - Add as Keywords ([Count])
- **"[Term]"**: +[X]% impressions, [Y] conversions → Add as [match type]
- **"[Term]"**: +[X]% impressions, high CTR → Add as exact match

### New High-Potential Terms ([Count])
- **"[Term]"**: First appearance, [X] conversions → Add immediately

### Declining Terms - Investigate ([Count])
- **"[Term]"**: -[X]% impressions → Check relevance/seasonality

### Recommendations
1. Add [X] rising terms as keywords
2. Investigate [Y] declining terms
3. Monitor [Z] new terms for patterns
```

**Detailed adds:**
- Full trending terms table with metrics
- Week-by-week volume comparison
- Seasonal pattern identification
- Keyword addition recommendations with match types
