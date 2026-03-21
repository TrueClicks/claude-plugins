---
name: skill-156-first-party-data-collection-activation-strategy
description: "Build robust first-party data collection through email signups, loyalty programs, and CRM systems."
allowed-tools: Read, Grep, Glob
---
# Skill 156: First-Party Data Collection and Activation Strategy

## Purpose
Assess first-party data collection and activation for Google Ads targeting and measurement. As third-party cookies decline, first-party data becomes essential for Customer Match, Enhanced Conversions, offline conversion import, and audience creation.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export doesn't include Customer Match audience configuration or match rates.

**Reference GAQL (Customer Match Audiences):**
```sql
SELECT
  user_list.name,
  user_list.type,
  user_list.size_for_search,
  user_list.size_for_display,
  user_list.membership_status
FROM user_list
WHERE user_list.type = 'CRM_BASED'
```
Run via `/google-ads:get-custom` to inventory Customer Match lists.

**Additional Data Sources:**
- CRM system (Salesforce, HubSpot) - email counts, data quality
- E-commerce platform - customer records, transaction data
- Email marketing platform - subscriber counts, engagement data
- Google Ads Data Manager status

## Analysis Steps

1. **Inventory data sources:** Document all first-party data currently collected (CRM, e-commerce, email, loyalty)
2. **Assess data quality:** Evaluate email validity rates, phone formatting, data recency
3. **Review activation status:** Check Customer Match audiences, Enhanced Conversions, offline imports
4. **Identify collection gaps:** Find missing collection points and low opt-in rates
5. **Evaluate privacy compliance:** Verify consent mechanisms and data retention policies

## Thresholds

| Condition | Severity |
|-----------|----------|
| Enhanced Conversions not implemented | Critical |
| Customer Match lists stale (>30 days since refresh) | Critical |
| Match rate <50% on uploaded lists | Warning |
| CRM data available but not uploaded to Google Ads | Warning |
| Email capture rate <3% on key pages | Warning |
| No consent management for data collection | Info |

## Output

**Short format (default):**
```
## First-Party Data Audit
**Account:** [Name] | **Data sources:** [X] | **Activation gaps:** [Y]

### Critical ([Count])
- **Enhanced Conversions**: Not implemented -> Enable for +5-10% conversion capture
- **Customer Match**: Last refresh [X] days ago -> Automate weekly sync

### Warnings ([Count])
- **[Data source]**: Available but not activated -> Upload to Google Ads
- **Match rate**: [X]% on [list] -> Improve data quality

### Data Inventory
| Source | Records | Quality | Activated |
|--------|---------|---------|-----------|
| CRM | X | High/Med/Low | Yes/No |

### Recommendations
1. [Specific activation with expected impact]
```

**Detailed adds:**
- Data source inventory with quality assessment
- Customer Match audience creation plan
- Enhanced Conversions implementation checklist
- Privacy compliance review
