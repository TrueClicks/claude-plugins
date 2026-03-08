---
name: skill-033-dynamic-keyword-insertion-review
description: "Assess whether Dynamic Keyword Insertion is used appropriately and safely."
allowed-tools: Read, Grep, Glob
---
# Skill 033: Dynamic Keyword Insertion Usage Review

## Purpose

Dynamic Keyword Insertion (DKI) automatically inserts triggering keywords into ad copy, increasing relevance. However, improper DKI creates awkward, unprofessional, or policy-violating ads. This review ensures DKI is used strategically and identifies potential issues.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - RSA ad copy (check for DKI syntax)
- `data/account/campaigns/*/*/keywords.md` - Keywords that might trigger DKI

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.id,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  ad_group_ad.status
FROM ad_group_ad
WHERE ad_group_ad.ad.type = 'RESPONSIVE_SEARCH_AD'
  AND ad_group_ad.status != 'REMOVED'
```
Use `/google-ads-get-custom` if you need to filter by specific campaigns.

## Analysis Steps

1. **Identify DKI usage:** Search for `{KeyWord:...}` syntax variants in ads
2. **Check implementation:** Correct capitalization ({KeyWord:} for Title Case), default text present, character limit accommodates longest keyword
3. **Evaluate keyword compatibility:** Flag keywords too long (overflow), awkward phrasing, competitor names, sensitive terms
4. **Assess ad group suitability:** Tight themes = DKI works well, broad/varied = DKI risky
5. **Preview DKI results:** Simulate with actual keywords to catch issues

## Thresholds

| Condition | Severity |
|-----------|----------|
| DKI without default text | Critical |
| Competitor keywords in DKI ad group | Critical |
| Keyword longer than available space | Warning |
| DKI with {KEYWORD:} all caps | Warning |
| Broad match ad group + DKI | Warning |

## Output

**Short (default):**
```
## DKI Usage Audit
**Account:** [Name] | **RSAs with DKI:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign] / [Ad Group]**: DKI without default text: `{KeyWord:}` -> Add default
- **[Campaign] / [Ad Group]**: Competitor keyword + DKI -> Remove DKI

### Warnings ([Count])
- **[Campaign] / [Ad Group]**: Keyword "[text]" (35 chars) exceeds headline space (30 chars)

### DKI Inventory
| Ad Group | DKI Syntax | Position | Default | Status |
|----------|------------|----------|---------|--------|

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Keyword compatibility analysis per ad group
- DKI preview with actual keywords
- Ad group theme tightness assessment
