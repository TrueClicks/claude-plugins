---
name: skill-030-ad-extension-coverage-audit
description: "Verify all extension types are active and linked at appropriate levels."
allowed-tools: Read, Grep, Glob
---
# Skill 030: Ad Extension Coverage Audit

## Purpose

Ad extensions increase ad real estate and improve CTR by 10-15%. Missing extensions mean lost opportunities. This audit ensures comprehensive extension coverage at account, campaign, and ad group levels for all relevant extension types.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/ext_sitelinks.md` - Sitelink extensions
- `data/account/ext_callouts.md` - Callout extensions
- `data/account/ext_structured_snippets.md` - Structured snippet extensions
- `data/account/ext_call.md` - Call extensions
- `data/account/ext_price.md` - Price extensions
- `data/account/ext_promotion.md` - Promotion extensions
- `data/account/campaigns/*/campaign.md` - Campaign settings

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  campaign.status,
  asset.type,
  campaign_asset.status,
  campaign_asset.field_type
FROM campaign_asset
WHERE campaign.status != 'REMOVED'
```
Use `/google-ads:get-custom` for account-level asset inventory or performance data.

## Analysis Steps

1. **Inventory all extension types:** Read ext_*.md files, categorize by type and linking level
2. **Check coverage requirements:** Sitelinks (4+ recommended), Callouts (4+), Structured snippets (1+)
3. **Verify linking hierarchy:** Account-level applies to all, campaign overrides account, ad group overrides campaign
4. **Assess extension status:** Enabled vs Paused, Approved vs Disapproved
5. **Evaluate quality:** Sitelinks with descriptions, unique callouts, relevant snippet headers

## Thresholds

| Condition | Severity |
|-----------|----------|
| No sitelinks at any level | Critical |
| No callouts at any level | Critical |
| Sitelinks < 4 | Warning |
| Callouts < 4 | Warning |
| No structured snippets | Warning |
| Disapproved extension | Critical |

## Output

**Short (default):**
```
## Extension Coverage Audit
**Account:** [Name] | **Extension Types:** [X]/8 | **Issues:** [Y]

### Critical ([Count])
- **No [extension type]** at account level -> Add [X] [extension type]

### Warnings ([Count])
- **Sitelinks**: [X] (need [Y] more)

### Coverage Matrix
| Type | Account | Campaigns | Status |
|------|---------|-----------|--------|
| Sitelinks | X | X override | OK/Missing |
| Callouts | X | X | OK/Missing |
| Snippets | X | X | OK/Missing |
| Call | X | X | OK/Missing |

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Full extension inventory with linking details
- Campaign-level coverage matrix
- Extension quality issues (missing descriptions, generic URLs)
