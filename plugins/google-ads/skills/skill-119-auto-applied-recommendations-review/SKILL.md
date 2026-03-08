---
name: skill-119-auto-applied-recommendations-review
description: "Audit and manage Google's auto-applied recommendations to prevent unwanted changes."
allowed-tools: Read, Grep, Glob
---
# Skill 119: Auto-Applied Recommendations Review

## Purpose
Audit and manage Google's auto-applied recommendations to prevent unwanted changes and maintain account control. Unreviewed auto-apply can add irrelevant keywords, change bidding, or expand targeting.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query - Change History:**
```sql
SELECT
  change_event.change_date_time,
  change_event.change_resource_type,
  change_event.change_resource_name,
  change_event.client_type,
  change_event.user_email,
  change_event.resource_change_operation,
  change_event.client_type
FROM change_event
WHERE change_event.change_date_time DURING LAST_14_DAYS
  AND change_event.client_type IN ('GOOGLE_ADS_RECOMMENDATIONS', 'GOOGLE_ADS_RECOMMENDATIONS_SUBSCRIPTION')
LIMIT 100
```

**GAQL Query - Pending Recommendations:**
```sql
SELECT
  recommendation.type,
  recommendation.campaign
FROM recommendation
```
Run via `/google-ads-get-custom` with query name `auto_apply_audit`.

## Analysis Steps

1. **Identify Auto-Applied Changes:** Filter for `GOOGLE_ADS_RECOMMENDATIONS_SUBSCRIPTION` (auto-applied) vs `GOOGLE_ADS_RECOMMENDATIONS` (manually accepted)
2. **Categorize by Risk Level:** High-risk (keywords, bidding, targeting) vs. low-risk
3. **Audit Recent Changes:** Review what was auto-applied in last 14 days
4. **Check Current Settings:** Identify which auto-apply types are enabled

## Thresholds

| Condition | Severity |
|-----------|----------|
| High-risk auto-apply enabled (keywords, bidding) | Critical |
| >10 auto-applied changes in 30 days | Warning |
| Auto-applied keyword additions | Warning |
| Auto-applied bidding strategy changes | Critical |

## Output

**Short (default):**
```
## Auto-Applied Recommendations Audit
**Account:** [name] | **Auto-Applied (30d):** [count] | **High-Risk Enabled:** [Yes/No]

### Critical - Disable Immediately
- **Add keywords** - Auto-apply enabled
- **Upgrade to Smart Bidding** - Auto-apply enabled

### Recent Auto-Applied Changes
| Date | Type | Entity | Review |
|------|------|--------|--------|
| [date] | [type] | [entity] | [Revert?] |

### Recommendations
1. Disable high-risk auto-apply: keywords, bidding, targeting expansion
2. Review and revert [count] recent changes
3. Set up weekly change history monitoring
```

**Detailed adds:**
- Full auto-apply settings status table
- Recent auto-applied changes by category
- Performance impact of auto-applied changes
- Step-by-step disable instructions
