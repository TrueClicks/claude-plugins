---
name: skill-126-rsa-asset-performance-bulk-analysis
description: "Bulk analyze RSA headline and description performance across all ads to identify top performers and replacement candidates."
allowed-tools: Read, Grep, Glob
---
# Skill 126: RSA Asset Performance Bulk Analysis

## Purpose

Analyze headline and description performance across all Responsive Search Ads to identify top-performing assets to replicate and low-performing assets to replace. This bulk analysis reveals account-wide patterns and optimization opportunities.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA headlines, descriptions, ad strength

**GAQL Query (for asset-level metrics):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.policy_summary.approval_status,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.impressions DESC
```
Run via `/google-ads:get-custom` with query name `rsa_asset_performance`.

## Analysis Steps

1. **Read ad data:** Extract all RSA headlines and descriptions from ads.md files
2. **Fetch performance metrics:** Run GAQL query for RSA-level performance
3. **Aggregate asset performance:** Identify headlines/descriptions used across multiple ads
4. **Identify patterns:** Find high-CTR and high-converting asset themes
5. **Flag low performers:** List assets rated "Low" or with poor performance metrics

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad strength "Poor" with significant spend | Critical |
| Multiple "Low" rated assets in ad | Warning |
| No "Best" rated headlines in ad | Warning |
| Heavy pinning (3+ pins) reducing combinations | Info |

## Output

**Short format (default):**
```
## RSA Asset Performance Audit

**Account:** [Name] | **RSAs Analyzed:** [X] | **Assets Needing Replacement:** [Y]

### Ad Strength Distribution
| Strength | Count |
|----------|-------|
| Excellent | [X] |
| Good | [X] |
| Average | [X] |
| Poor | [X] |

### Top Performing Headlines (Account-Wide)
1. "[Headline]" - [X] impressions, [Y]% CTR
2. "[Headline]" - [X] impressions, [Y]% CTR

### Assets to Replace
- **[Campaign/AdGroup]**: "[Low headline]" → Test "[suggested replacement]"
- **[Campaign/AdGroup]**: "[Low description]" → Replace with benefit-focused copy

### Recommendations
1. Replicate top headlines to other ad groups
2. Replace [X] "Low" rated assets
```

**Detailed adds:**
- Full asset performance table by campaign
- Theme analysis (benefit-focused, CTA-focused, etc.)
- Pinning strategy assessment
- Asset suggestions based on top performers
