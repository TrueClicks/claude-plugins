---
name: skill-035-image-asset-optimization
description: "Check that high-resolution, properly formatted image assets are uploaded for campaigns that support them."
allowed-tools: Read, Grep, Glob
---
# Skill 035: Image Asset Optimization

## Purpose

Image assets increase ad visibility and engagement, particularly on mobile. Campaigns without images or with low-quality images miss opportunities for higher CTR. This audit ensures image assets are properly configured for Search extensions, Performance Max, and Demand Gen campaigns.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export does not include image asset details.

**GAQL Query (customer-level images):**
```sql
SELECT
  asset.id,
  asset.name,
  asset.type,
  asset.image_asset.file_size,
  asset.image_asset.full_size.height_pixels,
  asset.image_asset.full_size.width_pixels,
  asset.image_asset.mime_type,
  customer_asset.status
FROM customer_asset
WHERE asset.type = 'IMAGE'
```

**GAQL Query (campaign-level):**
```sql
SELECT
  campaign.name,
  asset.type,
  asset.image_asset.full_size.height_pixels,
  asset.image_asset.full_size.width_pixels,
  campaign_asset.status,
  metrics.impressions,
  metrics.clicks
FROM campaign_asset
WHERE asset.type = 'IMAGE'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `image_assets`.

## Analysis Steps

1. **Identify image-eligible campaigns:** Search (extensions), Performance Max (required), Demand Gen (required), Display
2. **Inventory current images:** Count by level, dimensions, file sizes
3. **Verify specifications:** Square 1:1 (1200x1200), Landscape 1.91:1 (1200x628), Portrait 4:5 (960x1200)
4. **Check coverage gaps:** Campaigns without images, missing aspect ratios, insufficient quantity
5. **Assess quality:** Resolution meets minimums, no excessive text, proper ratios

## Thresholds

| Condition | Severity |
|-----------|----------|
| PMax campaign without images | Critical |
| Image below minimum resolution | Warning |
| Non-standard aspect ratio | Warning |
| Fewer than 3 images per ratio (PMax) | Warning |
| Search campaign without image extension | Info |

## Output

**Short (default):**
```
## Image Asset Audit
**Account:** [Name] | **Images:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]** (PMax): No images -> Upload square + landscape + portrait

### Warnings ([Count])
- **[X] images** below recommended resolution -> Replace with 1200px versions
- **[Campaign]**: Missing portrait (4:5) images

### Coverage
| Campaign Type | Campaigns | With Images | Status |
|---------------|-----------|-------------|--------|
| Performance Max | X | X | OK/Missing |
| Search | X | X | OK/Add |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Image specification audit table
- Resolution and aspect ratio analysis
- PMax asset group coverage matrix
