---
name: skill-062-audience-minimum-size-monitoring
description: "Monitor remarketing and customer lists to ensure they maintain the minimum 1,000+ members required for Search targeting."
allowed-tools: Read, Grep, Glob
---
# Skill 062: Audience Minimum Size Monitoring

## Purpose
Monitor remarketing and customer lists to ensure they maintain the minimum 1,000+ members required for Search targeting. Audiences below threshold cannot be used for targeting and may affect campaign delivery.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include user list size data.

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Audience usage in campaigns

**GAQL Query:**
```sql
SELECT
  user_list.id,
  user_list.name,
  user_list.type,
  user_list.size_for_search,
  user_list.size_for_display,
  user_list.membership_status,
  user_list.membership_life_span,
  user_list.eligible_for_search,
  user_list.eligible_for_display
FROM user_list
WHERE user_list.membership_status = 'OPEN'
```
Run via `/google-ads-get-custom` with query name `audience_sizes`.

## Analysis Steps

1. **Fetch all audience lists:** Run custom GAQL to get list sizes and eligibility status.
2. **Categorize by size status:** Healthy (5,000+), Acceptable (1,000-5,000), At Risk (500-999), Below Minimum (<500).
3. **Cross-reference with campaigns:** Identify if undersized lists are used in targeting (vs observation).
4. **Flag critical issues:** Audiences below minimum that are actively used for targeting.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Search audience < 500 users | Critical |
| Audience used for targeting but ineligible | Critical |
| Search audience 500-999 users | Warning |
| Display audience < 100 users | Warning |
| Audience trending down >20% weekly | Warning |

## Output

**Short (default):**
```
## Audience Size Monitoring Audit

**Account:** [Name] | **Audiences:** [X] | **Below Minimum:** [Y]

### Critical ([Count])
- **[Audience Name]**: [Size] users (needs 1,000) -> Extend membership duration or combine lists

### Warnings ([Count])
- **[Audience Name]**: [Size] users, trending down -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Full audience inventory by size tier
- Campaign impact analysis
- Membership duration recommendations
- List combination suggestions
