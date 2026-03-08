---
name: skill-088-google-product-category-granularity
description: "Ensure products are mapped to the most specific Google Product Category (GPC) available, not generic parent categories."
allowed-tools: Read, Grep, Glob
---
# Skill 088: Google Product Category Granularity

## Purpose
Ensure products are mapped to the most specific Google Product Category (GPC) available, not generic parent categories. Granular categorization improves search relevance, enables category-specific attributes, and increases ad visibility for targeted queries.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include product category data from Shopping campaigns.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.product_item_id,
  segments.product_title,
  segments.product_category_level1,
  segments.product_category_level2,
  segments.product_category_level3,
  segments.product_category_level4,
  segments.product_category_level5,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM shopping_performance_view
WHERE campaign.advertising_channel_type IN ('SHOPPING', 'PERFORMANCE_MAX')
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.impressions DESC
LIMIT 2000
```
Run via `/google-ads-get-custom` with query name `product_category_analysis`.

**Note:** Full feed analysis requires Merchant Center access.

## Analysis Steps

1. **Extract Category Assignments:** Pull product category levels for all products; identify depth (L1-L5)
2. **Analyze Category Depth:** Count products at each level; flag products using only L1/L2 (too generic)
3. **Validate Category Accuracy:** Check if products are in correct categories; identify inconsistencies
4. **Assess Performance by Depth:** Compare CTR and conversion rates for granular vs. generic categories
5. **Identify High-Impact Opportunities:** Focus on high-impression products with shallow categories

## Thresholds

| Condition | Severity |
|-----------|----------|
| Products with L1 only | Critical |
| Products with L2 only (>10% of catalog) | Warning |
| Products not at deepest available category (>20%) | Warning |
| Miscategorized products | Warning |
| Inconsistent categories for similar products | Info |

## Output

**Short (default):**
```
## Google Product Category Audit
**Account:** [name] | **Products:** [count] | **Avg Depth:** [X.X] | **Issues:** [count]

### Critical
- **[count] products at L1 only** - Too generic for targeting

### Warnings
- **[count] products at L2** - Could be more specific
- **[count] products inconsistently categorized** - Standardize mapping

### Recommendations
1. Update [count] high-impression products from L1/L2 to specific categories
2. Standardize categories for [product group] to L4+ depth
```

**Detailed adds:**
- Category depth distribution table
- Product-level examples with current vs. recommended categories
- Performance comparison by category depth (CTR, Conv Rate)
- Category-specific attribute opportunities
