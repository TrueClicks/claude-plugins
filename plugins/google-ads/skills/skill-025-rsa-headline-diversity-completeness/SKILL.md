---
name: skill-025-rsa-headline-diversity-completeness
description: "Verify that RSAs have 10-15 unique headlines for optimal ad strength and combination testing."
allowed-tools: Read, Grep, Glob
---
# Skill 025: RSA Headline Diversity and Completeness

## Purpose

Google recommends 10-15 unique headlines per RSA to maximize ad combinations and allow effective algorithm testing. RSAs with fewer headlines limit Google's ability to find winning combinations. Insufficient diversity leads to repetitive messaging and reduced relevance.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA headlines, descriptions, ad strength

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.final_urls,
  ad_group_ad.ad_strength,
  ad_group_ad.status
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status != 'REMOVED'
```
Use `/google-ads:get-custom` if you need ad strength details or performance metrics.

## Analysis Steps

1. **Count headlines per RSA:** Min 3 (required), recommended 10+, max 15
2. **Assess headline diversity:** Check for duplicates, near-duplicates (>70% word overlap), repetitive messaging
3. **Identify missing themes:** Brand mentions, value propositions, CTAs, features/benefits, trust signals, urgency
4. **Analyze character length distribution:** Mix of short and long headlines recommended
5. **Correlate with Ad Strength:** Lower headline count typically causes lower Ad Strength

## Thresholds

| Condition | Severity |
|-----------|----------|
| Headlines < 5 | Critical |
| Headlines 5-9 | Warning |
| Headlines 10-14 | Info |
| Duplicate headlines in same RSA | Critical |
| Similar headlines (>70% overlap) > 2 pairs | Warning |

## Output

**Short (default):**
```
## RSA Headline Audit
**Account:** [Name] | **RSAs:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: [X] headlines (need [Y] more), Ad Strength: [Z]

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: [Issue] -> [Fix]

### Summary
| Headline Count | RSAs | % |
|----------------|------|---|
| 15 | X | X% |
| 10-14 | X | X% |
| 5-9 | X | X% |
| <5 | X | X% |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Missing themes analysis per RSA
- Headline diversity scoring
- Suggested headlines by theme category
