---
name: skill-072-enhanced-conversions-web
description: "Verify that Enhanced Conversions for Web is properly implemented to improve conversion measurement accuracy in a privacy-first world."
allowed-tools: Read, Grep, Glob
---
# Skill 072: Enhanced Conversions for Web

## Purpose
Verify that Enhanced Conversions for Web is properly implemented to improve conversion measurement accuracy in a privacy-first world. Enhanced Conversions use hashed first-party data to recover conversions lost due to cookie restrictions.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export includes conversion actions but not Enhanced Conversions status details.

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion action configuration
- `data/account/account_summary.md` - Account-level settings

**GAQL Query:**
```sql
SELECT
  customer.id,
  customer.descriptive_name,
  customer.conversion_tracking_setting.enhanced_conversions_for_leads_enabled,
  customer.conversion_tracking_setting.google_ads_conversion_customer
FROM customer
LIMIT 1
```
Run via `/google-ads-get-custom` with query name `enhanced_conversions_status`.

Note: Full implementation verification requires Tag Assistant or developer tools.

## Analysis Steps

1. **Check account-level status:** Verify enhanced conversions are enabled at account level.
2. **Review conversion actions:** Check which actions are configured for enhancement.
3. **Assess data capture:** Verify email and other user data fields are captured.
4. **Identify implementation gaps:** Flag missing fields or configuration issues.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Enhanced Conversions not enabled | Critical |
| Enabled but no email data captured | Critical |
| Missing phone number field (recommended) | Warning |
| Missing name fields (recommended) | Warning |
| Match rate < 25% (if available) | Warning |

## Output

**Short (default):**
```
## Enhanced Conversions for Web Audit

**Account:** [Name] | **Status:** [Enabled/Disabled] | **Issues:** [Y]

### Configuration
| Setting | Status |
|---------|--------|
| Account-level enabled | [Yes/No] |
| Email capture | [Yes/No/Unknown] |
| Phone capture | [Yes/No/Unknown] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Implementation method assessment (GTM, gtag.js, API)
- Data field coverage
- Match rate expectations
- Implementation code examples
