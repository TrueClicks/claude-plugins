---
name: skill-044-monthly-budget-pacing-analysis
description: "Track actual spend against monthly budget targets to identify pacing issues before month-end."
allowed-tools: Read, Grep, Glob
---
# Skill 044: Monthly Budget Pacing Analysis

## Purpose

Monthly budget management prevents overspend that exceeds limits and underspend that leaves opportunity on the table. This skill monitors current spend vs monthly targets, projects month-end spend, identifies campaigns trending over or under budget, and recommends corrective actions.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export provides aggregated 30-day data but not daily spend patterns needed for pacing analysis.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Daily budgets, settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Total spend (used for baseline)

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign_budget.amount_micros,
  metrics.cost_micros,
  segments.date
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING THIS_MONTH
ORDER BY segments.date
```
Run via `/google-ads-get-custom` with query name `monthly_pacing`.

## Analysis Steps

1. **Establish monthly targets:** Monthly target = Daily budget * Days in month (or explicit monthly budget if provided).

2. **Calculate current pacing:** Days elapsed, expected spend % = Days elapsed / Total days, actual spend %, pacing ratio = Actual % / Expected %.

3. **Assess pacing status:** >1.15 = Overpacing, 0.95-1.05 = On pace, <0.85 = Significantly underpacing.

4. **Project month-end spend:** Linear projection and trailing 7-day average projection.

5. **Identify variance causes:** Budget changes, bid strategy changes, seasonality, competition changes, impression share losses.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Pacing ratio <0.80 | Critical |
| Pacing ratio >1.20 | Critical |
| Projected overspend >10% | High |
| Projected underspend >15% | High |
| Pacing ratio 0.80-0.90 | Warning |
| Pacing ratio 1.10-1.20 | Warning |
| Daily spend declining trend (7 days) | Warning |
| Pacing ratio 0.90-1.10 | Info |

## Output

**Short (default):**
```
## Monthly Budget Pacing Audit

**Account:** [Name] | **Day [X] of [Y]** | **Pacing:** [Z]%

### Critical ([Count])
- **[Campaign]**: [X]% pacing, projected $[Y] vs $[Z] target → [Action]

### Warnings ([Count])
- **[Campaign]**: [X]% pacing, declining trend → Monitor/investigate

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Account-level pacing summary table (target, spend to date, expected, pacing ratio, projected month-end)
- Campaign-level pacing table with monthly target, spend to date, expected %, pacing %, projected, status
- Daily spend trend (last 7 days) per campaign with trend direction
- Month-end projection scenarios (current pace, if fixed, aggressive)
