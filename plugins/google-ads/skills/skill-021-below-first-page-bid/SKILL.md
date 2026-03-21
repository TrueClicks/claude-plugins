---
name: skill-021-below-first-page-bid
description: "Flag keywords with bids too low to appear on the first page of search results."
allowed-tools: Read, Grep, Glob
---
# Skill 021: Below-First-Page Bid Identification

## Purpose

Identify keywords where low bids are limiting visibility and performance. Keywords with very low impressions combined with good Quality Scores indicate bid-related issues rather than quality issues. Fixing these can unlock significant additional traffic.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword bids and Quality Score
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Impressions and performance
- `data/account/campaigns/*/campaign.md` - Campaign bidding strategy

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.cpc_bid_micros,
  ad_group_criterion.quality_info.quality_score,
  metrics.impressions,
  metrics.average_cpc
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need impression share metrics for more accurate diagnosis.

## Analysis Steps

1. **Identify low-impression keywords:** Flag keywords with <100 impressions in 30 days or significantly below ad group average
2. **Analyze bid vs Quality Score:** For low-impression keywords, check if QS is reasonable (5+) - suggests bid issue, not quality
3. **Calculate Ad Rank proxy:** Compare Bid x QS across keywords in same ad group to find under-bidders
4. **Estimate bid adjustment needed:** Use average CPC of performing keywords as benchmark (first-page estimate ~1.5-2x avg CPC)
5. **Prioritize by opportunity:** Rank by QS (higher = more impact) and strategic importance

## Thresholds

| Condition | Severity |
|-----------|----------|
| Impressions < 50 AND QS >= 7 | Critical |
| Impressions < 100 AND QS >= 5 | Warning |
| Bid < 50% of ad group avg CPC AND QS >= 6 | Critical |
| Impressions < 200 AND QS < 5 | Info (quality issue) |

## Output

**Short (default):**
```
## Below-First-Page Bid Audit
**Account:** [Name] | **Analyzed:** [X] keywords | **Issues:** [Y]

### Critical ([Count])
- **[Keyword]** (QS [X]): [Y] impressions, bid $[Z] vs $[A] avg CPC -> Increase to $[B]

### Warnings ([Count])
- **[Keyword]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action with estimated impact]
```

**Detailed adds:**
- Bid vs QS analysis table by ad group
- Estimated additional impressions from fixes
- Breakdown by Manual CPC vs Smart Bidding campaigns
