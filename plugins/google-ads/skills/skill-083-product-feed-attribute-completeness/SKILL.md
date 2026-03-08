---
name: skill-083-product-feed-attribute-completeness
description: "Verify that critical product identifiers (GTIN, MPN, Brand) and key attributes are populated in the product feed."
allowed-tools: Read, Grep, Glob
---
# Skill 083: Product Feed Attribute Completeness

## Purpose
Verify that critical product identifiers (GTIN, MPN, Brand) and key attributes are populated in the product feed. Complete attribute data improves product matching, search relevance, and prevents listing disapprovals.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include product attribute details like GTIN/MPN.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.product_item_id,
  segments.product_title,
  segments.product_brand,
  segments.product_type_l1,
  segments.product_type_l2,
  segments.product_condition,
  metrics.impressions,
  metrics.clicks
FROM shopping_performance_view
WHERE campaign.advertising_channel_type IN ('SHOPPING', 'PERFORMANCE_MAX')
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.impressions DESC
LIMIT 2000
```
Run via `/google-ads-get-custom` with query name `product_attributes`.

Note: GTIN/MPN data requires Merchant Center API access.

## Analysis Steps

1. **Assess identifier coverage:** Check Brand, Product Type availability from Google Ads data.
2. **Evaluate category-specific attributes:** Apparel needs color/size/gender.
3. **Identify completeness gaps:** Flag high-impression products with missing data.
4. **Correlate with performance:** Compare completeness vs CTR/conversion rate.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Brand missing | Critical |
| Product Type < 2 levels deep | Critical |
| GTIN missing in required category (via MC) | Critical |
| Color missing (apparel) | Warning |
| Size missing (apparel) | Warning |
| Google Product Category too generic | Warning |

## Output

**Short (default):**
```
## Product Feed Attribute Audit

**Account:** [Name] | **Products Analyzed:** [X] | **Issues:** [Y]

### Attribute Coverage (from Google Ads data)
| Attribute | Coverage | Status |
|-----------|----------|--------|
| Brand | [%] | [Pass/Fail] |
| Product Type L1 | [%] | [Pass/Fail] |
| Product Type L2 | [%] | [Pass/Fail] |

### Critical ([Count])
- **[Product]**: Missing [attribute] -> Add from product data

### Recommendations
1. [Priority action - fix in Merchant Center feed]
2. [Secondary action]
```

**Detailed adds:**
- Category-specific attribute requirements
- Disapproval risk assessment
- Performance by completeness level
- Merchant Center diagnostics guidance
