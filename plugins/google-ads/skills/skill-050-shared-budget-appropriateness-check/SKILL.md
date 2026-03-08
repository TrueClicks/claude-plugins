---
name: skill-050-shared-budget-appropriateness-check
description: "Evaluate whether shared budgets are being used appropriately and not causing budget allocation issues."
allowed-tools: Read, Grep, Glob
---
# Skill 050: Shared Budget Appropriateness Check

## Purpose

Shared budgets pool spend across campaigns, which can simplify management but also cause uneven distribution, campaign starvation, or difficulty in performance analysis. This skill evaluates whether shared budgets are appropriate for grouped campaigns and identifies spend distribution issues.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/budgets.md` - Shared budgets and linked campaigns
- `data/account/campaigns/*/campaign.md` - Budget settings, shared budget IDs
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Campaign spend and conversions

**Reference GAQL:**
```sql
SELECT
  campaign_budget.id,
  campaign_budget.name,
  campaign_budget.amount_micros,
  campaign_budget.explicitly_shared,
  campaign_budget.reference_count,
  campaign.id,
  campaign.name,
  metrics.cost_micros,
  metrics.conversions,
  metrics.impressions
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND campaign_budget.explicitly_shared = TRUE
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` for shared budget reference counts.

## Analysis Steps

1. **Identify shared budgets:** Find all shared budgets with budget ID, name, daily amount, number of campaigns, campaign names/types.

2. **Analyze spend distribution:** Calculate each campaign's share of spend, identify dominant campaigns (>50%), identify starved campaigns (<10%), calculate concentration index.

3. **Assess campaign compatibility:** Same business objective? Similar CPA/ROAS? Complementary or competing? Different priority levels?

4. **Evaluate performance impact:** Are efficient campaigns constrained? Are inefficient campaigns getting too much share?

5. **Calculate separation impact:** Model individual budgets based on current performance, project impact on conversions.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Shared budget with different goals | Critical |
| Single campaign >60% of shared spend | High |
| Campaign <5% of shared spend | High |
| CPA range within shared >50% | Warning |
| >5 campaigns sharing budget | Warning |
| Concentration index (HHI) >0.40 | Warning |
| 2-3 campaigns evenly shared | Info |

## Output

**Short (default):**
```
## Shared Budget Audit

**Account:** [Name] | **Shared Budgets:** [X] | **Issues Found:** [Y]

### Critical ([Count])
- **[Budget]**: Different goals in same budget → Separate into [X] budgets

### High Priority ([Count])
- **[Budget]**: [Campaign] dominates ([X]%), starving [Campaign] at $[Y] CPA → Split budget

### Recommendations
1. [Priority separation action]
2. [Secondary action]
```

**Detailed adds:**
- Shared budget inventory (budget name, daily budget, campaigns, 30d spend, 30d conv, utilization)
- Spend distribution analysis per budget (campaign, 30d spend, % of budget, conv, CPA, status)
- Shared budget issues table (budget, issue, severity, impact)
- Campaign compatibility assessment (factors, assessment, score)
- Separation recommendations with proposed new budget structure and projected impact
