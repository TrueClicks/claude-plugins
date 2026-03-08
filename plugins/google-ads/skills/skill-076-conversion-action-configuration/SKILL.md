---
name: skill-076-conversion-action-configuration
description: "Review and optimize conversion action configuration including counting method, attribution model, value settings, and conversion windows."
allowed-tools: Read, Grep, Glob
---
# Skill 076: Conversion Action Configuration

## Purpose
Review and optimize conversion action configuration including counting method, attribution model, value settings, and conversion windows. Proper configuration ensures Smart Bidding optimizes for the right signals and ROAS reporting is accurate.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/conversion_actions.md` - Full conversion action settings including counting type, attribution, values, windows

**Reference GAQL:**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.type,
  conversion_action.category,
  conversion_action.status,
  conversion_action.include_in_conversions_metric,
  conversion_action.counting_type,
  conversion_action.attribution_model_settings.attribution_model,
  conversion_action.click_through_lookback_window_days,
  conversion_action.value_settings.default_value,
  conversion_action.value_settings.always_use_default_value
FROM conversion_action
ORDER BY conversion_action.include_in_conversions_metric DESC
```
Use `/google-ads-get-custom` for additional conversion action details.

## Analysis Steps

1. **Inventory all conversion actions:** List actions with type, status, primary/secondary.
2. **Evaluate counting type:** "Every" for purchases, "One" for leads.
3. **Review attribution model:** DDA recommended if eligible, check volume requirements.
4. **Assess value configuration:** Dynamic for e-commerce, static for leads.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Lead form using "Every" counting (duplicates) | Critical |
| No value on primary conversion (no ROAS possible) | Critical |
| Last Click attribution with sufficient volume for DDA | Critical |
| 90-day window for impulse purchases | Warning |
| Secondary conversion should be primary | Warning |
| Missing default value fallback | Warning |

## Output

**Short (default):**
```
## Conversion Action Configuration Audit

**Account:** [Name] | **Actions:** [X] | **Issues:** [Y]

### Configuration Summary
| Action | Type | Primary | Counting | Attribution | Value |
|--------|------|---------|----------|-------------|-------|
| [Name] | [Type] | [Y/N] | [One/Every] | [Model] | $[X] |

### Critical ([Count])
- **[Action]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Full configuration table with all settings
- Attribution model eligibility analysis
- Value configuration recommendations
- Window alignment with sales cycle
