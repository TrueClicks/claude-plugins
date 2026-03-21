---
name: skill-041-smart-bidding-learning-phase-monitoring
description: "Flag campaigns currently in Smart Bidding learning phase and assess impact on performance and decision-making."
allowed-tools: Read, Grep, Glob
---
# Skill 041: Smart Bidding Learning Phase Monitoring

## Purpose

Smart Bidding algorithms need time to learn optimal bid patterns. During learning, performance may be volatile, making changes extends the learning period, and evaluation of strategy effectiveness is unreliable. This skill identifies campaigns in learning phase, assesses expected exit timing, and flags disruptions that may extend learning.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include campaign primary status or learning phase indicators.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Bidding strategy type, status
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Daily performance trends

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.bidding_strategy_type,
  campaign.primary_status,
  campaign.primary_status_reasons,
  bidding_strategy.status,
  bidding_strategy.type,
  metrics.conversions,
  metrics.cost_micros,
  metrics.impressions,
  segments.date
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_14_DAYS
```
Run via `/google-ads:get-custom` with query name `learning_phase_status`.

## Analysis Steps

1. **Identify Smart Bidding campaigns:** Filter for Target CPA, Target ROAS, Maximize Conversions, Maximize Conversion Value strategies.

2. **Check learning phase status:** Look for primary status = "LEARNING" or learning-related status reasons; identify recent strategy/setting changes (<14 days).

3. **Assess learning duration:** Track days since strategy change, expected remaining learning time (typically 7-14 days for new strategies).

4. **Identify learning disruptions:** Flag frequent target adjustments, budget changes, pausing/enabling, or conversion action changes during learning.

5. **Evaluate performance volatility:** Compare CPA/ROAS variance during learning vs stable periods; check budget utilization.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Learning phase >21 days | Critical |
| Multiple changes during active learning | Critical |
| 3+ strategy changes in 30 days | Critical |
| Learning phase >14 days + low volume (<15 conv/month) | High |
| <15 conversions/month during learning | High |
| CPA variance >50% during learning | Warning |
| Budget underspend >40% during learning | Warning |

## Output

**Short (default):**
```
## Smart Bidding Learning Phase Audit

**Account:** [Name] | **Smart Bidding Campaigns:** [X] | **In Learning:** [Y]

### Critical ([Count])
- **[Campaign]**: In learning [X] days with [Y] changes → Freeze changes for 14 days

### Warnings ([Count])
- **[Campaign]**: Low volume ([X] conv/mo) extending learning → Consider consolidation

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Learning phase summary table (Learning/Limited/Stable status with conv/day and % of spend)
- Campaigns in learning table with strategy, days, trigger, estimated exit date
- Learning disruption risk assessment per campaign
- Performance volatility metrics (pre-learning vs learning CPA)
