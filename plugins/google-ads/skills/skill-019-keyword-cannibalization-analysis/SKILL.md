---
name: skill-019-keyword-cannibalization-analysis
description: "Detect when multiple keywords within the account compete for the same search queries, leading to internal auction competition and suboptimal ad serving."
allowed-tools: Read, Grep, Glob
---
# Skill 019: Keyword Cannibalization Analysis

## Purpose
Detect when multiple keywords within the account compete for the same search queries, leading to internal auction competition and suboptimal ad serving. Cannibalization splits impressions and routes traffic to lower-performing keywords.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search query data with matched keyword
- `data/account/campaigns/*/*/keywords.md` - Keyword settings and match types
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  search_term_view.search_term,
  segments.keyword.info.text,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Use `/google-ads:get-custom` if you need different date ranges.

## Analysis Steps

1. **Map search terms to keywords:** For each search term, identify which keyword/ad group triggered it
2. **Identify multi-trigger terms:** Find search terms appearing in multiple ad groups or campaigns
3. **Analyze keyword overlap:** Compare match types, Quality Scores, and performance of cannibalizing keywords
4. **Calculate impact:** Total impressions split, potential CPA improvement if consolidated
5. **Determine root cause:** Overlapping match types, similar keywords without negatives, poor ad group structure

## Thresholds

| Condition | Severity |
|-----------|----------|
| Search term appears in 3+ ad groups | Critical |
| Low-QS keyword winning over high-QS | Critical |
| High-CPA keyword getting 50%+ impressions | Warning |
| Broad match stealing from exact match | Warning |
| Cross-campaign overlap | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Cannibalization Analysis Audit
**Account:** [Name] | **Overlapping Terms:** [X] | **Issues:** [Y]

### Critical ([Count])
- **"[search term]"**: Triggers [X] keywords, low-QS variant winning → Add cross-negatives
- **[Keyword A] vs [Keyword B]**: [X]% overlap, wrong keyword winning → Route to best performer

### Warnings ([Count])
- **Broad match cannibalization**: "[broad]" stealing from "[exact]" → Add negative to broad ad group

### Recommendations
1. Add cross-negatives for [X] keyword pairs
2. Consolidate overlapping ad groups
```

**Detailed** adds:
- What Was Checked (search term mapping, overlap analysis)
- Multi-trigger terms table (Search Term, Keyword 1, Location, Conv, Keyword 2, Location, Conv)
- Cannibalization pairs table (Keyword A, Match, QS, CPA, Keyword B, Match, QS, CPA, Overlap %)
- Resolution strategies (cross-negatives, consolidation, match type cleanup)
