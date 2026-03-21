---
name: skill-149-promotional-extensions-countdown-customizers
description: "Deploy promotional extensions, countdown customizers, and seasonal ad copy during events."
allowed-tools: Read, Grep, Glob
---
# Skill 149: Promotional Extensions and Countdown Customizers

## Purpose
Audit promotion extensions and countdown customizers for upcoming events. Promotional extensions highlight offers directly in ads while countdown customizers create real-time urgency. Both significantly boost CTR and conversion rates during promotional periods.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/ext_promotion.md` - Promotion extension settings and schedules
- `data/account/campaigns/*/ad_groups/*/ads.md` - Ad copy with countdown customizers

**Reference GAQL:**
```sql
SELECT
  asset.name,
  asset.type,
  asset.promotion_asset.occasion,
  asset.promotion_asset.discount_modifier,
  asset.promotion_asset.percent_off,
  asset.promotion_asset.money_amount_off.amount_micros,
  asset.promotion_asset.start_date,
  asset.promotion_asset.end_date
FROM asset
WHERE asset.type = 'PROMOTION'
```
Use `/google-ads:get-custom` if you need asset-level performance data or extended date ranges.

## Analysis Steps

1. **Review promotion extensions:** Check `ext_promotion.md` for active, scheduled, and expired promotions
2. **Verify promotion coverage:** Ensure upcoming events have extensions with correct dates and discounts
3. **Audit countdown customizers:** Search ad copy for `{COUNTDOWN(...)}` syntax
4. **Check countdown accuracy:** Verify countdown dates are current and match actual promotion end dates
5. **Identify seasonal ad copy gaps:** Look for missing holiday-specific messaging in headlines/descriptions

## Thresholds

| Condition | Severity |
|-----------|----------|
| Event within 7 days with no promotion extension | Critical |
| Active promotion extension with past end date | Critical |
| Countdown customizer with past date | Critical |
| Promotion discount doesn't match actual offer | Warning |
| No countdown customizers for limited-time event | Warning |
| Promotion extension not linked to relevant campaigns | Info |

## Output

**Short format (default):**
```
## Promotional Extensions Audit
**Account:** [Name] | **Events (60d):** [X] | **Extension gaps:** [Y]

### Critical ([Count])
- **[Event]**: No promotion extension -> Create [discount type] for [dates]
- **[Extension]**: End date [past date] -> Remove or update

### Warnings ([Count])
- **[Event]**: No countdown in ads -> Add "{COUNTDOWN([date])}" to headlines

### Recommendations
1. [Specific extension to create with discount, dates, and campaigns]
```

**Detailed adds:**
- Event-by-event extension/countdown coverage matrix
- Countdown customizer syntax examples for each event
- Extension scheduling timeline with create/remove dates
