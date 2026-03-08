---
name: skill-135-top-of-page-rate-monitoring
description: "Track SERP positioning metrics to ensure ads appear in premium positions for maximum performance."
allowed-tools: Read, Grep, Glob
---
# Skill 135: Top of Page Rate Monitoring

## Purpose

Monitor top-of-page and absolute-top position rates to ensure ads appear in premium SERP positions that drive better CTR and conversions. Identify campaigns/keywords underperforming on position and recommend bid or QS improvements.

## Data Requirements

**Data Source:** Custom GAQL Required

Position metrics require custom GAQL queries.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.search_top_impression_share,
  metrics.search_absolute_top_impression_share,
  metrics.search_impression_share
FROM ad_group
WHERE campaign.advertising_channel_type = 'SEARCH'
  AND campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads-get-custom` with query name `serp_position_metrics`.

## Analysis Steps

1. **Fetch position metrics:** Run GAQL query for top IS metrics
2. **Calculate position rates:** Top IS and Absolute Top IS by campaign/ad group
3. **Segment by position tier:** Premium (>80%), Good (60-80%), Moderate (40-60%), Low (<40%)
4. **Correlate with performance:** Compare CTR/conversion rate by position tier
5. **Identify improvement opportunities:** Flag high-value entities with low top IS

## Thresholds

| Condition | Severity |
|-----------|----------|
| Brand campaign Top IS < 80% | Critical |
| High-value campaign Abs Top IS < 20% | Warning |
| Top IS declining >10% week-over-week | Warning |
| Non-brand campaign Top IS < 40% | Info |

## Output

**Short format (default):**
```
## SERP Position Audit

**Account:** [Name] | **Campaigns:** [X] | **Low Position Issues:** [Y]

### Position Summary by Campaign
| Campaign | Top IS | Abs Top IS | Category |
|----------|--------|------------|----------|
| [Brand] | [X]% | [Y]% | Premium |
| [Product] | [X]% | [Y]% | Moderate |

### Position vs Performance
| Position Tier | Avg CTR | Avg Conv Rate |
|---------------|---------|---------------|
| Abs Top (>50%) | [X]% | [Y]% |
| Top (20-50%) | [X]% | [Y]% |
| Lower (<20%) | [X]% | [Y]% |

### Issues Requiring Attention
- **[Campaign]**: Top IS only [X]%, below target → Increase bids
- **Brand Campaign**: Abs Top IS dropped to [X]% → Investigate competition

### Recommendations
1. Increase bids on [campaigns] to improve top position
2. Improve QS to achieve top position more efficiently
```

**Detailed adds:**
- Ad group level position breakdown
- Position trend analysis (weekly)
- Bid adjustment recommendations
- ROI analysis by position tier
