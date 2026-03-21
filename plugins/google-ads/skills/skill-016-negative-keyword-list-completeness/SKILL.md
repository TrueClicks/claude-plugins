---
name: skill-016-negative-keyword-list-completeness
description: "Verify that shared negative keyword lists exist and adequately cover common waste categories to prevent irrelevant traffic."
allowed-tools: Read, Grep, Glob
---
# Skill 016: Negative Keyword List Completeness Audit

## Purpose
Verify that shared negative keyword lists exist and adequately cover common waste categories to prevent irrelevant traffic. Shared lists provide consistent protection and reduce maintenance burden.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/shared_negative_lists.md` - Shared negative keyword lists
- `data/account/campaigns/*/negative_keywords.md` - Campaign-level negatives
- `data/account/campaigns/*/*/negative_keywords.md` - Ad group-level negatives
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - To validate leakage
- `data/account/campaigns/*/campaign.md` - Campaign list for coverage check

**Reference GAQL:**
```sql
SELECT
  shared_set.id,
  shared_set.name,
  shared_set.type,
  shared_set.member_count
FROM shared_set
WHERE shared_set.type = 'NEGATIVE_KEYWORDS'
```
Use `/google-ads:get-custom` if you need detailed shared set membership.

## Analysis Steps

1. **Inventory existing lists:** Document list names, keyword counts, and campaign assignments
2. **Check standard waste categories:** Jobs/Careers, Free-seekers, DIY/Tutorial, Support/Login
3. **Verify list application:** Check which campaigns have each list; flag gaps
4. **Gap analysis:** Review search terms for waste patterns not blocked by negatives
5. **Assess match types:** Phrase match recommended; flag broad match negatives (over-blocking risk)

## Thresholds

| Condition | Severity |
|-----------|----------|
| No shared negative lists exist | Critical |
| Standard waste category not covered | Warning |
| Shared list exists but not applied to all campaigns | Warning |
| Waste terms found in search terms not blocked | Warning |
| Broad match negatives present | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Negative List Completeness Audit
**Account:** [Name] | **Shared Lists:** [X] | **Gaps:** [Y]

### Critical ([Count])
- **No shared lists**: All negatives at campaign level → Create shared lists

### Warnings ([Count])
- **Missing category**: "[Jobs/Careers]" not covered, $[X] wasted → Create list
- **Incomplete coverage**: "[List]" not applied to [X] campaigns → Apply to all

### Recommendations
1. Create shared list for "[category]" waste
2. Apply existing lists to all campaigns
```

**Detailed** adds:
- What Was Checked (list inventory, category coverage, application)
- List inventory table (Name, Keywords, Campaigns Applied, Coverage %)
- Waste category coverage table (Category, Covered?, List Name, Sample Keywords, Gap?)
- Campaigns missing coverage table
- Recommended shared list structure
