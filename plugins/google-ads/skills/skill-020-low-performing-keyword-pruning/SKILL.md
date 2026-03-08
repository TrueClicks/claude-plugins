---
name: skill-020-low-performing-keyword-pruning
description: "Identify keywords that exceed cost thresholds without generating conversions, representing candidates for pausing or removal to improve account efficiency."
allowed-tools: Read, Grep, Glob
---
# Skill 020: Low-Performing Keyword Pruning

## Purpose
Identify keywords that exceed cost thresholds without generating conversions, representing candidates for pausing or removal to improve account efficiency. Pruning non-performers reclaims budget for better keywords.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance
- `data/account/campaigns/*/*/keywords.md` - Keyword settings (status, QS)
- `data/account/campaigns/*/campaign.md` - Campaign target CPA/ROAS and bidding strategy

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.quality_info.quality_score,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` if you need different date ranges or longer lookback windows.

## Analysis Steps

1. **Establish thresholds:** Use campaign target CPA (prune at 2-3x with 0 conversions) or fixed $50 minimum
2. **Find zero-conversion keywords:** Filter Conversions = 0, Cost >= threshold, sort by Cost descending
3. **Find high-CPA keywords:** Filter Conversions >= 1, CPA > target CPA x 1.5
4. **Assess engagement signals:** Check CTR < 1% (poor relevance), QS < 5 (landing page/ad issues)
5. **Consider context:** New keywords in learning, conversion tracking issues, top-of-funnel awareness

## Thresholds

| Condition | Severity |
|-----------|----------|
| Cost >= 3x Target CPA AND Conv = 0 | Critical |
| Cost >= 2x Target CPA AND Conv = 0 | Warning |
| Cost >= $100 AND Conv = 0 AND CTR < 1% | Warning |
| CPA > 2x Target AND Conv >= 1 | Warning |
| Cost >= Target CPA AND Conv = 0 AND QS >= 7 | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Keyword Pruning Audit
**Account:** [Name] | **Keywords Analyzed:** [X] | **Prune Candidates:** [Y]

### Critical ([Count])
- **[keyword]** ([match]): $[X] spent, 0 conversions, [Y] QS → Pause immediately

### Warnings ([Count])
- **[keyword]**: CPA $[X] vs target $[Y] (+[Z]% over) → Reduce bid or pause

### Recommendations
1. Pause [X] zero-conversion keywords (saves ~$[Y]/month)
2. Reduce bids on [X] high-CPA keywords
```

**Detailed** adds:
- What Was Checked (cost thresholds, engagement signals, context factors)
- Zero-conversion table (Keyword, Match, Campaign/AG, Cost, Clicks, CTR, QS, Recommendation)
- High-CPA table (Keyword, Match, Cost, Conv, CPA, Target CPA, % Over, Action)
- Pruning summary (Category, Keywords, Total Cost, Potential Savings)
