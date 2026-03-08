---
name: skill-089-pmax-asset-group-structure
description: "Evaluate whether PMax asset groups are organized by distinct product categories or intent themes."
allowed-tools: Read, Grep, Glob
---
# Skill 089: Performance Max Asset Group Structure

## Purpose
Evaluate whether PMax asset groups are organized by distinct product categories or intent themes. Poorly structured asset groups dilute audience signals and creative relevance, reducing campaign effectiveness.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include asset group details.

**GAQL Query - Asset Groups:**
```sql
SELECT
  campaign.id,
  campaign.name,
  asset_group.id,
  asset_group.name,
  asset_group.status,
  asset_group.ad_strength
FROM asset_group
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND campaign.status = 'ENABLED'
```

**GAQL Query - Listing Group Filters:**
```sql
SELECT
  asset_group.id,
  asset_group.name,
  asset_group_listing_group_filter.type,
  asset_group_listing_group_filter.case_value.product_type.value,
  asset_group_listing_group_filter.case_value.product_brand.value
FROM asset_group_listing_group_filter
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
```
Run via `/google-ads-get-custom` with query name `pmax_asset_groups`.

## Analysis Steps

1. **Inventory Asset Groups:** List all asset groups per PMax campaign; count and check status
2. **Analyze Structure Logic:** Identify if organized by product, brand, margin tier, or intent
3. **Evaluate Asset Group Quality:** Check ad strength ratings and asset coverage
4. **Check for Structural Issues:** Too many (>10) or too few (<2) asset groups; overlapping products
5. **Assess Performance Correlation:** Identify under/over-performers by asset group

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad Strength "Poor" on any asset group | Critical |
| Ad Strength "Average" on >50% of asset groups | Warning |
| No video assets in any asset group | Warning |
| <10 headlines in any asset group | Warning |
| >10 asset groups per campaign | Info |
| <2 asset groups for diverse catalog | Warning |

## Output

**Short (default):**
```
## PMax Asset Group Structure Audit
**Account:** [name] | **Campaigns:** [count] | **Asset Groups:** [count] | **Issues:** [count]

### Critical
- **[Asset Group]**: Ad Strength Poor - Add [count] headlines, [count] images

### Warnings
- **[Asset Group]**: Missing video assets
- **[Campaign]**: Overlapping product targeting between asset groups

### Recommendations
1. Fix ad strength on [count] asset groups with Poor rating
2. Add video assets to [count] asset groups
3. Restructure [campaign] to separate [products]
```

**Detailed adds:**
- Asset group inventory table with ad strength and product counts
- Asset coverage breakdown (headlines, descriptions, images, videos)
- Recommended structure diagram
- Performance comparison by asset group
