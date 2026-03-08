---
name: skill-139-ad-disapproval-monitoring
description: "Monitor ad approval status and provide systematic resolution workflow for disapprovals."
allowed-tools: Read, Grep, Glob
---
# Skill 139: Ad Disapproval Monitoring

## Purpose

Identify disapproved and limited ads that are not serving, prioritize by business impact, and provide resolution workflows. Prompt attention to disapprovals prevents revenue loss and ensures ad coverage across all ad groups.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Ad approval status, policy issues

**GAQL Query (for detailed policy info):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.type,
  ad_group_ad.ad.final_urls,
  ad_group_ad.policy_summary.approval_status,
  ad_group_ad.policy_summary.review_status,
  ad_group_ad.policy_summary.policy_topic_entries
FROM ad_group_ad
WHERE ad_group_ad.status != 'REMOVED'
  AND ad_group_ad.policy_summary.approval_status IN ('DISAPPROVED', 'APPROVED_LIMITED', 'AREA_OF_INTEREST_ONLY')
```
Run via `/google-ads-get-custom` with query name `ad_policy_issues`.

## Analysis Steps

1. **Read ad approval data:** Extract status from ads.md files
2. **Identify disapprovals:** List all ads with non-approved status
3. **Analyze policy topics:** Categorize by violation type (editorial, trademark, destination, etc.)
4. **Assess impact:** Flag ad groups with no remaining approved ads
5. **Prioritize resolution:** Order by impact and fix complexity

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad group with 0 approved ads | Critical |
| High-spend campaign with disapproved ads | Critical |
| Multiple ads with same policy violation | Warning |
| Ads limited to specific regions | Warning |
| Ads under review > 3 days | Info |

## Output

**Short format (default):**
```
## Ad Disapproval Audit

**Account:** [Name] | **Total Ads:** [X] | **Disapproved:** [Y]

### Ad Approval Summary
| Status | Count |
|--------|-------|
| Approved | [X] |
| Disapproved | [Y] |
| Limited | [Z] |
| Under Review | [W] |

### Critical - Ad Groups with No Active Ads
- **[Campaign/AdGroup]**: All [X] ads disapproved → Fix immediately

### Disapproved Ads
| Campaign | Ad Group | Policy Issue | Fix |
|----------|----------|--------------|-----|
| [Name] | [Name] | TRADEMARKS | Remove trademark |
| [Name] | [Name] | EDITORIAL | Fix capitalization |

### Resolution Priority
1. Fix [X] ad groups with no active ads
2. Address [Y] editorial issues (quick fixes)
3. Resolve [Z] policy violations

### Recommendations
1. Keep 2-3 approved ads per ad group as backup
2. Review landing pages for destination issues
```

**Detailed adds:**
- Full disapproval list with policy details
- Resolution workflow by policy type
- Appeal process guidance
- Prevention checklist
