---
name: skill-034-ad-copy-landing-page-consistency
description: "Verify alignment between ad messaging and landing page content."
allowed-tools: Read, Grep, Glob
---
# Skill 034: Ad Copy-to-Landing Page Message Consistency

## Purpose

Message match between ads and landing pages is critical for user experience, Quality Score (Landing Page Experience), and conversion rates. When users click ads promising one thing but land on pages about something else, they bounce. This audit identifies messaging misalignments.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA headlines, descriptions, final URLs
- `data/account/campaigns/*/*/keywords.md` - Keywords for context

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.ad.final_urls,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.clicks DESC
```
Use `/google-ads:get-custom` for high-traffic ad prioritization.

## Analysis Steps

1. **Extract ad messaging elements:** Headlines, descriptions, final URLs - identify key promises, offers, CTAs
2. **Categorize messaging themes:** Offers (discounts, free shipping), features, benefits, trust signals
3. **Map ads to landing pages:** Group by final URL, note unique URLs per campaign
4. **Identify potential mismatches:** Ad mentions offer not on page, different products highlighted, conflicting CTAs
5. **Prioritize by traffic:** Focus on high-click landing pages first

## Thresholds

| Condition | Severity |
|-----------|----------|
| Ad mentions specific offer not verifiable on page | Critical |
| All ads point to homepage | Warning |
| Ad CTA doesn't match page CTA | Warning |
| Time-sensitive offer in ad (needs verification) | Warning |

## Output

**Short (default):**
```
## Ad-Landing Page Consistency Audit
**Account:** [Name] | **Unique URLs:** [X] | **Potential Mismatches:** [Y]

### Critical ([Count])
- **"[Ad headline/promise]"** -> [URL]: Verify [offer/claim] is visible on page

### Warnings ([Count])
- **[X] ad groups** point to homepage -> Create specific landing pages
- **"[Time-sensitive offer]"**: Verify promotion is current

### High-Traffic URLs to Review
| URL | Clicks | Ad Promises | Verify |
|-----|--------|-------------|--------|

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Full ad-to-URL mapping table
- Promises checklist by landing page
- URL diversity analysis by campaign
