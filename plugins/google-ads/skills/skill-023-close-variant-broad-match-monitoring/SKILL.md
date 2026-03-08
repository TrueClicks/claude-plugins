---
name: skill-023-close-variant-broad-match-monitoring
description: "Review search queries triggered by broad and phrase match keywords to identify irrelevant matches and negative keyword opportunities."
allowed-tools: Read, Grep, Glob
---
# Skill 023: Close Variant and Broad Match Query Monitoring

## Purpose

Monitor query expansion to ensure broad and phrase match keywords trigger relevant queries. Identify queries that waste budget on irrelevant traffic and high-performing queries that should be added as keywords for better control.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Actual queries with performance
- `data/account/campaigns/*/*/keywords.md` - Keywords with match types
- `data/account/campaigns/*/negative_keywords.md` - Existing campaign negatives
- `data/account/campaigns/*/*/negative_keywords.md` - Ad group negatives

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  search_term_view.search_term,
  search_term_view.status,
  segments.keyword.info.text,
  segments.keyword.info.match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` for different date ranges or to filter by specific campaigns.

## Analysis Steps

1. **Map keywords to search terms:** Group search terms by the keyword that triggered them
2. **Calculate expansion metrics:** Unique queries per keyword, relevance distribution
3. **Evaluate query relevance:** Categorize as high relevance (clear match), medium (related), low (tangential), irrelevant (no connection)
4. **Identify action items:** High-converting queries to add as keywords, irrelevant high-spend queries to negative, keywords with >50% irrelevant expansion
5. **Assess performance by query type:** Compare CPA/conversion rates of close variants vs expanded queries

## Thresholds

| Condition | Severity |
|-----------|----------|
| Irrelevant query, Cost >= $50, Conv = 0 | Critical |
| Keyword triggers 50%+ irrelevant queries | Critical |
| High-converting query not added as keyword | Warning |
| Broad match triggers 30+ unique queries | Info |

## Output

**Short (default):**
```
## Query Expansion Audit
**Account:** [Name] | **Queries:** [X] | **Issues:** [Y]

### Add as Negatives ([Count])
- **"[query]"** from [keyword]: $[X] cost, 0 conv -> Add as [match] negative

### Add as Keywords ([Count])
- **"[query]"**: [X] conv at $[Y] CPA -> Add as exact match

### Keywords to Narrow ([Count])
- **[keyword]** (broad): [X]% irrelevant queries -> Convert to phrase

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Query expansion summary by match type
- Full table of queries requiring action with triggering keyword
- Relevance score breakdown and waste analysis
