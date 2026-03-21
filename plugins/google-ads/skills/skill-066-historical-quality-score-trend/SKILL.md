---
name: skill-066-historical-quality-score-trend
description: "Identify trending Quality Score degradation by comparing current QS to historical baselines."
allowed-tools: Read, Grep, Glob
---
# Skill 066: Historical Quality Score Trend

## Purpose
Identify trending Quality Score degradation by comparing current QS to historical baselines. Declining QS indicates worsening ad relevance, landing page issues, or competitive pressure that needs attention.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export provides current QS but not historical snapshots. Google Ads does not store historical QS by default.

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Current Quality Score data

**GAQL Query (Current State):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.search_predicted_ctr,
  ad_group_criterion.quality_info.creative_quality_score,
  ad_group_criterion.quality_info.post_click_quality_score,
  metrics.impressions,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND campaign.status = 'ENABLED'
  AND metrics.impressions > 0
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `quality_score_current`.

Note: Historical QS tracking requires external snapshots (Google Ads scripts) since Google does not store QS history.

## Analysis Steps

1. **Establish current baseline:** Calculate weighted average QS and distribution by bucket.
2. **Compare to historical data:** If snapshots available, calculate QS change over time.
3. **Flag declining keywords:** Keywords with QS decline >= 2 points are priority issues.
4. **Investigate systematic declines:** Look for patterns (same ad group, landing page, match type).

## Thresholds

| Condition | Severity |
|-----------|----------|
| Weighted QS dropped >1 point in 30 days | Critical |
| 5+ keywords dropped QS by 2+ points | Critical |
| Landing Page component declined account-wide | Critical |
| Any QS 8-10 dropped to 6 or below | Warning |
| Expected CTR trending down across keywords | Warning |
| Single keyword QS dropped 3+ points | Warning |

## Output

**Short (default):**
```
## Quality Score Trend Audit

**Account:** [Name] | **Keywords Analyzed:** [X] | **Declining:** [Y]

### Current State
- Weighted Avg QS: [X.X]
- % Keywords QS 6+: [X]%

### Critical ([Count])
- **[Keyword]**: QS dropped from [X] to [Y] -> Investigate [component]

### Warnings ([Count])
- **[Keyword]**: [Trend issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- QS distribution trend over time (if historical data available)
- Component trend analysis
- Systematic decline patterns
- Investigation checklist
