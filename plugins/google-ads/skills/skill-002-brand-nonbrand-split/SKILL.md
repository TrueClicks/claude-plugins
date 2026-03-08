---
name: skill-002-brand-nonbrand-split
description: "Ensure branded and non-branded keywords live in separate campaigns with independent budgets and targets."
allowed-tools: Read, Grep, Glob
---
# Skill 002: Brand vs. Non-Brand Campaign Split

## Purpose
Ensure branded and non-branded keywords live in separate campaigns with independent budgets and targets. Branded terms inflate CTR and conversion metrics, masking true acquisition performance and distorting Smart Bidding signals.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign names and settings
- `data/account/campaigns/*/*/keywords.md` - All keywords with match types
- `data/account/campaigns/*/negative_keywords.md` - Campaign negative keywords
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Search queries
- `data/account/account_summary.md` - Brand name identification

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` if you need different date ranges or to include search term data.

## Analysis Steps

1. **Identify brand terms:** Extract brand name from account summary; generate variations including misspellings and abbreviations
2. **Classify keywords:** Scan all keywords.md files and categorize each as Brand, Non-Brand, or Competitor
3. **Check campaign separation:** Flag campaigns containing BOTH brand and non-brand keywords
4. **Analyze search term leakage:** Find brand searches triggering non-brand campaigns and vice versa
5. **Evaluate negative protection:** Check if non-brand campaigns have brand terms as negatives

## Thresholds

| Condition | Severity |
|-----------|----------|
| Mixed brand/non-brand keywords in same campaign | Critical |
| Brand search terms in non-brand campaigns (>5% of traffic) | Warning |
| No brand negatives in non-brand campaigns | Warning |
| Brand campaign without "brand" in name | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Brand/Non-Brand Split Audit
**Account:** [Name] | **Analyzed:** [X] campaigns, [Y] keywords | **Issues:** [Z]

### Critical ([Count])
- **[Campaign]**: Mixed brand + non-brand keywords → Split into separate campaigns

### Warnings ([Count])
- **[Campaign]**: Brand search term leakage ([X]% of traffic) → Add brand negatives

### Recommendations
1. Create dedicated "Brand - Search" campaign
2. Add brand terms as exact match negatives to non-brand campaigns
```

**Detailed** adds:
- What Was Checked (brand variations, campaign structure, search term analysis)
- Impact and evidence for each issue (cost on leaked traffic, keyword counts)
- Summary table with campaign classifications
