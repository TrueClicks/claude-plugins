---
name: skill-106-ga4-google-ads-integration
description: "Confirm GA4 is properly linked with bidirectional data flow, audiences syncing, and key events imported as conversions."
allowed-tools: Read, Grep, Glob
---
# Skill 106: GA4 to Google Ads Integration

## Purpose
Confirm GA4 is properly linked with bidirectional data flow, audiences syncing, and key events imported as conversions. Misaligned platforms create conflicting data that undermines analysis and optimization.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/account_summary.md` - GA4 linkage status
- `data/account/conversion_actions.md` - Conversion sources

**Reference GAQL:**
```sql
SELECT
  conversion_action.name,
  conversion_action.type,
  conversion_action.origin,
  conversion_action.status
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Use `/google-ads-get-custom` to verify conversion action sources.

## Analysis Steps

1. **Verify Account Linkage:** Check for GA4 connection in account summary
2. **Assess Data Sharing:** Verify auto-tagging enabled, bidirectional sharing active
3. **Review Imported Conversions:** Identify GA4 events imported as conversions
4. **Evaluate Audience Sync:** Check if GA4 audiences are flowing to Google Ads

## Thresholds

| Condition | Severity |
|-----------|----------|
| No GA4 property linked | Critical |
| Auto-tagging disabled | Critical |
| GA4 linked but no conversions imported | Warning |
| Duplicate tracking (GA4 + Ads tag for same action) | Warning |
| GA4 audiences not syncing | Warning |

## Output

**Short (default):**
```
## GA4 Integration Audit
**Account:** [name] | **GA4 Linked:** [Yes/No] | **Auto-Tagging:** [On/Off] | **Issues:** [count]

### Critical
- **Auto-tagging disabled** - Enable for proper attribution
- **No GA4 property linked** - Missing cross-platform data

### Warnings
- **Duplicate conversion tracking** - [action] tracked by both GA4 and Ads tag
- **No GA4 audiences syncing** - Check sharing settings

### Recommendations
1. Enable auto-tagging in Google Ads account settings
2. Link GA4 with bidirectional data sharing
3. Choose single conversion source (recommend GA4) to avoid duplicates
```

**Detailed adds:**
- Integration status checklist
- Conversion action source comparison
- Attribution model alignment check
- Audience sync status table
