---
name: skill-162-creative-asset-quality-ai-campaign-optimization
description: "Assess whether campaigns provide diverse, high-quality modular creative across text, image, and video."
allowed-tools: Read, Grep, Glob
---
# Skill 162: Creative Asset Quality for AI Campaign Optimization

## Purpose
Audit creative asset coverage and quality for AI-driven campaigns (PMax, Demand Gen, AI Max for Search). AI campaigns can only optimize effectively when given sufficient creative variety - limited assets constrain machine learning's ability to test combinations and find optimal assemblies.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/ad_groups/*/ads.md` - RSA headlines and descriptions
- `data/account/campaigns/*/campaign.md` - Campaign types (identify PMax, Demand Gen)

**Reference GAQL (Asset Performance):**
```sql
SELECT
  asset.name,
  asset.type,
  asset.text_asset.text
FROM asset_group_asset
WHERE asset_group_asset.status = 'ENABLED'
```
Use `/google-ads-get-custom` for asset-level performance ratings and PMax asset group details.

## Analysis Steps

1. **Inventory text assets:** Count headlines and descriptions, assess diversity (keyword, benefit, CTA, proof, urgency themes)
2. **Assess image coverage:** Check for landscape (1.91:1), square (1:1), portrait (4:5), and logo variations
3. **Check video availability:** Verify custom videos vs. auto-generated, multiple aspect ratios
4. **Review asset performance:** Identify "Low" rated assets needing replacement
5. **Evaluate asset group structure:** For PMax, verify distinct themes per asset group

## Thresholds

| Condition | Severity |
|-----------|----------|
| Missing required image ratio (portrait 4:5 for PMax) | Critical |
| No custom video (using auto-generated only) | Critical |
| <10 unique headlines in RSA/PMax | Warning |
| 3+ headlines with same theme (redundant) | Warning |
| Assets rated "Low" for >30 days | Warning |
| Missing wide logo (4:1) | Info |

## Output

**Short format (default):**
```
## Creative Asset Audit
**Account:** [Name] | **AI campaigns:** [X] | **Asset gaps:** [Y]

### Critical ([Count])
- **[Campaign]**: Missing portrait images (4:5) -> Create 3-5 images
- **[Campaign]**: No custom video -> Produce 10-30 sec video

### Warnings ([Count])
- **Headlines**: [X] redundant themes -> Replace with diverse messaging
- **[Asset]**: Rated "Low" -> Replace with fresh creative

### Asset Coverage
| Type | Required | Provided | Gap |
|------|----------|----------|-----|
| Headlines | 10-15 | X | [Y] |
| Landscape | 3+ | X | [Y] |
| Portrait | 3+ | X | [Y] |
| Video | 1+ | X | [Y] |

### Recommendations
1. Create [asset type] - Expected +[X]% delivery
```

**Detailed adds:**
- Asset-by-asset inventory with quality ratings
- Headline diversity analysis by theme category
- Image/video specification requirements
- Asset group structure recommendations for PMax
