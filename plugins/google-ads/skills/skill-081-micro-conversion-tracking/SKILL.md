---
name: skill-081-micro-conversion-tracking
description: "Track intermediate actions (micro-conversions) that indicate user intent before the primary conversion."
allowed-tools: Read, Grep, Glob
---
# Skill 081: Micro-Conversion Tracking

## Purpose
Track intermediate actions (micro-conversions) that indicate user intent before the primary conversion. Micro-conversions provide additional signals for Smart Bidding, enable audience building, and help identify funnel bottlenecks.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/conversion_actions.md` - Current conversion action configuration
- `data/account/account_summary.md` - Business type context
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion volumes

**Reference GAQL:**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.type,
  conversion_action.category,
  conversion_action.include_in_conversions_metric,
  conversion_action.counting_type
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
ORDER BY conversion_action.include_in_conversions_metric DESC
```
Use `/google-ads-get-custom` for conversion volume per action.

## Analysis Steps

1. **Inventory current tracking:** List all conversion actions, identify primary vs secondary.
2. **Map user journey:** Identify funnel stages before primary conversion.
3. **Identify gaps:** Missing high-value micro-conversions (add to cart, form start, pricing view).
4. **Recommend additions:** Suggest micro-conversions with value assignment.

## Thresholds

| Condition | Severity |
|-----------|----------|
| E-commerce with no add-to-cart tracking | Critical |
| Lead gen with no form interaction tracking | Critical |
| Only 1 conversion action total | Critical |
| Missing checkout funnel steps | Warning |
| No engagement micro-conversions | Warning |
| Micro-conversions incorrectly set as primary | Warning |

## Output

**Short (default):**
```
## Micro-Conversion Tracking Audit

**Account:** [Name] | **Conversion Actions:** [X] | **Gaps:** [Y]

### Current Tracking
| Action | Type | Primary | Category |
|--------|------|---------|----------|
| [Name] | [Type] | [Y/N] | [Category] |

### Missing Micro-Conversions
| Action | Business Value | Priority |
|--------|----------------|----------|
| Add to Cart | High intent signal | High |
| Form Start | Abandonment tracking | Medium |

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Funnel stage mapping
- Value assignment recommendations
- Implementation guidance
- Audience building opportunities
