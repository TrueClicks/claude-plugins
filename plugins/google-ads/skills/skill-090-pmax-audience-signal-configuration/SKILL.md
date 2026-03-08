---
name: skill-090-pmax-audience-signal-configuration
description: "Verify that Performance Max campaigns have proper audience signals configured, including Customer Match lists, GA4 audiences, and custom segments."
allowed-tools: Read, Grep, Glob
---
# Skill 090: Performance Max Audience Signal Configuration

## Purpose
Verify that Performance Max campaigns have proper audience signals configured. Strong audience signals guide the algorithm toward high-value prospects and improve campaign efficiency.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include asset group audience signal details.

**GAQL Query - Audience Signals:**
```sql
SELECT
  campaign.name,
  asset_group.name,
  asset_group.id,
  asset_group_signal.audience.audience
FROM asset_group_signal
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
```

**GAQL Query - User Lists:**
```sql
SELECT
  user_list.name,
  user_list.id,
  user_list.type,
  user_list.size_for_display,
  user_list.size_for_search,
  user_list.membership_status,
  user_list.match_rate_percentage
FROM user_list
WHERE user_list.type IN ('CRM_BASED', 'RULE_BASED', 'LOGICAL')
```
Run via `/google-ads-get-custom` with query name `pmax_audience_signals`.

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Audience configurations (if available)

## Analysis Steps

1. **Inventory Audience Signals:** List signals per asset group; identify asset groups without signals
2. **Evaluate Signal Quality:** Check Customer Match sizes, match rates, GA4 audience integration
3. **Assess Signal Coverage:** Verify full-funnel representation (top, mid, bottom, post-conversion)
4. **Identify Gaps:** Missing first-party data, no remarketing audiences, over-reliance on auto-targeting

## Thresholds

| Condition | Severity |
|-----------|----------|
| No audience signals on any asset group | Critical |
| No first-party signals on any PMax campaign | Critical |
| Customer Match <1,000 matched users | Warning |
| Customer Match list >90 days old | Warning |
| No GA4 audiences linked | Warning |
| <3 signal types per asset group | Info |

## Output

**Short (default):**
```
## PMax Audience Signal Audit
**Account:** [name] | **Asset Groups:** [count] | **Without Signals:** [count] | **Issues:** [count]

### Critical
- **[count] asset groups have no audience signals** - Algorithm has no guidance
- **No first-party data signals** - Add Customer Match or GA4 audiences

### Warnings
- **Customer Match list outdated** ([list]) - Update within 30 days
- **[count] asset groups lack GA4 audiences** - Import from Analytics

### Recommendations
1. Add Customer Match to all [count] asset groups
2. Connect GA4 and import purchaser audiences
3. Create cart abandoner audience for bottom-funnel signals
```

**Detailed adds:**
- Signal type distribution table
- First-party data signal inventory with sizes and match rates
- Funnel coverage assessment (top/mid/bottom)
- Recommended signal structure for each asset group
