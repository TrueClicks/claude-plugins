---
name: skill-073-enhanced-conversions-leads
description: "Verify that Enhanced Conversions for Leads is properly configured to match offline CRM data back to Google Ads clicks."
allowed-tools: Read, Grep, Glob
---
# Skill 073: Enhanced Conversions for Leads

## Purpose
Verify that Enhanced Conversions for Leads is properly configured to match offline CRM data back to Google Ads clicks. This enables accurate measurement of lead quality and downstream conversions (SQLs, opportunities, closed deals) that occur offline.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include Enhanced Conversions for Leads status.

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion action configuration
- `data/account/account_summary.md` - Account settings including enhanced conversions for leads

**GAQL Query:**
```sql
SELECT
  customer.id,
  customer.descriptive_name,
  customer.conversion_tracking_setting.enhanced_conversions_for_leads_enabled
FROM customer
LIMIT 1
```
Run via `/google-ads-get-custom` with query name `enhanced_conversions_leads_status`.

## Analysis Steps

1. **Check Enhanced Conversions for Leads status:** Verify enabled at account level.
2. **Identify lead conversion actions:** Find actions categorized as LEAD, SIGNUP, QUALIFIED_LEAD.
3. **Assess data capture:** Verify email is captured at form submission for matching.
4. **Evaluate CRM integration:** Check if offline conversion import pipeline exists.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Enhanced Conversions for Leads not enabled (B2B/Lead Gen) | Critical |
| Only tracking form fills, no downstream stages | Critical |
| GCLID not captured in CRM | Critical |
| No offline conversion import pipeline | Warning |
| Import match rate < 50% | Warning |
| Import delay > 14 days | Warning |

## Output

**Short (default):**
```
## Enhanced Conversions for Leads Audit

**Account:** [Name] | **Status:** [Enabled/Disabled] | **Issues:** [Y]

### Lead Funnel Tracking
| Stage | Tracked | Import Method |
|-------|---------|---------------|
| Form Submit | [Yes/No] | Website tag |
| SQL | [Yes/No] | [Import/None] |
| Closed Won | [Yes/No] | [Import/None] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Lead funnel tracking coverage
- CRM integration assessment
- Import pipeline health
- GCLID capture implementation guidance
