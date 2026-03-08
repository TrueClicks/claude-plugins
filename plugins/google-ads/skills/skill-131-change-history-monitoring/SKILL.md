---
name: skill-131-change-history-monitoring
description: "Track account changes including manual updates, automated rules, and auto-applied recommendations for audit purposes."
allowed-tools: Read, Grep, Glob
---
# Skill 131: Change History Monitoring

## Purpose

Monitor all account changes to identify who made what changes, track auto-applied recommendations, and flag unusual activity. Essential for accountability, troubleshooting performance shifts, and maintaining control over account automation.

## Data Requirements

**Data Source:** Custom GAQL Required

Change history data requires the change_event resource which is not in standard exports.

**GAQL Query:**
```sql
SELECT
  change_event.change_date_time,
  change_event.change_resource_type,
  change_event.resource_change_operation,
  change_event.changed_fields,
  change_event.client_type,
  change_event.user_email
FROM change_event
WHERE change_event.change_date_time DURING LAST_14_DAYS
LIMIT 1000
```
Run via `/google-ads-get-custom` with query name `change_history`.

## Analysis Steps

1. **Fetch change history:** Run GAQL query for recent account changes
2. **Categorize by source:** Group changes by user, API, automated rules, Google internal
3. **Identify critical changes:** Flag budget, bidding, and status changes
4. **Track auto-applied changes:** Filter for `GOOGLE_ADS_RECOMMENDATIONS_SUBSCRIPTION` (auto-applied) and `GOOGLE_ADS_RECOMMENDATIONS` (manually accepted)
5. **Detect anomalies:** Flag unusual volumes or off-hours activity

## Thresholds

| Condition | Severity |
|-----------|----------|
| Budget change without documentation | Critical |
| Bidding strategy changed unexpectedly | Critical |
| Auto-applied changes not reviewed | Warning |
| >50 changes in 1 hour (unusual volume) | Warning |
| Changes from unknown API source | Info |

## Output

**Short format (default):**
```
## Change History Audit

**Account:** [Name] | **Period:** Last 14 days | **Total Changes:** [X]

### Change Summary by Source
| Source | Changes |
|--------|---------|
| Manual (UI) | [X] |
| Automated Rules | [X] |
| Auto-Applied (Google) | [X] |
| API/Scripts | [X] |

### Critical Changes to Review
- **[Date]**: Budget changed from $[X] to $[Y] by [User]
- **[Date]**: Bidding strategy changed on [Campaign] by [User]

### Auto-Applied Changes
- [X] recommendations auto-applied → Review for appropriateness

### Anomalies Detected
- **[Date]**: [X] changes in 1 hour from [Source]
```

**Detailed adds:**
- Full change log by date
- Changes grouped by campaign
- User activity breakdown
- Reverting instructions for critical changes
