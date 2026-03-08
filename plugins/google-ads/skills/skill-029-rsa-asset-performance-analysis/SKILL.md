---
name: skill-029-rsa-asset-performance-analysis
description: "Find Low performing headlines and descriptions to replace with better alternatives."
allowed-tools: Read, Grep, Glob
---
# Skill 029: RSA Asset Performance Analysis

## Purpose

Google rates individual RSA assets (headlines, descriptions) as Best, Good, Low, or Learning. Low-rated assets reduce overall ad effectiveness and should be replaced. This analysis identifies underperformers and suggests replacements based on high-performing asset patterns.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export does not include asset-level performance ratings.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad_asset_view.field_type,
  ad_group_ad_asset_view.performance_label,
  asset.text_asset.text,
  asset.type,
  metrics.impressions,
  metrics.clicks
FROM ad_group_ad_asset_view
WHERE ad_group_ad.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY ad_group_ad_asset_view.performance_label DESC
```
Run via `/google-ads-get-custom` with query name `asset_performance`.

## Analysis Steps

1. **Categorize assets by rating:** Best (keep/replicate), Good (no action), Low (replace), Learning (need data), Unrated (insufficient data)
2. **Identify Low-rated assets:** List all headlines and descriptions rated Low with their campaign/ad group
3. **Analyze low-performer patterns:** Common themes, length patterns, missing elements (CTA, benefit)
4. **Identify high-performer patterns:** What makes Best-rated assets work - use for replacement suggestions
5. **Generate replacement recommendations:** Based on high-performing patterns, maintain diversity

## Thresholds

| Condition | Severity |
|-----------|----------|
| >20% of assets rated Low | Critical |
| Low asset in high-spend campaign | Critical |
| Any asset rated Low | Warning |
| No Best assets in RSA | Warning |
| All assets Learning (new RSA) | Info |

## Output

**Short (default):**
```
## RSA Asset Performance Audit
**Account:** [Name] | **Assets:** [X] | **Low-rated:** [Y]%

### Replace (Low-rated) ([Count])
- **[Campaign] / [Ad Group]**: "[Low asset text]" -> Suggested: "[replacement based on Best patterns]"

### Top Performers to Replicate
- "[Best asset text]" - [X] campaigns, [Y]% CTR

### Summary
| Rating | Headlines | Descriptions |
|--------|-----------|--------------|
| Best | X | X |
| Good | X | X |
| Low | X | X |
| Learning | X | X |

### Recommendations
1. [Priority replacement action]
```

**Detailed adds:**
- Full table of Low assets with replacement suggestions
- Pattern analysis (what Best assets have that Low assets lack)
- Campaign priority based on spend
