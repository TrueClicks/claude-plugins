---
name: skill-040-target-cpa-roas-realism-check
description: "Verify that Target CPA and Target ROAS values are achievable based on historical performance."
allowed-tools: Read, Grep, Glob
---
# Skill 040: Target CPA/ROAS Realism Check

## Purpose

Unrealistic bidding targets cause significant issues: too aggressive targets lose auctions and volume drops; too conservative targets cause overspending and inefficiency. This skill validates whether current targets match historical performance and identifies campaigns where targets are limiting volume or wasting budget.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Target CPA, Target ROAS settings
- `data/account/bidding_strategies.md` - Portfolio strategy targets
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Actual CPA, ROAS achieved

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.bidding_strategy_type,
  campaign.target_cpa.target_cpa_micros,
  campaign.target_roas.target_roas,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value,
  segments.date
FROM campaign
WHERE segments.date BETWEEN '{start_date}' AND '{end_date}'
  AND campaign.status = 'ENABLED'
```
Use `/google-ads-get-custom` for trend analysis over longer periods. Replace `{start_date}` and `{end_date}` with actual dates (e.g., 90-day window). Note: `LAST_90_DAYS` is not a valid GAQL date range; use `BETWEEN` with explicit dates instead.

## Analysis Steps

1. **Extract current targets:** Target CPA or Target ROAS for each campaign
2. **Calculate historical actuals:** 30-day actual CPA/ROAS, 14-day trend, 7-day immediate trend
3. **Compare targets vs actuals:** Target within +/-10% = aligned, 20-30% below = aggressive, >30% below = unrealistic
4. **Assess volume impact:** Check budget utilization, declining conversions, stuck learning
5. **Calculate recommended targets:** Based on recent performance, weighted toward recent data

## Thresholds

| Condition | Severity |
|-----------|----------|
| Target >30% below actual | Critical (unrealistic) |
| Budget utilization <50% + aggressive target | Critical |
| Target 20-30% below actual | Warning (aggressive) |
| Target >30% above actual | Warning (over-conservative) |
| Target within 10% of actual | Info (well-calibrated) |

## Output

**Short (default):**
```
## Target Realism Audit
**Account:** [Name] | **Campaigns with Targets:** [X] | **Misaligned:** [Y]

### Critical ([Count])
- **[Campaign]**: Target CPA $[X] vs actual $[Y] ([Z]% gap), [W]% budget used -> Increase to $[Rec]

### Warnings ([Count])
- **[Campaign]**: Target ROAS [X]% vs actual [Y]% -> Adjust to [Rec]%

### Target vs Actual
| Campaign | Target | 30d Actual | Variance | Budget Used | Status |
|----------|--------|------------|----------|-------------|--------|

### Recommendations
1. [Priority action with expected impact]
```

**Detailed adds:**
- Trend analysis (7d, 14d, 30d actuals)
- Budget utilization impact analysis
- Specific target adjustment recommendations with rationale
