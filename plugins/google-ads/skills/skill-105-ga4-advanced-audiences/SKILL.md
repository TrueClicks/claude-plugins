---
name: skill-105-ga4-advanced-audiences
description: "Audit GA4 behavioral audiences (5+ sessions, pricing page visitors, engaged users) synced to Google Ads."
allowed-tools: Read, Grep, Glob
---
# Skill 105: GA4 Advanced Audience Creation

## Purpose
Audit GA4 behavioral audiences synced to Google Ads. GA4 enables targeting depth impossible with Google Ads alone, with behavioral audiences converting 50-100% better than page-view lists.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/account_summary.md` - GA4 linkage status
- `data/account/campaigns/*/audience_targeting.md` - Audience usage

**Reference GAQL:**
```sql
SELECT
  user_list.name,
  user_list.type,
  user_list.size_for_display,
  user_list.size_for_search
FROM user_list
WHERE user_list.type IN ('RULE_BASED', 'LOGICAL')
```
Use `/google-ads-get-custom` for audience inventory.

**Note:** Full GA4 audience audit requires GA4 property access.

## Analysis Steps

1. **Verify GA4 Linkage:** Check if GA4 property is linked with bidirectional sharing
2. **Inventory GA4 Audiences:** Identify audiences originating from GA4
3. **Categorize Audience Types:** Basic, engagement-based, behavior-based, predictive
4. **Identify Gaps:** Missing high-value audiences (engaged users, pricing viewers)

## Thresholds

| Condition | Severity |
|-----------|----------|
| No GA4 linked to Google Ads | Critical |
| GA4 linked but no audiences imported | Warning |
| No engagement-based audiences | Warning |
| No pricing/demo page visitor audience | Warning |
| Predictive audiences not enabled (if eligible) | Info |

## Output

**Short (default):**
```
## GA4 Audience Audit
**Account:** [name] | **GA4 Linked:** [Yes/No] | **GA4 Audiences:** [count] | **Issues:** [count]

### Critical
- **GA4 not linked** - Cannot import behavioral audiences

### Warnings
- **No engagement-based audiences** - Create 3+ sessions audience
- **No pricing page visitors** - High-intent segment missing

### Recommendations
1. Link GA4 with bidirectional data sharing
2. Create "High Engagement" audience (3+ sessions, 3+ min)
3. Create "Pricing Page Visitors" audience (14-day window)
```

**Detailed adds:**
- GA4 audience inventory table
- Recommended audiences by type (engagement, behavior, funnel stage)
- Predictive audience eligibility check
- Sequential/combined audience opportunities
