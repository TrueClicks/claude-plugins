---
name: skill-078-landing-page-speed
description: "Test landing page load times to ensure pages load in under 3 seconds."
allowed-tools: Read, Grep, Glob
---
# Skill 078: Landing Page Speed

## Purpose
Test landing page load times to ensure pages load in under 3 seconds. Slow landing pages increase bounce rates, reduce Quality Score, and negatively impact conversion rates. Google recommends pages load in under 3 seconds for optimal ad performance.

## Data Requirements

**Data Source:** Standard (plus external testing)

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Final URLs for landing pages
- `data/account/campaigns/*/*/keywords.md` - Landing Page Experience QS component
- `data/performance/campaigns/*/*/ads_metrics_30_days.md` - Traffic to identify high-priority URLs

**Reference GAQL:**
```sql
SELECT
  ad_group_ad.ad.final_urls,
  campaign.name,
  ad_group.name,
  metrics.impressions,
  metrics.clicks
FROM ad_group_ad
WHERE segments.date DURING LAST_30_DAYS
  AND ad_group_ad.status = 'ENABLED'
ORDER BY metrics.impressions DESC
```
Use `/google-ads-get-custom` to get URL-level traffic data.

Note: Actual page speed testing requires external tools (PageSpeed Insights, GTmetrix).

## Analysis Steps

1. **Extract landing page URLs:** Identify all unique final URLs from ads and keywords.
2. **Review LP Experience scores:** Check Landing Page Experience QS component for Below Average.
3. **Prioritize by traffic:** Focus on high-impression, high-click URLs first.
4. **Recommend testing:** Provide URLs to test with PageSpeed Insights.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Landing Page Experience Below Average | Critical |
| High-traffic URL with LP issues | Critical |
| Page load > 5 seconds (if testable) | Critical |
| LCP > 2.5 seconds | Warning |
| Mobile score < 50 | Warning |
| Page load 3-5 seconds | Warning |

## Output

**Short (default):**
```
## Landing Page Speed Audit

**Account:** [Name] | **Unique URLs:** [X] | **LP Experience Issues:** [Y]

### Priority URLs to Test
| URL | Monthly Clicks | LP Experience |
|-----|----------------|---------------|
| [URL] | [X] | [Above/Average/Below] |

### Critical ([Count])
- **[URL]**: Below Average LP Experience, [X] clicks -> Test at pagespeed.web.dev

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Full URL inventory with traffic
- LP Experience by URL
- Testing tool links
- Speed optimization checklist
