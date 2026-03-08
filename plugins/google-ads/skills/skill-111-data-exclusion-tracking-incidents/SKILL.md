---
name: skill-111-data-exclusion-tracking-incidents
description: "Use data exclusions to prevent broken tracking periods from influencing Smart Bidding."
allowed-tools: Read, Grep, Glob
---
# Skill 111: Data Exclusion for Tracking Incidents

## Purpose
Use data exclusions to prevent broken tracking periods from influencing Smart Bidding. Bad data during outages feeds bad bid decisions that compound over time without intervention.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  segments.date,
  metrics.conversions,
  metrics.clicks,
  metrics.cost_micros
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
  AND campaign.bidding_strategy_type IN (
    'TARGET_CPA', 'TARGET_ROAS', 'MAXIMIZE_CONVERSIONS', 'MAXIMIZE_CONVERSION_VALUE'
  )
ORDER BY segments.date
```
Run via `/google-ads-get-custom` with query name `tracking_incident_detection`.

**Standard Data:**
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Historical trends

## Analysis Steps

1. **Identify Historical Incidents:** Review conversion drops, known tracking outages
2. **Check Existing Exclusions:** Verify if data exclusions already applied
3. **Assess Unaddressed Incidents:** Find tracking problems without exclusions applied
4. **Evaluate Smart Bidding Impact:** Determine if campaigns using Smart Bidding were affected

## Thresholds

| Condition | Severity |
|-----------|----------|
| Tracking incident without data exclusion applied | Critical |
| Incident duration >72 hours without exclusion | Critical |
| Multiple incidents in 30 days without exclusions | Warning |
| Smart Bidding campaign affected by incident | Warning |

## Output

**Short (default):**
```
## Data Exclusion Audit
**Account:** [name] | **Incidents Detected:** [count] | **Exclusions Applied:** [count]

### Critical
- **[date range] tracking incident without exclusion** - Smart Bidding learning on bad data

### Recommendations
1. Apply data exclusion for [start date] to [end date]
2. Exclude at bid strategy level: [strategy names]
3. Monitor for 7-14 days for Smart Bidding recovery
```

**Detailed adds:**
- Historical incident analysis table
- Exclusion decision framework
- Recovery timeline by incident severity
- Documentation template for tracking incidents
