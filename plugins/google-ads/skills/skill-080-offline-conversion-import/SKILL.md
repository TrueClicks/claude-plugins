---
name: skill-080-offline-conversion-import
description: "Verify that offline conversions (sales calls, in-store purchases, CRM-tracked deals) are being imported back to Google Ads."
allowed-tools: Read, Grep, Glob
---
# Skill 080: Offline Conversion Import

## Purpose
Verify that offline conversions (sales calls, in-store purchases, CRM-tracked deals) are being imported back to Google Ads. Offline conversion import enables Smart Bidding to optimize for actual business outcomes, not just website actions.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion action types (look for UPLOAD_CLICKS, UPLOAD_CALLS, STORE_SALES)
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion counts

**Reference GAQL:**
```sql
SELECT
  conversion_action.id,
  conversion_action.name,
  conversion_action.type,
  conversion_action.origin,
  conversion_action.status,
  conversion_action.include_in_conversions_metric
FROM conversion_action
WHERE conversion_action.type IN ('UPLOAD_CLICKS', 'UPLOAD_CALLS', 'STORE_SALES', 'STORE_SALES_DIRECT_UPLOAD')
  AND conversion_action.status = 'ENABLED'
```
Use `/google-ads:get-custom` to check offline conversion import status.

## Analysis Steps

1. **Identify offline conversion actions:** Filter for UPLOAD_CLICKS, UPLOAD_CALLS, STORE_SALES types.
2. **Check import activity:** Look for recent conversions on offline actions.
3. **Assess pipeline health:** Import frequency, match rate, latency.
4. **Identify gaps:** B2B/lead gen accounts without offline import.

## Thresholds

| Condition | Severity |
|-----------|----------|
| B2B/Lead Gen with no offline conversion tracking | Critical |
| Offline action configured but no imports in 30+ days | Critical |
| Import match rate < 50% | Warning |
| Import delay > 14 days | Warning |
| GCLID not captured in forms | Warning |

## Output

**Short (default):**
```
## Offline Conversion Import Audit

**Account:** [Name] | **Offline Actions:** [X] | **Issues:** [Y]

### Offline Conversion Actions
| Action | Type | Status | Last 30d Conv |
|--------|------|--------|---------------|
| [Name] | [Upload type] | [Active/Inactive] | [Count] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Pipeline component assessment
- Match rate analysis
- Import timing recommendations
- GCLID capture guidance
