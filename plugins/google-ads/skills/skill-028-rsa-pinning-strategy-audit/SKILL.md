---
name: skill-028-rsa-pinning-strategy-audit
description: "Check for over-pinning in RSAs that limits Google's optimization ability."
allowed-tools: Read, Grep, Glob
---
# Skill 028: RSA Pinning Strategy Audit

## Purpose

Pinning headlines or descriptions to specific positions restricts ad combinations Google can test. Strategic pinning (brand name to H1) is acceptable, but over-pinning (3+ pins) significantly reduces optimization ability and lowers Ad Strength.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA headlines/descriptions with pinned positions

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.ad_strength,
  ad_group_ad.status
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status != 'REMOVED'
```
Note: Headlines array includes `pinned_field` property (HEADLINE_1, HEADLINE_2, HEADLINE_3) or null.

## Analysis Steps

1. **Count pinned assets per RSA:** Total pinned headlines and descriptions
2. **Evaluate pinning impact:** Calculate possible combinations reduction (>50% reduction is problematic)
3. **Assess pinning strategy:** Brand H1 only (acceptable), H1+CTA (acceptable), 3+ headline pins (problematic), all positions pinned (defeats RSA purpose)
4. **Correlate with performance:** Compare pinned vs unpinned RSA performance
5. **Flag conflicting pins:** Multiple assets pinned to same position

## Thresholds

| Condition | Severity |
|-----------|----------|
| 5+ total pins | Critical |
| All H positions pinned (H1+H2+H3) | Critical |
| 3-4 total pins | Warning |
| Combination reduction >90% | Critical |
| 1-2 pins | Info |

## Output

**Short (default):**
```
## RSA Pinning Audit
**Account:** [Name] | **RSAs:** [X] | **Over-pinned:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: [X] pins (H1:[a], H2:[b], H3:[c], D1:[d], D2:[e]) -> Remove [pins]

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: [X] pins -> Consider removing [specific pins]

### Summary
| Pinning Level | RSAs | Avg Ad Strength |
|---------------|------|-----------------|
| None (0 pins) | X | [rating] |
| Light (1-2) | X | [rating] |
| Heavy (3+) | X | [rating] |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Combination impact analysis per RSA
- Specific pin removal recommendations
- Acceptable pinning strategy examples
