---
name: skill-082-product-feed-title-optimization
description: "Audit product feed titles to ensure they follow the Brand + Product Type + Key Attributes format."
allowed-tools: Read, Grep, Glob
---
# Skill 082: Product Feed Title Optimization

## Purpose
Audit product feed titles to ensure they follow the Brand + Product Type + Key Attributes format. Well-structured titles improve search relevance, click-through rates, and product visibility in Shopping and Performance Max campaigns.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include detailed product feed data.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.product_title,
  segments.product_brand,
  segments.product_type_l1,
  segments.product_type_l2,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM shopping_performance_view
WHERE campaign.advertising_channel_type IN ('SHOPPING', 'PERFORMANCE_MAX')
  AND segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 0
ORDER BY metrics.impressions DESC
LIMIT 1000
```
Run via `/google-ads:get-custom` with query name `product_titles`.

Note: Full product feed data requires Merchant Center access.

## Analysis Steps

1. **Extract product titles:** Pull titles from shopping_performance_view.
2. **Analyze title structure:** Check for Brand at start, Product Type, Key Attributes.
3. **Pattern detection:** Identify missing brand, generic titles, keyword stuffing.
4. **Performance correlation:** Compare CTR of well-structured vs poorly-structured titles.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Title missing brand name | Critical |
| Title < 30 characters | Critical |
| Contains SKU/internal codes | Critical |
| Brand at end of title | Warning |
| Missing product type | Warning |
| Title > 150 characters (truncation) | Warning |
| No attributes (color/size) | Info |

## Output

**Short (default):**
```
## Product Feed Title Audit

**Account:** [Name] | **Products Analyzed:** [X] | **Issues:** [Y]

### Title Structure Summary
| Quality | Products | % |
|---------|----------|---|
| Excellent (Brand + Type + Attrs) | [X] | [%] |
| Fair (Brand + Type) | [X] | [%] |
| Poor (Missing elements) | [X] | [%] |

### Critical ([Count])
- **[Product Title]**: Missing brand -> Add "[Brand] [Title]"

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Top products needing improvement
- Title pattern analysis
- CTR by title quality
- Optimal title formula examples
