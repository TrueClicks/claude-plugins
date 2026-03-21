---
name: skill-104-customer-match-list-management
description: "Audit Customer Match list usage, freshness, and application strategy for cross-device targeting."
allowed-tools: Read, Grep, Glob
---
# Skill 104: Customer Match List Management

## Purpose
Audit Customer Match list usage for cross-device targeting and lookalike creation. Customer Match is the most durable targeting signal as third-party cookies decline.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  user_list.name,
  user_list.id,
  user_list.type,
  user_list.size_for_display,
  user_list.size_for_search,
  user_list.membership_status,
  user_list.match_rate_percentage
FROM user_list
WHERE user_list.type = 'CRM_BASED'
```
Run via `/google-ads:get-custom` with query name `customer_match_lists`.

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Audience usage

## Analysis Steps

1. **Identify Customer Match Lists:** Find CRM-based lists in account
2. **Assess List Coverage:** Check if key segments exist (all customers, high-value, recent)
3. **Evaluate Freshness:** Identify stale lists (>30-90 days since update)
4. **Review Application Strategy:** Verify lists used for targeting, exclusion, or lookalikes

## Thresholds

| Condition | Severity |
|-----------|----------|
| No Customer Match lists in account | Critical |
| Customer Match list <1,000 matched users | Warning |
| List not updated in >90 days | Warning |
| Lists exist but not applied to campaigns | Warning |
| No high-value customer segment | Info |

## Output

**Short (default):**
```
## Customer Match List Audit
**Account:** [name] | **CM Lists:** [count] | **Applied:** [count] | **Issues:** [count]

### Critical
- **No Customer Match lists** - Upload customer email list

### Warnings
- **[list] not updated in [X] days** - Refresh weekly/monthly
- **[list] only [X] matched users** - Below 1,000 minimum

### Recommendations
1. Upload all customer emails (target: 10,000+)
2. Create high-value customer segment (top 20% LTV)
3. Set up weekly automated refresh from CRM
```

**Detailed adds:**
- Customer Match inventory table with sizes and match rates
- List application strategy by campaign type
- Recommended list structure (all, high-value, recent, lapsed)
- Compliance checklist
