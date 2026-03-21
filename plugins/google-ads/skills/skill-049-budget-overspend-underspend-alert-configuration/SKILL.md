---
name: skill-049-budget-overspend-underspend-alert-configuration
description: "Configure alert thresholds for budget pacing issues and identify campaigns that need monitoring rules."
allowed-tools: Read, Grep, Glob
---
# Skill 049: Budget Overspend/Underspend Alert Configuration

## Purpose

Budget pacing issues often go unnoticed until month-end. This skill defines alert thresholds, identifies campaigns currently triggering alerts, and recommends automated monitoring rules for daily budget overspend, monthly pacing variance, and sudden spend changes.

## Data Requirements

**Data Source:** Custom GAQL Required

The standard export provides aggregated data but not daily spend patterns needed for alert detection.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Budget settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Total spend (baseline)

**GAQL Query:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign_budget.amount_micros,
  metrics.cost_micros,
  segments.date
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_14_DAYS
ORDER BY segments.date DESC
```
Run via `/google-ads:get-custom` with query name `budget_alerts`.

## Analysis Steps

1. **Define alert thresholds:** Daily overspend (Warning >110%, Alert >150%, Critical >200%), Monthly pacing (Under <85%, Over >115%), Sudden change (+/-30% day-over-day).

2. **Calculate current alert status:** Daily budget utilization, month-to-date pacing, 7-day trend, day-over-day change.

3. **Identify triggered alerts:** List campaigns currently triggering alerts with severity, duration, and trend.

4. **Prioritize alerts:** Rank by financial impact, severity level, duration, client sensitivity.

5. **Configure monitoring rules:** Recommend automated rules for scripts, Google Ads rules, or third-party tools.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Daily spend >200% budget | Critical |
| Multiple campaigns alerting simultaneously | Critical |
| Monthly pacing >130% or <70% | High |
| Day-over-day change >50% | High |
| Alert active >7 days | High |
| Monthly pacing 110-130% or 70-85% | Warning |
| Daily spend 150-200% budget | Warning |
| Day-over-day change 30-50% | Warning |

## Output

**Short (default):**
```
## Budget Alert Audit

**Account:** [Name] | **Active Alerts:** [X] | **Total Spend Affected:** $[Y]/month

### Critical ([Count])
- **[Campaign]**: [Alert type], [X]% for [Y] days → [Action]

### Warnings ([Count])
- **[Campaign]**: [Alert type], trend [improving/worsening] → Monitor

### Recommended Alert Rules
1. Daily overspend check at 6 PM: Cost > 150% of daily budget
2. Monthly pacing check: MTD spend >115% or <85% of expected
```

**Detailed adds:**
- Alert threshold configuration table (category, warning, alert, critical)
- Currently triggered alerts table (campaign, alert type, level, value, duration, trend)
- Alert summary by severity (level, count, total spend affected, campaigns)
- Campaign alert history (last 30 days) with most common alert type
- Recommended alert rule templates with conditions and frequencies
