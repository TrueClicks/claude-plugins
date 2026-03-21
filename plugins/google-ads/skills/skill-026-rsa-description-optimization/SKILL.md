---
name: skill-026-rsa-description-optimization
description: "Ensure all 4 description slots in RSAs are filled with unique, compelling descriptions."
allowed-tools: Read, Grep, Glob
---
# Skill 026: RSA Description Optimization

## Purpose

RSAs support 4 descriptions but serve only 2 at a time. Having all 4 slots filled gives the algorithm more combinations to test and improves ad effectiveness. Unfilled description slots directly limit testing and typically result in lower Ad Strength ratings.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA descriptions, headlines, ad strength

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.ad_strength,
  ad_group_ad.status,
  metrics.impressions
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status != 'REMOVED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` for performance metrics by ad.

## Analysis Steps

1. **Count descriptions per RSA:** Min required 2, recommended 4, max 4
2. **Assess description quality:** Character length utilization (80-90 char optimal), complete sentences
3. **Check diversity:** Different angles in each description, avoid repetitive phrasing
4. **Identify missing elements:** Benefits, CTAs, differentiators, social proof, offers
5. **Correlate with Ad Strength:** Map description count to Ad Strength rating

## Thresholds

| Condition | Severity |
|-----------|----------|
| Descriptions = 2 | Warning |
| Descriptions = 3 | Info |
| Description < 40 characters | Warning |
| Duplicate descriptions | Critical |
| No CTA in any description | Warning |

## Output

**Short (default):**
```
## RSA Description Audit
**Account:** [Name] | **RSAs:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: [X] descriptions, duplicates found -> Replace and add [Y] more

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: [X] descriptions (need [Y] more)

### Summary
| Description Count | RSAs | % |
|-------------------|------|---|
| 4 | X | X% |
| 3 | X | X% |
| 2 | X | X% |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Description quality analysis (length, completeness)
- Missing element checklist per RSA
- Suggested description templates
