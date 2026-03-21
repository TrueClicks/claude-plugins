---
name: skill-043-daily-budget-to-cpa-ratio-check
description: "Verify that campaign daily budgets are 5-10x the target or actual CPA to ensure Smart Bidding can optimize effectively."
allowed-tools: Read, Grep, Glob
---
# Skill 043: Daily Budget-to-CPA Ratio Check

## Purpose

Smart Bidding algorithms need sufficient daily budget to test bids, gather conversion data, and optimize effectively. Google recommends daily budgets of at least 5-10x the target CPA. This skill identifies campaigns with budget-to-CPA ratios below recommended thresholds and provides budget adjustment recommendations.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Budget, Target CPA, bidding strategy
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Actual CPA, conversions, spend

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign_budget.amount_micros,
  campaign.bidding_strategy_type,
  campaign.target_cpa.target_cpa_micros,
  metrics.cost_micros,
  metrics.conversions,
  metrics.average_cpc,
  campaign.status
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need target CPA values not in standard export.

## Analysis Steps

1. **Calculate budget-to-CPA ratios:** Using Target CPA: Ratio = Daily Budget / Target CPA. Using Actual CPA: Ratio = Daily Budget / (30-day Cost / 30-day Conversions).

2. **Apply ratio thresholds:** <2x = Critical (severely constrained), 2-5x = Low (limited optimization), 5-10x = Adequate, 10-20x = Good, >20x = Excellent.

3. **Assess Smart Bidding eligibility:** Cross-reference ratio with bidding strategy type and conversion volume.

4. **Identify ROAS equivalent issues:** For Target ROAS campaigns, check budget supports 5-10 conversions/day at target efficiency.

5. **Calculate recommended budgets:** Minimum = CPA * 5, Recommended = CPA * 10.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ratio <2x + Smart Bidding | Critical |
| Ratio 2-3x + Smart Bidding | High |
| Ratio 3-5x + Smart Bidding | Warning |
| Conv/day <1 at current budget | Warning |
| Ratio <5x + Manual CPC | Info |
| Ratio >20x + low spend | Info |

## Output

**Short (default):**
```
## Budget-to-CPA Ratio Audit

**Account:** [Name] | **Campaigns Analyzed:** [X] | **Below 5x Threshold:** [Y]

### Critical ([Count])
- **[Campaign]**: [X]x ratio ($[Budget] / $[CPA]) → Increase to $[Recommended]/day (5x)

### Warnings ([Count])
- **[Campaign]**: [X]x ratio, [Y] conv/day capacity → Consider budget increase

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Budget-to-CPA ratio table with budget, target CPA, actual CPA, ratio (target), ratio (actual), status
- Campaigns below threshold with current ratio, minimum recommended, budget gap
- Daily conversion capacity analysis per campaign
- Budget recommendations with estimated additional conversions
