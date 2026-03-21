---
name: skill-051-bid-simulator-analysis-target-changes
description: "Use bid simulators to model the impact of Target CPA or Target ROAS changes before implementing them."
allowed-tools: Read, Grep, Glob
---
# Skill 051: Bid Simulator Analysis for Target Changes

## Purpose

Bid simulators provide data-driven projections for target changes, showing trade-offs between volume and efficiency. This skill leverages simulator data to evaluate proposed target changes, quantify opportunity cost of current targets, and find optimal efficiency/volume balance.

## Data Requirements

**Data Source:** Custom GAQL Required

Bid simulator data is not included in the standard export.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Current target settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Current performance

**GAQL Queries:**

**Target CPA Simulator:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign_simulation.type,
  campaign_simulation.modification_method,
  campaign_simulation.start_date,
  campaign_simulation.end_date,
  campaign_simulation.target_cpa_point_list.points
FROM campaign_simulation
WHERE campaign_simulation.type = 'TARGET_CPA'
  AND campaign.status = 'ENABLED'
```

**Target ROAS Simulator:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign_simulation.type,
  campaign_simulation.target_roas_point_list.points
FROM campaign_simulation
WHERE campaign_simulation.type = 'TARGET_ROAS'
  AND campaign.status = 'ENABLED'
```
Run via `/google-ads:get-custom` with query names `cpa_simulator` and `roas_simulator`.

## Analysis Steps

1. **Retrieve simulator data:** Query bid simulators for campaigns using Target CPA, Target ROAS, or budget simulators.

2. **Parse simulation points:** Extract target value, estimated impressions, clicks, conversions, cost, conversion value per point.

3. **Analyze trade-off curves:** Plot conversions vs target CPA, ROAS achieved vs target ROAS, marginal CPA for each increment.

4. **Identify optimal points:** Find targets that maximize conversions within efficiency constraints and align with business objectives.

5. **Compare current vs optimal:** Calculate additional conversions/revenue, cost change, efficiency change.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Marginal CPA <current average CPA (scale opportunity) | Critical |
| Simulator shows 20%+ more conv at same CPA | High |
| Simulator shows 20%+ efficiency gain possible | High |
| Marginal CPA >2x current CPA (diminishing returns) | Warning |
| No simulator data available | Info |
| Current target near optimal | Info |

## Output

**Short (default):**
```
## Bid Simulator Analysis

**Account:** [Name] | **Campaigns with Simulator Data:** [X]

### Scale Opportunities ([Count])
- **[Campaign]**: Current $[X] CPA, simulator shows +[Y] conv/week at $[Z] CPA → Raise target to $[Z]

### Efficiency Opportunities ([Count])
- **[Campaign]**: Can achieve same volume at [X]% lower ROAS target

### Recommendations
1. [Priority target change with projected impact]
2. [Secondary change]
```

**Detailed adds:**
- Campaign simulator availability table (campaign, strategy, simulator data, date, points)
- Target CPA simulator analysis table per campaign (target, est conv/week, est cost/week, actual CPA, vs current)
- Marginal analysis (change, additional conv, additional cost, marginal CPA)
- Target ROAS simulator analysis table
- Optimization recommendations (campaign, current, simulator optimal, change, projected impact)
