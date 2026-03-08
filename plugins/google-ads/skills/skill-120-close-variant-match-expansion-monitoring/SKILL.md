---
name: skill-120-close-variant-match-expansion-monitoring
description: "Monitor search queries triggered by close variants and 'same meaning' expansions to identify irrelevant traffic."
allowed-tools: Read, Grep, Glob
---
# Skill 120: Close Variant Match Expansion Monitoring

## Purpose
Monitor search queries triggered by close variants and "same meaning" expansions. Google's match type expansions can trigger irrelevant queries that waste budget despite using exact or phrase match.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keywords with match types
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search term reports

**Reference GAQL:**
```sql
SELECT
  search_term_view.search_term,
  segments.keyword.info.text,
  segments.keyword.info.match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.clicks > 0
ORDER BY metrics.cost_micros DESC
LIMIT 5000
```
Use `/google-ads-get-custom` for expanded analysis.

## Analysis Steps

1. **Map Keywords to Search Terms:** Create keyword-to-search-term mappings
2. **Identify Close Variants:** Find search terms that don't exactly match keywords
3. **Categorize Variant Quality:** Good (misspellings), questionable (reordering), bad (different meaning)
4. **Calculate Variant Impact:** Compare exact query vs. variant conversion rates

## Thresholds

| Condition | Severity |
|-----------|----------|
| Zero-conversion variants with >$50 spend | Critical |
| "Same meaning" variants with different intent | Warning |
| Variant conversion rate <50% of exact match | Warning |
| >50% of clicks from variants (exact match keywords) | Info |

## Output

**Short (default):**
```
## Close Variant Expansion Analysis
**Account:** [name] | **Keywords:** [count] | **Search Terms:** [count]

### Match Analysis
| Type | Conv Rate | CPA |
|------|-----------|-----|
| Exact query match | [%] | $[amount] |
| Close variants | [%] | $[amount] |

### Problematic Variants
| Keyword | Search Term Triggered | Issue | Spend |
|---------|----------------------|-------|-------|
| [keyword] | [query] | Same meaning mismatch | $[amount] |

### Recommendations
1. Add [count] problematic variants as exact match negatives
2. Move high-value keywords to exact match
3. Build proactive negative list for common mismatches
```

**Detailed adds:**
- Variant type breakdown (misspelling, reordering, synonym, paraphrase)
- Keyword-level variant analysis
- Performance comparison by variant type
- Common same-meaning mismatches to watch
