---
name: skill-003-naming-convention-consistency
description: "Audit naming conventions across all campaigns, ad groups, and labels for a standardized taxonomy."
allowed-tools: Read, Grep, Glob
---
# Skill 003: Campaign Naming Convention Consistency

## Purpose
Audit naming conventions across all campaigns, ad groups, and labels for a standardized taxonomy. Inconsistent naming makes reporting unreliable, cross-account management chaotic, and automation rules fragile.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - All campaign names
- `data/account/campaigns/*/*/ad_group.md` - All ad group names

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.advertising_channel_type
FROM campaign
WHERE campaign.status != 'REMOVED'
```
Use `/google-ads-get-custom` if you need to include labels or additional metadata.

## Analysis Steps

1. **Extract all entity names:** List all campaign and ad group names from the data files
2. **Detect naming patterns:** Identify delimiters (-, _, |, /) and common segments (Region, Product, Network, Match Type)
3. **Analyze consistency:** Group by detected pattern, calculate percentage using each, flag outliers
4. **Check for problems:** Very long names (>100 chars), special characters, duplicates, non-descriptive names ("Campaign 1", "Test")
5. **Recommend taxonomy:** Suggest format based on majority pattern or best practice

## Thresholds

| Condition | Severity |
|-----------|----------|
| Consistency score < 50% | Critical |
| Duplicate campaign/ad group names | Critical |
| Consistency score < 80% | Warning |
| Non-descriptive names ("Test", "Campaign 1") | Warning |
| Name > 100 characters | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Naming Convention Audit
**Account:** [Name] | **Analyzed:** [X] campaigns, [Y] ad groups | **Consistency:** [Z]%

### Critical ([Count])
- **Duplicate names:** "[Name]" appears [X] times → Rename to differentiate

### Warnings ([Count])
- **[Entity]**: Non-descriptive name → Rename to [Suggested]

### Recommendations
1. Adopt format: [Region]_[Brand/NB]_[Product]_[Network]
2. Rename [X] non-conforming entities
```

**Detailed** adds:
- What Was Checked (patterns detected, delimiter analysis)
- Pattern breakdown table with counts and percentages
- Before/After rename suggestions for each entity
