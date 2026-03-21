---
name: skill-147-seasonal-budget-adjustment-scheduling
description: "Schedule temporary budget increases for promotional periods with automatic reversion."
allowed-tools: Read, Grep, Glob
---
# Skill 147: Seasonal Budget Adjustment Scheduling

## Purpose
Ensure campaigns have scheduled budget increases for peak periods and automatic reversion afterward. Under-funded campaigns miss profitable opportunities during high-demand windows, while forgetting to reduce budgets post-peak wastes spend during lower-intent periods.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export shows current budgets but not historical spend patterns or impression share lost to budget during prior peaks.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Current budget settings
- `data/account/budgets.md` - Shared budget configuration

**GAQL Query (Historical Peak Spend):**
```sql
SELECT
  campaign.name,
  campaign.campaign_budget,
  segments.date,
  metrics.cost_micros,
  metrics.impressions,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date BETWEEN '[PRIOR_YEAR_PEAK_START]' AND '[PRIOR_YEAR_PEAK_END]'
```
Run via `/google-ads:get-custom` to analyze prior-year peak periods.

## Analysis Steps

1. **Review current budgets:** Read campaign budget settings from standard data
2. **Identify upcoming peaks:** Map promotional calendar to budget requirements
3. **Analyze historical spend:** Query prior-year peak periods for spend patterns and budget limitations
4. **Check impression share loss:** Identify campaigns that were budget-limited during prior peaks
5. **Review automated rules:** Verify budget increase/decrease rules exist with correct triggers

## Thresholds

| Condition | Severity |
|-----------|----------|
| Peak event within 14 days with no budget increase scheduled | Critical |
| Campaign lost >20% IS to budget during prior peak | Critical |
| No automatic budget reversion rule for post-peak | Warning |
| Shared budget likely to misallocate during peak | Warning |
| Budget increase planned but no pacing buffer | Info |

## Output

**Short format (default):**
```
## Seasonal Budget Audit
**Account:** [Name] | **Events (60d):** [X] | **Budget gaps:** [Y]

### Critical ([Count])
- **[Campaign]**: Lost [X]% IS to budget in prior peak -> Increase from $[X] to $[Y]/day

### Warnings ([Count])
- **[Event]**: No auto-revert rule -> Schedule budget decrease for [date]

### Recommendations
1. [Specific budget change with campaign, amount, and dates]
```

**Detailed adds:**
- Historical spend vs. budget utilization table by campaign
- Recommended budget schedule with increase/decrease dates
- Automation rule configuration checklist
