---
name: skill-037-ad-disapproval-limited-eligibility
description: "Check ad approval status and resolve disapproved or limited eligibility ads."
allowed-tools: Read, Grep, Glob
---
# Skill 037: Ad Disapproval and Limited Eligibility Monitoring

## Purpose

Disapproved ads stop serving immediately, resulting in lost traffic and revenue. Limited eligibility ads serve in restricted contexts, reducing reach. Regular monitoring ensures maximum ad coverage and prevents revenue loss from undetected policy violations.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Ad approval status and policy issues

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.type,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.final_urls,
  ad_group_ad.policy_summary.approval_status,
  ad_group_ad.policy_summary.review_status,
  ad_group_ad.policy_summary.policy_topic_entries,
  ad_group_ad.status,
  metrics.impressions
FROM ad_group_ad
WHERE ad_group_ad.status != 'REMOVED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` for detailed policy topic entries.

## Analysis Steps

1. **Categorize by approval status:** Approved, Approved Limited, Area of Interest Only, Limited, Disapproved, Under Review
2. **Analyze disapproved ads:** Extract policy topic (reason), identify ad copy causing issues, check landing pages
3. **Assess impact:** Find ad groups with only disapproved ads (silenced), high-value campaigns affected
4. **Prioritize resolution:** Ad groups with no approved ads first, then high-spend campaigns, then simple editorial fixes
5. **Plan remediation:** Fix/replace ads, appeal if incorrect, document patterns

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad group with all ads disapproved | Critical |
| Any disapproved ad | Warning |
| >10% of ads disapproved | Critical |
| Ad under review > 7 days | Warning |
| Limited eligibility affecting reach | Info |

## Output

**Short (default):**
```
## Ad Approval Audit
**Account:** [Name] | **Ads:** [X] | **Disapproved:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: ALL ads disapproved (silenced) -> Fix immediately
  - Ad [ID]: [Policy topic] -> [Specific fix]

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: [X] disapproved
  - [Policy topic]: "[ad copy causing issue]" -> [Fix]

### Status Summary
| Status | Count | % |
|--------|-------|---|
| Approved | X | X% |
| Disapproved | X | X% |
| Limited | X | X% |
| Under Review | X | X% |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Full disapproval list with policy topics
- Common policy violations and fixes
- Resolution priority queue with estimated fix time
