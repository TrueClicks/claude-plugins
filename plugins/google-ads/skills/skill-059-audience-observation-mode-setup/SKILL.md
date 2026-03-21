---
name: skill-059-audience-observation-mode-setup
description: "Add relevant audience segments in Observation mode to gather performance data without restricting reach."
allowed-tools: Read, Grep, Glob
---
# Skill 059: Audience Observation Mode Setup

## Purpose

Observation mode allows collecting audience performance data without restricting ad delivery. This skill reviews current audience setup, identifies campaigns missing observation audiences, and recommends relevant segments to add for data collection and future optimization.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/audience_targeting.md` - Campaign audience setup
- `data/account/campaigns/*/*/audience_targeting.md` - Ad group audiences

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.criterion_id,
  ad_group_criterion.type,
  ad_group_criterion.user_interest.user_interest_category,
  ad_group_criterion.user_list.user_list,
  ad_group_criterion.bid_modifier
FROM ad_group_audience_view
WHERE campaign.status != 'REMOVED'
```
Use `/google-ads:get-custom` if audience details are not in standard export.

## Analysis Steps

1. **Review current audience setup:** Read audience targeting files, identify audiences in Targeting vs Observation mode, find campaigns with no audience setup.

2. **Identify missing observation audiences:** Compare current setup against recommended categories, prioritize remarketing audiences, consider in-market and affinity segments.

3. **Generate setup recommendations:** List campaigns without observation audiences, recommend specific audiences by business type, provide implementation priority.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Campaign with >$1000/mo spend and no observation audiences | High |
| Missing remarketing audience observation | High |
| Missing relevant in-market segments | Warning |
| Audience accidentally in Targeting mode (restricting reach) | Critical |
| Campaign with observation audiences | Info |

## Output

**Short (default):**
```
## Audience Observation Mode Audit

**Account:** [Name] | **Campaigns Analyzed:** [X] | **Missing Observation Setup:** [Y]

### High Priority ([Count])
- **[Campaign]**: No observation audiences, $[X]/mo spend → Add standard observation set

### Warnings ([Count])
- **[Campaign]**: Missing remarketing observation → Add all visitors lists

### Recommended Observation Audiences
**Remarketing:**
- All website visitors (7, 30, 90 days)
- Past converters

**In-Market:**
- [Primary category for business]
- [Secondary category]

### Recommendations
1. [Priority setup action]
2. [Secondary action]
```

**Detailed adds:**
- Current audience coverage table (campaign, targeting mode count, observation mode count, no setup flag)
- Campaigns without observation audiences table with status and recommendation
- Recommended observation audiences by type (remarketing, in-market, affinity)
- Audiences by business type (e-commerce, B2B, local services)
- Data collection timeline (setup, collection, initial analysis, optimization phases)
