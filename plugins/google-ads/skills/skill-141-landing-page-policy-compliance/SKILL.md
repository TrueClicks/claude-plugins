---
name: skill-141-landing-page-policy-compliance
description: "Audit landing pages for policy compliance including privacy policy, SSL, and content requirements."
allowed-tools: Read, Grep, Glob
---
# Skill 141: Landing Page Policy Compliance

## Purpose

Audit destination URLs for Google Ads policy compliance requirements including privacy policy presence, SSL certificates, mobile-friendliness, and content alignment with ads. Non-compliant pages cause ad disapprovals and hurt Quality Score.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Final URLs from ads
- `data/account/campaigns/*/*/keywords.md` - Keyword-level URLs

**GAQL Query (for landing page inventory):**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.final_urls,
  ad_group_ad.ad.final_mobile_urls,
  ad_group_ad.policy_summary.approval_status
FROM ad_group_ad
WHERE ad_group_ad.status = 'ENABLED'
```
Run via `/google-ads-get-custom` with query name `landing_page_urls`.

## Analysis Steps

1. **Extract URL inventory:** Compile unique final URLs from ads and keywords
2. **Check technical compliance:** SSL, accessibility, mobile-friendliness
3. **Verify content requirements:** Privacy policy, contact info, business name
4. **Cross-reference disapprovals:** Match URLs to destination-related policy issues
5. **Prioritize fixes:** Order by traffic volume and policy risk

## Thresholds

| Condition | Severity |
|-----------|----------|
| Missing privacy policy on high-traffic URL | Critical |
| SSL certificate invalid or expired | Critical |
| 404 error on active landing page | Critical |
| Missing contact information | Warning |
| Slow load time (>5 seconds) | Warning |
| Non-mobile-friendly page | Warning |

## Output

**Short format (default):**
```
## Landing Page Policy Audit

**Account:** [Name] | **URLs Audited:** [X] | **Compliance Issues:** [Y]

### Compliance Summary
| Requirement | Compliant | Issues |
|-------------|-----------|--------|
| Privacy Policy | [X] | [Y] |
| SSL Certificate | [X] | [Y] |
| Contact Info | [X] | [Y] |
| Mobile-Friendly | [X] | [Y] |

### Critical Issues
- **[URL]**: Missing privacy policy → Add to footer
- **[URL]**: SSL expired → Renew certificate

### Warnings
- **[URL]**: No contact info → Add phone/email
- **[URL]**: Slow load time → Optimize page

### Compliance Checklist
| Domain | Privacy | SSL | Contact | Mobile |
|--------|---------|-----|---------|--------|
| example.com | Yes | Valid | Yes | Yes |
| example2.com | No | Valid | No | Yes |

### Recommendations
1. Add privacy policy to [X] landing pages
2. Fix SSL on [Y] URLs
3. Add contact info to [Z] pages
```

**Detailed adds:**
- Full URL compliance audit table
- Policy requirement reference
- Fix instructions by issue type
- Monitoring schedule recommendations
