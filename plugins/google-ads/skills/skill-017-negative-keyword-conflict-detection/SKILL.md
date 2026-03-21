---
name: skill-017-negative-keyword-conflict-detection
description: "Identify negative keywords that are blocking or could block desired active keywords, causing ads not to show for intended queries."
allowed-tools: Read, Grep, Glob
---
# Skill 017: Negative Keyword Conflict Detection

## Purpose
Identify negative keywords that are blocking or could block desired active keywords, causing ads not to show for intended queries. Negative/positive conflicts can silently suppress valuable traffic.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/shared_negative_lists.md` - Shared negative keyword lists
- `data/account/campaigns/*/negative_keywords.md` - Campaign-level negatives
- `data/account/campaigns/*/*/negative_keywords.md` - Ad group-level negatives
- `data/account/campaigns/*/*/keywords.md` - Active positive keywords

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.negative
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
```
Use `/google-ads:get-custom` if you need to include shared set data.

## Analysis Steps

1. **Build negative inventory:** Compile all negatives with scope (shared list, campaign, ad group) and match type
2. **Build positive inventory:** Compile all active keywords with match type and location
3. **Detect direct conflicts:** Check if negatives would block positives (exact blocks same text, phrase blocks containing text, broad blocks all-words match)
4. **Check hierarchy conflicts:** Campaign negatives blocking ad group keywords; shared list blocking campaign keywords
5. **Assess severity:** Complete block (keyword fully suppressed) vs. partial/potential block

## Thresholds

| Condition | Severity |
|-----------|----------|
| Negative exactly matches active keyword | Critical |
| Phrase negative contains words from active keyword | Critical |
| Shared list negative blocks campaign keyword | Critical |
| Broad negative words all appear in active keyword | Warning |
| Close variant match possible | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Negative Conflict Detection Audit
**Account:** [Name] | **Conflicts Found:** [X]

### Critical ([Count])
- **"[negative]"** (phrase) blocks **"[keyword]"** → Remove negative or use exact match
- **Shared list** "[list]" blocks campaign keyword → Remove from list

### Warnings ([Count])
- **"[negative]"** (broad) may block **"[keyword]"** → Review and test

### Recommendations
1. Remove or modify [X] blocking negatives
2. Change [X] phrase negatives to exact match
```

**Detailed** adds:
- What Was Checked (negative sources, match type logic)
- Direct conflicts table (Negative, Match, Level, Positive Blocked, Location, Severity)
- Hierarchy conflicts table (Negative, Level, Positive, Level, Impact)
- Resolution recommendations for each conflict
