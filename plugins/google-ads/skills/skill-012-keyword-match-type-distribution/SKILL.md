---
name: skill-012-keyword-match-type-distribution
description: "Analyze the distribution of broad, phrase, and exact match keywords across the account and compare performance by match type."
allowed-tools: Read, Grep, Glob
---
# Skill 012: Keyword Match Type Distribution Analysis

## Purpose
Analyze the distribution of broad, phrase, and exact match keywords across the account and compare performance by match type. Identifies over-reliance on single match types, performance disparities, and Smart Bidding alignment issues.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keyword settings with match type
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance metrics
- `data/account/campaigns/*/campaign.md` - Campaign bidding strategy (for Smart Bidding alignment)

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` if you need different date ranges or additional metrics.

## Analysis Steps

1. **Collect all keywords:** Parse match types using notation: `[keyword]` = Exact, `"keyword"` = Phrase, bare = Broad
2. **Aggregate performance:** Sum metrics by match type; calculate CTR, CPC, CPA, ROAS, Conv Rate
3. **Calculate distribution:** Keyword count %, spend %, conversion % per match type
4. **Check Smart Bidding alignment:** For campaigns using Smart Bidding, flag if broad match < 30%
5. **Identify imbalances:** Single match type > 80%, high spend but low conversions on a match type

## Thresholds

| Condition | Severity |
|-----------|----------|
| Broad match < 30% in Smart Bidding campaigns | Critical |
| Match type has > 40% spend but < 20% conversions | Critical |
| Single match type > 80% of keywords | Warning |
| Exact match < 10% with significantly better CPA | Warning |
| No broad match keywords in account | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Match Type Distribution Audit
**Account:** [Name] | **Keywords:** [X] | **Issues:** [Y]

### Critical ([Count])
- **[Campaign]**: Smart Bidding with only [X]% broad match → Add broad match keywords
- **Phrase match**: [X]% of spend, only [Y]% of conversions → Review and consolidate

### Warnings ([Count])
- **Over-reliance**: [X]% of keywords are [Type] → Diversify match types
- **Under-utilized exact**: [X]% lower CPA → Expand exact match coverage

### Recommendations
1. Increase broad match in Smart Bidding campaigns to 30%+
2. Expand exact match for high-performing terms
```

**Detailed** adds:
- What Was Checked (match type parsing, Smart Bidding alignment)
- Distribution table (Match Type, Keywords, % Total, Cost, % Spend, Conv, % Conv)
- Performance table (Match Type, Impressions, Clicks, CTR, CPC, Conv, CPA, ROAS)
- Campaign-level breakdown for Smart Bidding alignment
