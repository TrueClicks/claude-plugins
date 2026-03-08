---
name: skill-112-return-refund-tracking
description: "Track product returns and refunds to measure true ROAS."
allowed-tools: Read, Grep, Glob
---
# Skill 112: Return/Refund Tracking

## Purpose
Track product returns and refunds to measure true ROAS. Without return data, reported ROAS overstates actual business performance by 10-30% depending on return rates.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  conversion_action.name,
  conversion_action.type,
  conversion_action.category,
  conversion_action.status,
  conversion_action.value_settings.default_value,
  conversion_action.value_settings.always_use_default_value
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
  AND conversion_action.category IN ('PURCHASE', 'CONVERTED_LEAD')
```
Run via `/google-ads-get-custom` to analyze conversion value patterns.

**Note:** Return tracking requires e-commerce system integration - full audit needs access to OMS/CRM.

## Analysis Steps

1. **Assess Current Tracking:** Check if conversion values are gross or net
2. **Estimate Return Impact:** Apply industry return rates to calculate ROAS gap
3. **Check for Adjustments:** Look for negative conversion imports or value adjustments
4. **Evaluate Implementation Options:** GCLID preservation, conversion adjustments, rate modeling

## Thresholds

| Condition | Severity |
|-----------|----------|
| E-commerce with no return tracking | Critical |
| High return rate industry (apparel) without adjustment | Critical |
| Return data not synced to Google Ads | Warning |
| GCLID not captured for return attribution | Warning |

## Output

**Short (default):**
```
## Return/Refund Tracking Audit
**Account:** [name] | **Industry Return Rate:** ~[X]% | **Return Tracking:** [Yes/No]

### Critical
- **No return tracking implemented** - Reported ROAS ~[X]% overstated

### Warnings
- **GCLID not captured** - Cannot attribute returns to campaigns

### Recommendations
1. Capture GCLID with order in CRM/OMS
2. Implement conversion value adjustments for returns
3. Or apply [X]% return rate reduction to values immediately
```

**Detailed adds:**
- Industry return rate benchmarks
- ROAS accuracy assessment
- Implementation method comparison
- Return tracking technical requirements
