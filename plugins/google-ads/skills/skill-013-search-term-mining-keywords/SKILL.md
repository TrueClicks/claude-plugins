---
name: skill-013-search-term-mining-keywords
description: "Review search term reports to identify high-performing queries that are not yet added as keywords, representing opportunities for better control and optimization."
allowed-tools: Read, Grep, Glob
---
# Skill 013: Search Term Mining for New Keywords

## Purpose
Review search term reports to identify high-performing queries that are not yet added as keywords, representing opportunities for better control and optimization. Adding converting search terms as keywords provides bid control and enables tailored ad copy.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search query performance
- `data/account/campaigns/*/*/keywords.md` - Existing keywords to cross-reference

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  search_term_view.search_term,
  search_term_view.status,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Use `/google-ads-get-custom` if you need different date ranges or additional metrics.

## Analysis Steps

1. **Identify converting terms not added:** Filter for Status = "None" (not explicit keyword) with Conversions >= 1
2. **Find high-volume opportunities:** Status = "None", Conversions = 0, Clicks >= 10, CTR >= 2%
3. **Cross-reference existing keywords:** Check if close variant already exists as keyword
4. **Recommend match type:** High CPA risk → Exact; proven performer (3+ conv) → Phrase or Broad
5. **Group recommendations:** Organize by ad group fit and priority (conversion-based > volume-based)

## Thresholds

| Condition | Severity |
|-----------|----------|
| Conversions >= 3 AND Status = "None" | Critical |
| CPA <= Campaign Target CPA AND Status = "None" | Critical |
| Conversions >= 1 AND Status = "None" | Warning |
| Clicks >= 20 AND CTR >= 3% AND Conv = 0 | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Search Term Mining Audit
**Account:** [Name] | **Search Terms:** [X] | **Opportunities:** [Y]

### Critical ([Count])
- **"[search term]"**: [X] conversions at $[Y] CPA, not added → Add as [exact]
- **"[search term]"**: [X] conversions, triggering from broad match → Add as [exact]

### Warnings ([Count])
- **"[search term]"**: 1-2 conversions, worth capturing → Add as [exact]

### Recommendations
1. Add [X] converting search terms as keywords
2. Estimated additional control: [Y]% of converting queries
```

**Detailed** adds:
- What Was Checked (search term status, conversion data)
- Top converting terms table (Term, Ad Group, Clicks, Conv, CPA, Status, Recommendation)
- High-volume opportunity table (Term, Impressions, Clicks, CTR, Cost)
- Summary statistics (total analyzed, terms not added, potential new keywords)
