---
name: skill-075-consent-mode-v2
description: "Verify that Consent Mode v2 is properly implemented to maintain conversion measurement accuracy while respecting user privacy choices."
allowed-tools: Read, Grep, Glob
---
# Skill 075: Consent Mode v2 Implementation

## Purpose
Verify that Consent Mode v2 is properly implemented to maintain conversion measurement accuracy while respecting user privacy choices. Consent Mode enables conversion modeling for users who decline cookies, recovering otherwise lost conversion data.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include Consent Mode status details.

**Standard Data:**
- `data/account/account_summary.md` - Account settings
- `data/account/conversion_actions.md` - Conversion action configuration

**GAQL Query:**
```sql
SELECT
  customer.id,
  customer.descriptive_name,
  customer.conversion_tracking_setting.google_ads_conversion_customer
FROM customer
LIMIT 1
```
Run via `/google-ads-get-custom` with query name `consent_mode_check`.

Note: Full Consent Mode verification requires Tag Assistant or code inspection.

## Analysis Steps

1. **Check account-level settings:** Review conversion tracking configuration.
2. **Identify EEA traffic:** Accounts with EEA/UK traffic require V2 signals.
3. **Assess consent signals:** V2 requires ad_user_data and ad_personalization in addition to V1 signals.
4. **Verify modeling eligibility:** Check traffic and conversion volume for modeling.

## Thresholds

| Condition | Severity |
|-----------|----------|
| EEA traffic without Consent Mode V2 | Critical |
| V1 only (missing ad_user_data, ad_personalization) | Critical |
| Tags firing before consent obtained | Critical |
| CMP not integrated with gtag | Warning |
| Low traffic volume (modeling may not work) | Warning |
| Consent defaults not set | Warning |

## Output

**Short (default):**
```
## Consent Mode v2 Audit

**Account:** [Name] | **Status:** [V2 Compliant/V1 Only/Not Implemented]

### Compliance Assessment
| Requirement | Status |
|-------------|--------|
| Consent Mode enabled | [Yes/No/Unknown] |
| V2 signals (ad_user_data) | [Yes/No/Unknown] |
| EEA compliance | [Compliant/Gap] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Consent signal configuration
- CMP integration assessment
- Modeling eligibility
- Implementation code examples
