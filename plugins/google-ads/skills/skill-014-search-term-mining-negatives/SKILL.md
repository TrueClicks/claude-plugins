---
name: skill-014-search-term-mining-negatives
description: "Identify irrelevant, wasteful, or poor-performing search queries that should be added as negative keywords to prevent future spend waste."
allowed-tools: Read, Grep, Glob
---
# Skill 014: Search Term Mining for Negative Keywords

## Purpose
Identify irrelevant, wasteful, or poor-performing search queries that should be added as negative keywords to prevent future spend waste. Proactive negative keyword management reclaims budget for better-performing queries.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search query performance
- `data/account/campaigns/*/negative_keywords.md` - Existing campaign negatives
- `data/account/campaigns/*/*/negative_keywords.md` - Existing ad group negatives
- `data/account/shared_negative_lists.md` - Shared negative keyword lists
- `data/account/campaigns/*/*/keywords.md` - Active keywords (to avoid conflicts)

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
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.cost_micros > 0
```
Use `/google-ads:get-custom` if you need different date ranges.

## Analysis Steps

1. **Find high-spend zero-conversion terms:** Filter Conversions = 0, Cost >= 2x target CPA or $20 minimum
2. **Identify low-engagement terms:** CTR < 1% AND Impressions >= 100 OR Clicks >= 10 AND Conv = 0
3. **Detect waste patterns:** Scan for "jobs", "free", "how to", "login", "support", competitor research terms
4. **Check against existing negatives:** Verify candidates not already blocked
5. **Recommend negative level:** Account-wide patterns → shared list; campaign-specific → campaign negative

## Thresholds

| Condition | Severity |
|-----------|----------|
| Cost >= 3x Target CPA AND Conv = 0 | Critical |
| Cost >= 2x Target CPA AND Conv = 0 | Warning |
| Clicks >= 20 AND Conv = 0 AND CTR < 1% | Warning |
| Contains waste pattern ("free", "jobs") AND Conv = 0 | Warning |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Negative Keyword Mining Audit
**Account:** [Name] | **Search Terms:** [X] | **Negatives Needed:** [Y]

### Critical ([Count])
- **"[search term]"**: $[X] spent, 0 conversions → Add as [phrase] negative

### Warnings ([Count])
- **"[pattern]" pattern**: [X] terms, $[Y] wasted → Add "[pattern]" to shared negative list

### Recommendations
1. Add [X] negative keywords (saves ~$[Y]/month)
2. Create shared list for "[pattern]" terms
```

**Detailed** adds:
- What Was Checked (spend thresholds, waste patterns)
- High-spend zero-conversion table (Term, Campaign, Cost, Clicks, CTR, Recommendation)
- Waste pattern summary (Pattern, Terms Found, Total Cost, Action)
- Recommended negatives list (Keyword, Match Type, Level, Wasted Spend)
