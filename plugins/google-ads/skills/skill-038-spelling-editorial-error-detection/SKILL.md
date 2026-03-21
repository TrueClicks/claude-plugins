---
name: skill-038-spelling-editorial-error-detection
description: "Scan all ad copy for spelling mistakes, grammar errors, excessive punctuation, and capitalization violations."
allowed-tools: Read, Grep, Glob
---
# Skill 038: Spelling and Editorial Error Detection

## Purpose

Editorial errors trigger ad disapprovals and damage brand credibility, reducing CTR and user trust. This skill scans all ad copy for spelling mistakes, grammar errors, excessive punctuation, and capitalization violations before they cause policy issues.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA headlines and descriptions

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.ad.final_urls,
  ad_group_ad.policy_summary.approval_status
FROM ad_group_ad
WHERE ad_group_ad.status != 'REMOVED'
  AND campaign.status = 'ENABLED'
```
Use `/google-ads:get-custom` if you need policy details for already-flagged ads.

## Analysis Steps

1. **Extract all ad text:** Headlines, descriptions, display URLs, paths
2. **Spelling check:** Flag misspelled words, distinguish industry terms vs errors
3. **Grammar analysis:** Subject-verb agreement, incomplete sentences, article usage
4. **Punctuation review:** Excessive exclamation marks (!!!), repeated punctuation, non-standard characters
5. **Capitalization audit:** ALL CAPS violations, gimmicky capitalization (bUy NoW), inconsistent casing
6. **Policy compliance check:** Superlative claims without proof, prohibited symbols

## Thresholds

| Condition | Severity |
|-----------|----------|
| Spelling error in ad | Critical |
| Multiple exclamation marks (>1) | Critical |
| ALL CAPS word | Warning |
| Grammar error | Warning |
| Repeated punctuation | Warning |

## Output

**Short (default):**
```
## Editorial Error Audit
**Account:** [Name] | **Ads Scanned:** [X] | **Errors:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: Headline "[text]" -> Spelling: "[error]" fix to "[correct]"
- **[Campaign] / [Ad Group]**: Description "[text]" -> Excessive punctuation "!!!" fix to "!"

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: ALL CAPS "[FREE SHIPPING]" -> "Free Shipping"

### Error Summary
| Error Type | Count | Examples |
|------------|-------|----------|
| Spelling | X | "recieve", "seperate" |
| Punctuation | X | "Buy Now!!!" |
| Capitalization | X | "FREE", "BEST" |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Full error list by ad with suggested fixes
- Common misspelling patterns
- Policy violation risk assessment
