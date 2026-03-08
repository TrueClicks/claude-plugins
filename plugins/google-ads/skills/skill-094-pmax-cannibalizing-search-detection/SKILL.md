---
name: skill-094-pmax-cannibalizing-search-detection
description: "Monitor for search query overlap between Performance Max and standard Search campaigns."
allowed-tools: Read, Grep, Glob
---
# Skill 094: Performance Max Cannibalizing Search Detection

## Purpose
Monitor for search query overlap between Performance Max and standard Search campaigns. PMax can cannibalize branded and high-value search traffic, reducing control and potentially increasing costs on proven Search campaigns.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query - Search Terms (Standard Search):**
```sql
SELECT
  campaign.name,
  campaign.id,
  ad_group.name,
  search_term_view.search_term,
  segments.search_term_match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM search_term_view
WHERE campaign.advertising_channel_type = 'SEARCH'
  AND segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 10
ORDER BY metrics.impressions DESC
LIMIT 5000
```

**GAQL Query - Campaign Performance Comparison:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.ad_network_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.search_impression_share,
  metrics.search_exact_match_impression_share
FROM campaign
WHERE campaign.advertising_channel_type IN ('SEARCH', 'PERFORMANCE_MAX')
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads-get-custom` with query name `pmax_cannibalization`.

**Standard Data:**
- `data/performance/campaigns/*/search_terms_metrics_30_days.md` - Search term reports

## Analysis Steps

1. **Compare Campaign Volumes:** Track Search impressions on Search vs. PMax campaigns over time
2. **Analyze Search Performance Shifts:** Monitor impression share changes, brand term performance
3. **Identify Overlap Signals:** Brand query performance, high-converting keyword trends
4. **Assess Impact:** Cost efficiency changes, conversion attribution shifts

## Thresholds

| Condition | Severity |
|-----------|----------|
| Brand Search impression share drop >10% | Critical |
| PMax consuming >40% brand queries | Critical |
| Search campaign CPC increase >20% | Warning |
| Search conversions drop (brand) >15% | Warning |
| No brand exclusions in PMax | Info |

## Output

**Short (default):**
```
## PMax Search Cannibalization Analysis
**Account:** [name] | **Brand Search IS:** [%] | **PMax Search %:** [%] | **Issues:** [count]

### Critical
- **Brand Search IS dropped [%]** (from [%] to [%]) - PMax taking brand traffic
- **Brand CPC increased [%]** - Internal competition

### Warnings
- **No brand exclusions in PMax** - Add brand terms as negatives
- **Search conversions down [%]** - Attribution shifting to PMax

### Recommendations
1. Add brand exclusions to PMax: [brand], [brand + product]
2. Monitor brand IS weekly - target >95%
3. Consider separate brand PMax campaign if needed
```

**Detailed adds:**
- Search volume distribution table (Search vs. PMax)
- Brand term impression share trend
- CPA comparison by campaign type
- High-value term protection status
