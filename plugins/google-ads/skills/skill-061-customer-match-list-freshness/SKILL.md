---
name: skill-061-customer-match-list-freshness
description: "Verify that Customer Match lists are uploaded, properly configured, and kept fresh."
allowed-tools: Read, Grep, Glob
---
# Skill 061: Customer Match List Freshness

## Purpose
Verify that Customer Match lists are uploaded, properly configured, and kept fresh. Stale lists miss new customers and include users who may no longer be relevant, reducing targeting effectiveness.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include user list metadata such as size, match rate, or freshness.

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Customer Match list usage in campaigns

**GAQL Query:**
```sql
SELECT
  user_list.id,
  user_list.name,
  user_list.type,
  user_list.size_for_search,
  user_list.size_for_display,
  user_list.membership_status,
  user_list.match_rate_percentage,
  user_list.eligible_for_search,
  user_list.eligible_for_display
FROM user_list
WHERE user_list.type = 'CRM_BASED'
```
Run via `/google-ads:get-custom` with query name `customer_match_lists`.

## Analysis Steps

1. **Fetch Customer Match list details:** Run custom GAQL to get size, match rate, status for all CRM-based lists.
2. **Evaluate list health:** Check size (1,000+ for Search), match rate (>50%), and membership status.
3. **Check usage across campaigns:** Identify which lists are active in targeting vs observation mode.
4. **Identify freshness issues:** Flag lists not updated in >30 days or with declining match rates.

## Thresholds

| Condition | Severity |
|-----------|----------|
| List size < 500 users | Critical |
| Match rate < 30% | Critical |
| Last updated > 90 days | Critical |
| Match rate 30-50% | Warning |
| Last updated 30-90 days | Warning |
| List size 500-1,000 | Warning |

## Output

**Short (default):**
```
## Customer Match List Freshness Audit

**Account:** [Name] | **Lists Analyzed:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[List Name]**: [Size] users, [Match Rate]%, [Days] days old -> Re-upload current list

### Warnings ([Count])
- **[List Name]**: [Issue] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Full list inventory with all metrics
- Campaign usage mapping
- Match rate optimization tips
- Recommended list types to add
