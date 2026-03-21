---
name: skill-121-impression-share-lost-analysis
description: "Distinguish between impression share lost due to budget constraints versus ad rank issues to prioritize optimization efforts."
allowed-tools: Read, Grep, Glob
---
# Skill 121: Impression Share Lost Analysis

## Purpose

Analyze impression share loss to distinguish between budget-constrained campaigns (need more budget) and rank-constrained campaigns (need better Quality Score or bids). This prioritization ensures optimization efforts target the right root cause.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include competitive impression share metrics.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.id,
  campaign.status,
  campaign_budget.amount_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share,
  metrics.search_top_impression_share,
  metrics.search_absolute_top_impression_share
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND campaign.advertising_channel_type = 'SEARCH'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `impression_share_loss`.

## Analysis Steps

1. **Fetch impression share data:** Run custom GAQL query to get IS metrics by campaign
2. **Categorize campaigns:** Group by primary loss cause (Budget >10%, Rank >20%, Both, or Optimized)
3. **Calculate opportunity cost:** Estimate missed impressions, clicks, and conversions from lost IS
4. **Diagnose root causes:** For budget loss, check exhaustion time; for rank loss, check Quality Scores
5. **Prioritize recommendations:** Rank by potential recovery value and effort required

## Thresholds

| Condition | Severity |
|-----------|----------|
| Budget Lost IS > 20% on profitable campaign | Critical |
| Rank Lost IS > 30% | Critical |
| Budget Lost IS > 10% | Warning |
| Rank Lost IS > 20% | Warning |
| Either metric > 5% but < 10% | Info |

## Output

**Short format (default):**
```
## Impression Share Loss Audit

**Account:** [Name] | **Campaigns:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]**: [X]% lost to budget, profitable CPA $[Y] → Increase budget by $[Z]/day
- **[Campaign]**: [X]% lost to rank, avg QS [Y] → Improve landing page experience

### Warnings ([Count])
- **[Campaign]**: [X]% lost to [cause] → [Fix]

### Recommendations
1. Increase budget on [campaigns] to capture $[X] in missed conversions
2. Address QS issues on [campaigns] losing [X]% to rank
```

**Detailed adds:**
- Campaign-by-campaign IS breakdown table
- Opportunity cost calculations (missed impressions, clicks, conversions)
- Root cause analysis for rank-constrained campaigns
- Budget reallocation suggestions between campaigns
