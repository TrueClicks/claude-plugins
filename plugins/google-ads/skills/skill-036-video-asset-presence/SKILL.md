---
name: skill-036-video-asset-presence
description: "Verify that video assets are uploaded for Performance Max and Demand Gen campaigns."
allowed-tools: Read, Grep, Glob
---
# Skill 036: Video Asset Presence in PMax and Demand Gen

## Purpose

Performance Max and Demand Gen serve across video placements (YouTube, Discover, Gmail). Without video assets, Google auto-generates low-quality videos from images, which typically underperform. Providing custom video assets gives control over brand messaging and improves video inventory performance.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export does not include video asset details.

**GAQL Query (video assets):**
```sql
SELECT
  asset.id,
  asset.name,
  asset.type,
  asset.youtube_video_asset.youtube_video_id,
  asset.youtube_video_asset.youtube_video_title,
  customer_asset.status
FROM customer_asset
WHERE asset.type = 'YOUTUBE_VIDEO'
```

**GAQL Query (PMax asset groups):**
```sql
SELECT
  campaign.name,
  asset_group.name,
  asset_group_asset.asset,
  asset_group_asset.field_type,
  asset_group_asset.status
FROM asset_group_asset
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND asset_group_asset.field_type = 'YOUTUBE_VIDEO'
```
Run via `/google-ads:get-custom` with query name `video_assets`.

## Analysis Steps

1. **Identify video-required campaigns:** Performance Max (highly recommended), Demand Gen (strongly recommended), Video (required), App
2. **Inventory video assets:** Count by campaign, note specifications (duration, aspect ratio)
3. **Check specifications:** Duration 10-60s (15-30s optimal), aspect ratios (16:9 horizontal, 9:16 vertical, 1:1 square)
4. **Assess coverage:** Each PMax asset group should have videos, identify those relying on auto-generated
5. **Evaluate diversity:** Different lengths, multiple aspect ratios, varied messaging

## Thresholds

| Condition | Severity |
|-----------|----------|
| PMax campaign without videos | Critical |
| Demand Gen without videos | Critical |
| Asset group without videos | Warning |
| Only horizontal videos (no 9:16 or 1:1) | Warning |
| Video > 60 seconds | Warning |

## Output

**Short (default):**
```
## Video Asset Audit
**Account:** [Name] | **PMax/DemandGen:** [X] | **Without Videos:** [Y]

### Critical ([Count])
- **[Campaign]** (PMax): 0 videos -> Upload 16:9 + 9:16 + 1:1 (15-30s each)

### Warnings ([Count])
- **[Campaign]**: Only horizontal videos -> Add vertical (9:16)

### Coverage
| Campaign Type | Campaigns | With Videos | Status |
|---------------|-----------|-------------|--------|
| Performance Max | X | X | OK/Missing |
| Demand Gen | X | X | OK/Missing |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Asset group video coverage matrix
- Video specification analysis (duration, ratio breakdown)
- Auto-generated video risk assessment
