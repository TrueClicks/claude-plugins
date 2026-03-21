---
name: skill-113-proactive-negative-keyword-list-building
description: "Pre-build comprehensive negative keyword lists with common irrelevant terms to prevent wasted spend."
allowed-tools: Read, Grep, Glob
---
# Skill 113: Proactive Negative Keyword List Building

## Purpose
Pre-build comprehensive negative keyword lists with common irrelevant terms to prevent wasted spend before it occurs. Proactive negatives block waste from day one instead of waiting for search term reports.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/shared_negative_lists.md` - Existing shared negative lists
- `data/account/campaigns/*/negative_keywords.md` - Campaign-level negatives
- `data/account/campaigns/*/*/negative_keywords.md` - Ad group-level negatives
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search term reports

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  search_term_view.search_term,
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
Use `/google-ads:get-custom` for expanded search term analysis.

## Analysis Steps

1. **Review Existing Coverage:** Compile all negative keywords currently in use
2. **Identify Missing Universal Negatives:** Check for job/career, free/DIY, research, competitor terms
3. **Analyze Search Terms for Patterns:** Find high-impression/zero-conversion terms
4. **Generate Recommendations:** Organize by universal (account) vs. campaign-specific

## Thresholds

| Condition | Severity |
|-----------|----------|
| No shared negative lists in account | Critical |
| Missing job/career negatives | Warning |
| Missing free/DIY negatives | Warning |
| High-spend zero-conversion search terms | Warning |
| <50 negative keywords total | Info |

## Output

**Short (default):**
```
## Negative Keyword Coverage Audit
**Account:** [name] | **Shared Lists:** [count] | **Total Negatives:** [count] | **Gaps:** [count]

### Critical
- **No shared negative lists** - Create universal negative list

### Warnings
- **Missing job/career negatives** - Add: jobs, careers, salary, hiring
- **Missing free/DIY negatives** - Add: free, tutorial, how to, DIY

### Search Term Findings
- **[count] zero-conversion terms** with $[amount] spend - Add as negatives

### Recommendations
1. Create "Universal Negatives" shared list with [count] terms
2. Add [count] search terms as campaign negatives
3. Estimated monthly savings: $[amount]
```

**Detailed adds:**
- Missing universal negatives by category
- Search term analysis with recommendations
- Negative keyword list with match types
- Campaign-specific vs. account-level classification
