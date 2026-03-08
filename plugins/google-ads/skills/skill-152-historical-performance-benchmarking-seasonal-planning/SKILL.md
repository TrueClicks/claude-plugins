---
name: skill-152-historical-performance-benchmarking-seasonal-planning
description: "Analyze prior-year data for seasonal periods to set realistic targets and inform investment decisions."
allowed-tools: Read, Grep, Glob
---
# Skill 152: Historical Performance Benchmarking for Seasonal Planning

## Purpose
Pull and analyze prior-year performance data for seasonal periods to establish data-driven targets and budget recommendations. Historical benchmarking transforms seasonal planning from guesswork into informed strategy, preventing over- or under-investment during critical periods.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard 30-day export cannot provide prior-year comparisons. Need multi-year historical data for accurate benchmarking.

**GAQL Query (Prior Year Seasonal Period):**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  segments.date,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value,
  metrics.average_cpc
FROM campaign
WHERE campaign.status IN ('ENABLED', 'PAUSED')
  AND segments.date BETWEEN '[PRIOR_YEAR_START]' AND '[PRIOR_YEAR_END]'
```
Run via `/google-ads-get-custom` for each seasonal period needing analysis (e.g., Black Friday 2025 to plan for 2026).

## Analysis Steps

1. **Identify key seasonal periods:** Map all major events requiring historical analysis
2. **Pull multi-year data:** Query same periods across 2-3 years for trend analysis
3. **Calculate benchmarks:** Compute volume metrics (impressions, clicks, conversions) and efficiency metrics (CTR, CPC, CPA, ROAS)
4. **Analyze trends:** Identify growth rates, efficiency changes, and market shifts year-over-year
5. **Set targets:** Establish realistic targets based on historical trends plus growth assumptions

## Thresholds

| Condition | Severity |
|-----------|----------|
| Major event planned without historical benchmark data | Critical |
| YoY efficiency decline >20% without acknowledged market shift | Warning |
| Budget target significantly higher than historical spend capacity | Warning |
| No multi-year comparison (single year data only) | Warning |
| Historical data unavailable (new account/campaign) | Info |

## Output

**Short format (default):**
```
## Historical Benchmarking Report
**Account:** [Name] | **Periods analyzed:** [X] | **Planning gaps:** [Y]

### Key Findings
- **[Event]**: [Year] ROAS [X]% vs [Prior Year] [Y]% ([Z]% change)
- **[Event]**: Budget utilization [X]%, lost [Y]% IS to budget

### Projections for [Upcoming Event]
| Metric | Prior Year | Projection | Change |
|--------|------------|------------|--------|
| Budget | $X | $Y | +Z% |
| Conv   | X | Y | +Z% |
| ROAS   | X% | Y% | Z% |

### Recommendations
1. [Budget recommendation with rationale based on historical trends]
```

**Detailed adds:**
- Multi-year comparison tables by campaign/category
- Day-of-week and hour performance patterns during peaks
- Risk assessment based on trend analysis
