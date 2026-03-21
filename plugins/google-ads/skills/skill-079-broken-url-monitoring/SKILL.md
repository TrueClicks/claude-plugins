---
name: skill-079-broken-url-monitoring
description: "Scan landing pages for 4xx and 5xx HTTP errors that waste ad spend and damage user experience."
allowed-tools: Read, Grep, Glob
---
# Skill 079: Broken URL Monitoring

## Purpose
Scan landing pages for 4xx and 5xx HTTP errors that waste ad spend and damage user experience. Broken URLs result in 100% bounce rate on affected clicks, wasted budget, and potential Quality Score penalties.

## Data Requirements

**Data Source:** Standard (plus external URL testing)

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Ad final URLs
- `data/account/ext_sitelinks.md` - Sitelink URLs
- `data/performance/campaigns/*/*/ads_metrics_30_days.md` - Click volume per ad

**Reference GAQL:**
```sql
SELECT
  ad_group_ad.ad.id,
  ad_group_ad.ad.final_urls,
  campaign.name,
  ad_group.name,
  ad_group_ad.status,
  metrics.clicks,
  metrics.cost_micros
FROM ad_group_ad
WHERE segments.date DURING LAST_30_DAYS
  AND ad_group_ad.status = 'ENABLED'
ORDER BY metrics.clicks DESC
```
Use `/google-ads:get-custom` for comprehensive URL extraction.

Note: Actual HTTP status testing requires external tools or scripts.

## Analysis Steps

1. **Extract all landing page URLs:** From ads, keywords (overrides), and extensions.
2. **Deduplicate and prioritize:** Focus on high-traffic URLs first.
3. **Provide URL list for testing:** External verification needed for HTTP status.
4. **Calculate wasted spend:** Clicks to broken URLs x Avg CPC.

## Thresholds

| Condition | Severity |
|-----------|----------|
| 404/410 error on any URL with clicks | Critical |
| 5xx server error on any URL | Critical |
| Redirect chain > 3 hops | Warning |
| 301 redirect (should update to final URL) | Warning |
| HTTP URL (should be HTTPS) | Warning |

## Output

**Short (default):**
```
## Broken URL Monitoring Audit

**Account:** [Name] | **URLs Extracted:** [X] | **To Test:** [Y]

### Priority URLs for HTTP Testing
| URL | Monthly Clicks | Cost |
|-----|----------------|------|
| [URL] | [X] | $[Y] |

### Actions Required
1. Test URLs for HTTP status codes
2. Fix any 4xx/5xx errors immediately
3. Update 301 redirects to final URLs

### Testing Methods
- Browser DevTools Network tab
- cURL: `curl -I [URL]`
- Screaming Frog (bulk)
```

**Detailed adds:**
- Full URL inventory with traffic
- Extension URLs
- Redirect chain analysis
- Wasted spend calculation
