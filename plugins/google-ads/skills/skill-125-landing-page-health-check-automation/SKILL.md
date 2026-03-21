---
name: skill-125-landing-page-health-check-automation
description: "Audit destination URLs for errors, redirects, and issues that waste ad spend and trigger disapprovals."
allowed-tools: Read, Grep, Glob
---
# Skill 125: Landing Page Health Check

## Purpose

Extract all destination URLs from ads and keywords, then audit for technical issues (404 errors, slow load times, SSL problems, redirect chains) that waste ad spend and hurt Quality Score.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Ad final URLs
- `data/account/campaigns/*/*/keywords.md` - Keyword-level URLs (if present)

**GAQL Query (for landing page performance):**
```sql
SELECT
  landing_page_view.unexpanded_final_url,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM landing_page_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.clicks DESC
```
Run via `/google-ads:get-custom` with query name `landing_page_performance`.

## Analysis Steps

1. **Extract URL inventory:** Compile all unique final URLs from ads and keywords
2. **Fetch landing page metrics:** Get performance data per URL via GAQL
3. **Identify high-traffic URLs:** Prioritize URLs with significant spend/clicks
4. **Cross-reference with ad disapprovals:** Check for destination-related policy issues
5. **Calculate wasted spend:** Estimate cost on URLs with known issues

## Thresholds

| Condition | Severity |
|-----------|----------|
| 404/500 error on active URL | Critical |
| SSL certificate expired/invalid | Critical |
| Redirect chain > 3 hops | Warning |
| Load time > 5 seconds | Warning |
| Non-mobile-friendly with mobile traffic | Warning |

## Output

**Short format (default):**
```
## Landing Page Health Audit

**Account:** [Name] | **URLs Checked:** [X] | **Issues:** [Y]

### Critical - Immediate Fix ([Count])
- **[URL]**: 404 error, [X] clicks wasted → Pause ads or fix URL
- **[URL]**: SSL expired → Renew certificate

### Warnings ([Count])
- **[URL]**: Redirect chain ([X] hops) → Update to final URL
- **[URL]**: Slow load ([X]s) → Optimize page speed

### Wasted Spend
$[Amount] spent on broken/problematic URLs in last 30 days

### Recommendations
1. Fix [X] broken URLs immediately
2. Reduce redirect chains on [Y] URLs
```

**Detailed adds:**
- Full URL inventory with health status
- Performance metrics per URL
- Redirect chain details
- Mobile-friendliness assessment
