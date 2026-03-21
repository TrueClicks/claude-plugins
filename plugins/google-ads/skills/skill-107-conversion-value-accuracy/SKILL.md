---
name: skill-107-conversion-value-accuracy
description: "Verify that conversion values reflect actual business value (revenue, profit margin, LTV)."
allowed-tools: Read, Grep, Glob
---
# Skill 107: Conversion Value Accuracy

## Purpose
Verify that conversion values reflect actual business value. Accurate values enable value-based bidding that optimizes for profit, not just conversion volume.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion value settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Value per conversion

**Reference GAQL:**
```sql
SELECT
  conversion_action.name,
  conversion_action.type,
  conversion_action.status,
  conversion_action.value_settings.default_value,
  conversion_action.value_settings.always_use_default_value
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Use `/google-ads:get-custom` for detailed value analysis.

## Analysis Steps

1. **Inventory Conversion Actions:** Review all tracked conversions with value settings
2. **Categorize Value Types:** No value, static value, dynamic revenue, adjusted value
3. **Assess Value Accuracy:** Compare tracked values to actual business outcomes
4. **Identify Value Issues:** Static values, gross vs. net revenue, duplicate counting

## Thresholds

| Condition | Severity |
|-----------|----------|
| Primary conversion with no value assigned | Critical |
| All conversions valued at $1 (placeholder) | Critical |
| Static values on dynamic transactions | Warning |
| Gross revenue including shipping/tax | Warning |
| Value discrepancy >15% vs. actual | Warning |

## Output

**Short (default):**
```
## Conversion Value Accuracy Audit
**Account:** [name] | **Conversions Tracked:** [count] | **With Values:** [count] | **Issues:** [count]

### Critical
- **[conversion] has no value assigned** - All conversions treated equally
- **All conversions at $1** - Placeholder value never updated

### Warnings
- **Static value on e-commerce purchase** - Use dynamic transaction values
- **Values include shipping/tax** - Report gross, not net revenue

### Recommendations
1. Implement dynamic revenue tracking for purchases
2. Consider margin-adjusted values (revenue x margin %)
3. Update lead gen values based on close rates
```

**Detailed adds:**
- Conversion value inventory table
- Value type classification
- Estimated ROAS gap from value inaccuracy
- Implementation approaches by business type
