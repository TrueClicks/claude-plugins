---
name: skill-009-account-defaults-audit
description: "Review account-level settings including auto-tagging, conversion tracking defaults, auto-applied recommendations opt-ins, and linked accounts."
allowed-tools: Read, Grep, Glob
---
# Skill 009: Account-Level Default Settings Audit

## Purpose
Review account-level settings including auto-tagging, conversion tracking defaults, auto-applied recommendations opt-ins, and linked accounts. Auto-applied recommendations can silently change bid strategies, add broad match keywords, or increase budgets without consent.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard account summary may lack complete settings. Custom GAQL provides comprehensive account configuration.

**GAQL Query (account settings):**
```sql
SELECT
  customer.id,
  customer.descriptive_name,
  customer.auto_tagging_enabled,
  customer.conversion_tracking_setting.conversion_tracking_id,
  customer.conversion_tracking_setting.conversion_tracking_status,
  customer.remarketing_setting.google_global_site_tag
FROM customer
```

**GAQL Query (conversion actions):**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.type,
  conversion_action.status,
  conversion_action.primary_for_goal,
  conversion_action.counting_type,
  conversion_action.attribution_model_settings.attribution_model
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Run via `/google-ads:get-custom` with query names `account_settings` and `conversion_actions`.

**Note:** Auto-applied recommendations settings require Google Ads UI review or Recommendations API (not available via standard GAQL).

## Analysis Steps

1. **Check auto-tagging:** Verify enabled (required for Google Analytics integration)
2. **Review conversion tracking:** Check status, verify conversion actions configured, review attribution models
3. **Check auto-applied recommendations:** Flag dangerous auto-applies (add broad match, increase budgets, change bidding)
4. **Review linked accounts:** GA4, Merchant Center, YouTube, Search Console
5. **Audit conversion actions:** Check primary actions, counting methods, attribution models

## Thresholds

| Condition | Severity |
|-----------|----------|
| Auto-tagging disabled | Critical |
| No conversion tracking | Critical |
| Auto-apply "Add broad match" enabled | Critical |
| Auto-apply "Raise budgets" enabled | Critical |
| GA4 not linked | Warning |
| Non-primary actions included in optimization | Warning |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Account Defaults Audit
**Account:** [Name] | **ID:** [X] | **Issues:** [Y]

### Critical ([Count])
- **Auto-tagging disabled** → Enable for proper Analytics tracking
- **Auto-apply "Add broad match" enabled** → Disable in Recommendations settings

### Warnings ([Count])
- **GA4 not linked** → Link for cross-platform insights
- **[Conv Action]**: Last-click attribution → Switch to data-driven

### Recommendations
1. Disable risky auto-apply settings immediately
2. Link GA4 property
3. Review conversion action configuration
```

**Detailed** adds:
- What Was Checked (auto-tagging, conversion tracking, auto-applies, linked accounts)
- Account settings table (Setting, Value, Status)
- Conversion actions table (Action, Type, Primary, Counting, Attribution)
- Auto-apply settings list with risk levels
