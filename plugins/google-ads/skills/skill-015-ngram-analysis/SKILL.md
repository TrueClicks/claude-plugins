---
name: skill-015-ngram-analysis
description: "Analyze 1-word, 2-word, and 3-word combinations (n-grams) within search terms to identify systemic patterns of waste or opportunity."
allowed-tools: Read, Grep, Glob
---
# Skill 015: N-gram Analysis for Search Term Patterns

## Purpose
Analyze 1-word, 2-word, and 3-word combinations (n-grams) within search terms to identify systemic patterns of waste or opportunity. N-gram analysis reveals patterns invisible at the individual query level.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search query performance
- `data/account/campaigns/*/negative_keywords.md` - Existing negatives
- `data/account/shared_negative_lists.md` - Shared negative lists

**Reference GAQL:**
```sql
SELECT
  search_term_view.search_term,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
```
Use `/google-ads:get-custom` if you need different date ranges or additional metrics.

## Analysis Steps

1. **Extract n-grams:** Tokenize search terms into 1-grams, 2-grams, and 3-grams; normalize (lowercase, remove punctuation)
2. **Aggregate metrics:** For each n-gram, sum metrics from all containing search terms
3. **Identify waste patterns:** Flag n-grams with Cost >= $50 AND Conversions = 0, or appearing in 5+ zero-conversion terms
4. **Identify opportunity patterns:** Flag n-grams with Conv >= 3 AND CPA below target, or Conv Rate >= 5%
5. **Cross-reference negatives:** Check if wasteful n-grams already covered by existing negatives

## Thresholds

| Condition | Severity |
|-----------|----------|
| N-gram Cost >= $100 AND Conv = 0 | Critical |
| N-gram in 10+ terms AND Conv = 0 | Critical |
| N-gram Cost >= $50 AND Conv = 0 | Warning |
| N-gram Conv >= 5 AND CPA <= Target CPA | Info (opportunity) |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## N-gram Analysis Audit
**Account:** [Name] | **Search Terms:** [X] | **Patterns Found:** [Y]

### Critical ([Count])
- **"[n-gram]"**: $[X] spent across [Y] terms, 0 conversions → Add as phrase negative

### Warnings ([Count])
- **"[n-gram]"**: $[X] spent, 0 conversions → Add as phrase negative

### Opportunities ([Count])
- **"[n-gram]"**: [X] conversions at $[Y] CPA → Create dedicated ad group

### Recommendations
1. Add "[n-gram]" as negative (saves ~$[X]/month)
2. Create ad group for "[n-gram]" theme
```

**Detailed** adds:
- What Was Checked (n-gram extraction, aggregation method)
- Waste n-grams table (N-gram, Type, Terms, Cost, Conv, Recommendation)
- Opportunity n-grams table (N-gram, Type, Terms, Cost, Conv, CPA, Conv Rate)
- Statistical summary (unique 1/2/3-grams, with conversions, zero-conv high-spend)
