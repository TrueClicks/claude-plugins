---
name: skill-008-label-organizational-structure
description: "Verify that campaigns, ad groups, keywords, and ads are properly labeled for segmentation, reporting, and automated rule targeting."
allowed-tools: Read, Grep, Glob
---
# Skill 008: Label and Organizational Structure Review

## Purpose
Verify that campaigns, ad groups, keywords, and ads are properly labeled for segmentation, reporting, and automated rule targeting. Labels enable powerful automation and reporting but only if consistently applied.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export may not include label details. Custom GAQL required for label inventory and application.

**GAQL Query (label inventory):**
```sql
SELECT
  label.id,
  label.name,
  label.status
FROM label
WHERE label.status = 'ENABLED'
```

**GAQL Query (campaign labels):**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.labels
FROM campaign
WHERE campaign.status != 'REMOVED'
```
Run via `/google-ads:get-custom` with query names `label_inventory` and `campaign_labels`.

## Analysis Steps

1. **Inventory all labels:** List all account labels; categorize by purpose (Performance tier, Product, Region, Test, Status)
2. **Check label coverage:** Calculate % of campaigns and ad groups with labels applied
3. **Assess consistency:** Check for duplicates ("Priority" vs "priority"), orphaned labels (not applied anywhere)
4. **Evaluate taxonomy:** Are labels organized by clear categories? Do they support reporting and automation?
5. **Identify gaps:** High-spend entities without labels, new campaigns not labeled

## Thresholds

| Condition | Severity |
|-----------|----------|
| No labeling system in place (0 labels) | Critical |
| Duplicate/similar labels exist | Warning |
| Campaign label coverage < 50% | Warning |
| Orphaned labels exist | Info |
| Ad group label coverage < 30% | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Label Structure Audit
**Account:** [Name] | **Labels:** [X] | **Campaign Coverage:** [Y]%

### Critical ([Count])
- **No labeling system**: 0 labels found → Implement label taxonomy

### Warnings ([Count])
- **Duplicate labels**: "[Label1]" and "[Label2]" → Consolidate
- **Low coverage**: [X] campaigns unlabeled → Apply appropriate labels

### Recommendations
1. Consolidate duplicate labels
2. Label remaining [X] campaigns
3. Delete [X] orphaned labels
```

**Detailed** adds:
- What Was Checked (label inventory, coverage analysis, naming patterns)
- Label inventory table (Label, Purpose, Usage Count)
- Coverage breakdown by entity type
- Recommended label taxonomy structure
