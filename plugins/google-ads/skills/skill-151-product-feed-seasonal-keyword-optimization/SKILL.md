---
name: skill-151-product-feed-seasonal-keyword-optimization
description: "Update Shopping/PMax product titles with seasonal keywords before peak periods."
allowed-tools: Read, Grep, Glob
---
# Skill 151: Product Feed Seasonal Keyword Optimization

## Purpose
Identify opportunities to add seasonal keywords to product titles for Shopping and Performance Max campaigns. Product titles are the primary relevance factor in Shopping ads - incorporating seasonal search terms (e.g., "christmas gift," "black friday deal") improves visibility during high-demand windows.

## Data Requirements

**Data Source:** Standard (analysis) + Merchant Center (implementation)

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Identify Shopping/PMax campaigns
- `data/performance/campaigns/*/ad_groups/*/search_terms_metrics_30_days.md` - Seasonal query patterns

**Reference GAQL (Shopping Search Terms):**
```sql
SELECT
  campaign.name,
  campaign.status,
  segments.product_title,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM shopping_performance_view
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 100
```
Use `/google-ads-get-custom` to identify seasonal search patterns in Shopping campaigns.

**Note:** Actual feed changes must be made in Google Merchant Center, not Google Ads.

## Analysis Steps

1. **Identify Shopping/PMax campaigns:** Check campaign types in standard data
2. **Map seasonal opportunities:** List upcoming events and relevant seasonal modifiers
3. **Analyze search queries:** Review search terms for seasonal patterns driving traffic
4. **Identify title gaps:** Find products without seasonal keywords that match seasonal queries
5. **Plan implementation timeline:** Schedule title updates 2-3 weeks before peak

## Thresholds

| Condition | Severity |
|-----------|----------|
| Major event within 3 weeks, no seasonal title optimization planned | Critical |
| High-volume seasonal queries not reflected in product titles | Warning |
| Products in gift-relevant categories without "gift" modifiers during Q4 | Warning |
| Prior seasonal titles not reverted post-event | Warning |
| Product categories with low seasonal relevance being modified | Info |

## Output

**Short format (default):**
```
## Product Feed Seasonal Audit
**Account:** [Name] | **Shopping/PMax campaigns:** [X] | **Optimization opportunities:** [Y]

### Critical ([Count])
- **[Event]**: [X] products in [category] lack seasonal titles -> Add "[modifier]" prefix

### Warnings ([Count])
- **[Query]**: [X] searches, products don't match -> Update titles with "[keyword]"

### Recommendations
1. [Category] products: Add "[seasonal keyword]" prefix by [date]
   - Implementation: Supplemental feed or feed rule in Merchant Center
```

**Detailed adds:**
- Product category to seasonal modifier mapping
- Supplemental feed or feed rule implementation instructions
- Title update and reversion schedule by event
