---
name: skill-133-impression-share-loss-analysis
description: "Segment impression share loss into budget vs rank causes to identify the right optimization strategy."
allowed-tools: Read, Grep, Glob
---
# Skill 133: Impression Share Loss Analysis by Cause

## Purpose

Segment impression share loss between budget constraints and ad rank issues to determine whether campaigns need more budget, better Quality Scores, or higher bids. This prioritization prevents wasting optimization effort on the wrong problem.

## Data Requirements

**Data Source:** Custom GAQL Required

Impression share loss metrics require custom GAQL queries.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.status,
  metrics.impressions,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share,
  metrics.search_top_impression_share,
  metrics.search_absolute_top_impression_share,
  metrics.cost_micros
FROM campaign
WHERE campaign.advertising_channel_type = 'SEARCH'
  AND campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `impression_share_loss`.

## Analysis Steps

1. **Fetch IS loss data:** Run GAQL query for impression share metrics
2. **Calculate total lost IS:** Sum budget lost + rank lost for each campaign
3. **Categorize campaigns:** Budget-constrained (>15% budget loss), Rank-constrained (>15% rank loss), Both, or Optimized
4. **Estimate opportunity:** Calculate potential impressions from recovered IS
5. **Diagnose root causes:** For rank loss, check QS; for budget loss, check exhaustion patterns

## Thresholds

| Condition | Severity |
|-----------|----------|
| Budget Lost IS > 20% on profitable campaign | Critical |
| Rank Lost IS > 30% | Critical |
| Both budget and rank > 15% each | Warning |
| Any IS loss > 10% | Info |

## Output

**Short format (default):**
```
## Impression Share Loss Audit

**Account:** [Name] | **Avg Search IS:** [X]% | **Campaigns with Issues:** [Y]

### Loss Summary
| Loss Type | Campaigns | Avg Loss |
|-----------|-----------|----------|
| Budget-Constrained | [X] | [Y]% |
| Rank-Constrained | [X] | [Y]% |
| Both | [X] | [Y]% |
| Well-Optimized | [X] | <10% |

### Budget-Constrained Campaigns
- **[Campaign]**: [X]% lost to budget → Increase budget by $[Y]/day

### Rank-Constrained Campaigns
- **[Campaign]**: [X]% lost to rank, avg QS [Y] → Improve QS

### Recommendations
1. Address rank issues first (more efficient)
2. Increase budgets on [X] campaigns after rank improvements
```

**Detailed adds:**
- Campaign-by-campaign breakdown
- Opportunity cost calculations
- QS analysis for rank-constrained campaigns
- Budget increase recommendations with ROI estimates
