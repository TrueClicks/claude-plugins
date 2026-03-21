---
name: skill-052-conversion-value-based-bidding
description: "Verify that conversion values reflect actual business value (revenue, profit margin, LTV) to enable Smart Bidding to optimize for profit, not just conversion volume."
allowed-tools: Read, Grep, Glob
---
# Skill 052: Conversion Value-Based Bidding Assessment

## Purpose

Without accurate conversion values, tROAS bidding optimizes for revenue regardless of margin, potentially prioritizing low-profit conversions. This skill verifies that conversion values reflect actual business value (revenue, profit margin, LTV) and identifies opportunities for value-based optimization.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion action settings, default values
- `data/account/account_summary.md` - Account-level conversion settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion values

**Reference GAQL:**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.category,
  conversion_action.type,
  conversion_action.value_settings.default_value,
  conversion_action.value_settings.always_use_default_value,
  conversion_action.counting_type,
  conversion_action.status
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Use `/google-ads:get-custom` for detailed value settings.

## Analysis Steps

1. **Inventory conversion actions:** List all conversions with value sources (dynamic, static, default) and counting type.

2. **Assess value accuracy:** Compare reported values to actual business data, check for static values that should be dynamic, identify conversions missing value data.

3. **Evaluate value types:** Transaction revenue vs profit margin, lead value based on close rate x LTV, micro-conversion value estimation.

4. **Check Smart Bidding alignment:** tROAS campaigns with value accuracy, Max Conversion Value campaigns, portfolio strategies using values.

5. **Identify optimization opportunities:** Profit-based value implementation, LTV-based lead valuation, product margin differentiation.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Lead conversion with $0 value | Critical |
| E-commerce without dynamic values | Critical |
| tROAS campaign with static values | High |
| Revenue vs profit variance >20% | Warning |
| Lead value not reflecting LTV | Warning |
| Conversion value variance >10% from actuals | Info |

## Output

**Short (default):**
```
## Conversion Value Assessment

**Account:** [Name] | **Conversion Actions:** [X] | **Using Accurate Values:** [Y]%

### Critical ([Count])
- **[Conversion]**: $0 value assigned → Set value to $[X] based on [calculation]

### Warnings ([Count])
- **[Conversion]**: Static $[X] value, actual value $[Y] → Update or implement dynamic

### Recommendations
1. [Priority value update]
2. [Secondary optimization]
```

**Detailed adds:**
- Conversion value configuration table (action, category, value type, default value, dynamic, status)
- Value accuracy analysis (metric, Google Ads value, actual business value, variance, issue)
- Campaign value optimization status (campaign, bid strategy, uses value, value accuracy, status)
- Value calculation frameworks for e-commerce (profit-based) and lead gen (LTV-based)
- Implementation priority with expected impact
