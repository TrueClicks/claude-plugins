---
name: skill-032-ad-copy-ab-testing
description: "Ensure continuous ad testing is in place with proper structure and statistical rigor."
allowed-tools: Read, Grep, Glob
---
# Skill 032: Ad Copy A/B Testing Program

## Purpose

Continuous ad testing is essential for improving performance. Without active testing, accounts stagnate. This audit verifies each ad group has multiple RSAs for testing and identifies ad groups lacking adequate test coverage, especially high-traffic ones.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - All RSAs per ad group
- `data/performance/campaigns/*/*/ads_metrics_30_days.md` - Ad performance

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.type,
  ad_group_ad.ad_strength,
  ad_group_ad.status,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.conversions,
  metrics.cost_micros
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY campaign.name, ad_group.name
```
Use `/google-ads:get-custom` for detailed ad-level performance.

## Analysis Steps

1. **Count ads per ad group:** Google recommends 1-3 RSAs per ad group for optimal testing
2. **Identify testing gaps:** Ad groups with 0 RSAs (no ads), 1 RSA (no testing), 4+ RSAs (too many)
3. **Analyze test differentiation:** Are RSAs actually different? Flag tests that are too similar
4. **Evaluate test performance:** Impression distribution, statistical significance, identify winners/losers
5. **Prioritize by traffic:** High-traffic ad groups without testing are highest priority

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad group with 0 RSAs | Critical |
| High-traffic ad group with 1 RSA | Critical |
| Ad group with 1 RSA | Warning |
| Ad group with 4+ RSAs | Warning |
| RSAs >80% similar in same ad group | Warning |

## Output

**Short (default):**
```
## Ad Testing Audit
**Account:** [Name] | **Ad Groups:** [X] | **Without Testing:** [Y]%

### Critical ([Count])
- **[Campaign] / [Ad Group]**: [X] monthly clicks, only 1 RSA -> Add 1-2 test RSAs

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: [Issue] -> [Fix]

### Testing Status
| Status | Ad Groups | % |
|--------|-----------|---|
| Active (2-3 RSAs) | X | X% |
| No testing (1 RSA) | X | X% |
| Over-testing (4+) | X | X% |
| No ads (0) | X | X% |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Test performance analysis with statistical significance
- Similar RSA pairs flagged
- Test result summary (winners, losers, inconclusive)
