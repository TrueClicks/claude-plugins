---
name: skill-109-offline-conversion-freshness
description: "Verify that offline conversion data is imported within 1-14 days of the lead event."
allowed-tools: Read, Grep, Glob
---
# Skill 109: Offline Conversion Import Freshness

## Purpose
Verify that offline conversion data is imported timely. Stale offline data reduces its value for Smart Bidding optimization - fresh imports within 1-3 days maximize effectiveness.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query:**
```sql
SELECT
  segments.conversion_lag_bucket,
  segments.conversion_action_name,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE segments.date BETWEEN '{start_date}' AND '{end_date}'
```
Run via `/google-ads-get-custom` with query name `offline_conversion_lag`.

**Standard Data:**
- `data/account/conversion_actions.md` - Identify offline conversion sources

## Analysis Steps

1. **Identify Offline Conversions:** Find CRM, phone call, store visit conversion actions
2. **Assess Import Mechanism:** Manual upload, scheduled, API integration, CRM sync
3. **Evaluate Import Frequency:** Check timing lag from click to conversion import
4. **Identify Freshness Issues:** Batched imports, >7 day lag, gaps in data

## Thresholds

| Condition | Severity |
|-----------|----------|
| Offline conversions >14 days after click | Critical |
| No automated import pipeline | Warning |
| All offline conversions import on same day (batched) | Warning |
| Import gaps or failures detected | Warning |
| Import lag 8-14 days | Info |

## Output

**Short (default):**
```
## Offline Conversion Freshness Audit
**Account:** [name] | **Offline Actions:** [count] | **Avg Lag:** [X days] | **Issues:** [count]

### Critical
- **[conversion] averaging [X] day import lag** - Smart Bidding signal degraded

### Warnings
- **Manual upload process** - Set up automated CRM sync
- **All imports on Mondays** - Batched, not real-time

### Recommendations
1. Implement daily automated import pipeline
2. Target 1-3 day import lag for maximum Smart Bidding value
3. Set up GCLID capture in CRM forms
```

**Detailed adds:**
- Conversion lag distribution table
- Import mechanism assessment
- Recommended import frequency by business type
- GCLID management checklist
