---
name: skill-085-custom-label-strategy-segmentation
description: "Evaluate and implement custom label strategies to enable margin-based bidding, seasonal prioritization, and performance tiering in Shopping campaigns."
allowed-tools: Read, Grep, Glob
---
# Skill 085: Custom Label Strategy

## Purpose
Evaluate and implement custom label (custom_label_0 through custom_label_4) strategies to enable margin-based bidding, seasonal prioritization, inventory management, and performance tiering in Shopping and Performance Max campaigns.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include custom label data.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.product_item_id,
  segments.product_title,
  segments.product_custom_attribute0,
  segments.product_custom_attribute1,
  segments.product_custom_attribute2,
  segments.product_custom_attribute3,
  segments.product_custom_attribute4,
  metrics.impressions,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM shopping_performance_view
WHERE campaign.advertising_channel_type IN ('SHOPPING', 'PERFORMANCE_MAX')
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 2000
```
Run via `/google-ads-get-custom` with query name `custom_labels`.

## Analysis Steps

1. **Audit current label usage:** Check which custom labels are populated and with what values.
2. **Evaluate label strategy:** Assess if labels align with business segmentation needs.
3. **Check campaign utilization:** Verify campaigns segment by custom labels for differentiated bidding.
4. **Recommend improvements:** Suggest label structure for margin, seasonality, performance.

## Thresholds

| Condition | Severity |
|-----------|----------|
| No custom labels in use | Critical |
| No margin-based labels | Critical |
| Labels populated but not used in campaigns | Warning |
| >10 unique values per label (inconsistent) | Warning |
| Outdated seasonal labels | Warning |
| No performance tier labels | Info |

## Output

**Short (default):**
```
## Custom Label Strategy Audit

**Account:** [Name] | **Products Analyzed:** [X] | **Labels Active:** [Y] of 5

### Current Label Usage
| Label | Populated | Unique Values | Strategy |
|-------|-----------|---------------|----------|
| custom_label_0 | [%] | [X] | [Margin/Unused] |
| custom_label_1 | [%] | [X] | [Season/Unused] |
| custom_label_2 | [%] | [X] | [Performance/Unused] |
| custom_label_3 | [%] | [X] | [Inventory/Unused] |
| custom_label_4 | [%] | [X] | [Category/Unused] |

### Critical ([Count])
- **No margin labels**: All products bid same regardless of profitability -> Add margin tiers

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Recommended label structure
- ROAS targets by margin tier
- Campaign segmentation strategy
- Implementation roadmap
