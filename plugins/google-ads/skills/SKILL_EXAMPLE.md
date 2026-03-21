# Example: Properly Structured Skill

This shows what a skill should look like following the schema.

---

## Before (Too Verbose - 250 lines)

The original skill-030 had:
- Multiple verbose output tables with template placeholders
- "Example Findings" that duplicated the output format
- Implementation checklists
- Excessive explanatory text

## After (Concise - 85 lines)

```markdown
---
name: skill-030-ad-extension-coverage-audit
description: "Verify all extension types are active and linked at appropriate levels."
allowed-tools: Read, Grep, Glob
---
# Skill 030: Ad Extension Coverage Audit

## Purpose
Verify that all recommended extension types (sitelinks, callouts, structured snippets) are active and linked at appropriate levels. Missing extensions reduce ad real estate and CTR by 10-15%.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/ext_sitelinks.md` - Sitelink extensions
- `data/account/ext_callouts.md` - Callout extensions
- `data/account/ext_structured_snippets.md` - Structured snippets
- `data/account/ext_call.md` - Call extensions
- `data/account/campaigns/*/campaign.md` - Campaign settings

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  asset.type,
  asset.sitelink_asset.link_text,
  campaign_asset.status
FROM campaign_asset
WHERE campaign.status = 'ENABLED'
```
Use `/google-ads:get-custom` if you need extension performance metrics.

## Analysis Steps

1. **Inventory extensions:** Count each extension type and their linking level (account/campaign/ad group)
2. **Check minimum counts:** Verify sitelinks >= 4, callouts >= 4, structured snippets >= 1
3. **Identify gaps:** Find campaigns/ad groups missing required extensions
4. **Check status:** Flag disapproved or paused extensions
5. **Assess quality:** Sitelinks should have descriptions, callouts should be unique

## Thresholds

| Condition | Severity |
|-----------|----------|
| No sitelinks at any level | Critical |
| Sitelinks < 4 | Warning |
| No callouts at any level | Critical |
| Callouts < 4 | Warning |
| No structured snippets | Warning |
| Disapproved extension | Critical |
| Sitelinks missing descriptions | Warning |

## Output Schema

Report ONLY issues found.

### Extension Gaps
| Extension Type | Current | Minimum | Gap |
|----------------|---------|---------|-----|

### Campaign Gaps
| Campaign | Missing Extensions |
|----------|-------------------|

### Quality Issues
| Extension | Issue |
|-----------|-------|

### Recommendations
1. [Specific action to fix highest priority gap]
2. [Next priority action]
```

---

## Key Differences

| Aspect | Before | After |
|--------|--------|-------|
| Length | 250 lines | 85 lines |
| Output tables | Show all (pass + fail) | Issues only |
| Example Findings | 50 lines duplicating format | Removed (unnecessary) |
| Explanatory text | Multiple paragraphs | 2-3 sentences max |
| Recommendations | Generic best practices | Specific actions |

---

## Output Example (What Claude Produces)

When this skill is executed, Claude should output:

```markdown
## Ad Extension Coverage Audit

**Account:** TrueClicks - Dev Test
**Campaigns Analyzed:** 2

### Issues Found (3)

#### Critical (1)

1. **No call extensions configured**
   - Impact: Missing phone lead opportunities
   - Fix: Add call extension with business phone number

#### Warnings (2)

1. **Sitelinks missing descriptions** (3 of 4 sitelinks)
   - Fix: Add description lines 1 & 2 to all sitelinks

2. **No structured snippets**
   - Fix: Add at least one structured snippet (Types, Services, or Brands)

### Summary
- Extension types present: 2/6 (sitelinks, callouts)
- Missing: call, structured snippets, price, promotion

### Recommendations
1. Add call extension immediately
2. Complete sitelink descriptions
3. Add structured snippet with service types
```

**Note:** No "passing" extensions are listed. No educational content about why extensions matter.
