---
name: skill-077-data-driven-attribution
description: "Verify that Data-Driven Attribution (DDA) is enabled for all eligible conversion actions."
allowed-tools: Read, Grep, Glob
---
# Skill 077: Data-Driven Attribution

## Purpose
Verify that Data-Driven Attribution (DDA) is enabled for all eligible conversion actions. DDA uses machine learning to distribute credit across touchpoints based on actual conversion patterns, providing more accurate optimization signals for Smart Bidding.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/conversion_actions.md` - Attribution model settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion volume for eligibility

**Reference GAQL:**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.attribution_model_settings.attribution_model,
  conversion_action.attribution_model_settings.data_driven_model_status,
  conversion_action.status,
  conversion_action.include_in_conversions_metric
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Use `/google-ads:get-custom` for DDA eligibility status.

## Analysis Steps

1. **Check DDA eligibility:** Minimum 3,000 clicks and 300 conversions in 30 days per action.
2. **Review current attribution models:** Identify actions not using DDA.
3. **Identify migration opportunities:** Eligible actions using Last Click or other models.
4. **Prioritize by impact:** High-volume primary conversions first.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Primary conversion using Last Click with sufficient volume for DDA | Critical |
| DDA eligible but using First Click | Critical |
| DDA status STALE (volume dropped) | Warning |
| Near DDA eligibility (>200 conversions) | Info |
| Low volume, cannot use DDA | Info |

## Output

**Short (default):**
```
## Data-Driven Attribution Audit

**Account:** [Name] | **Conversion Actions:** [X] | **Using DDA:** [Y]

### Attribution Summary
| Action | Current Model | DDA Eligible | Status |
|--------|---------------|--------------|--------|
| [Name] | [Model] | [Yes/No] | [Migrate/OK] |

### Critical ([Count])
- **[Action]**: Using [Model] with [X] conversions -> Switch to DDA

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Volume analysis per conversion action
- DDA eligibility thresholds
- Migration timeline
- Monitoring recommendations
