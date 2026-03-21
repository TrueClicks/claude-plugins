---
name: skill-011-power-pack-assessment
description: "Evaluate whether the account leverages Google's 2025 recommended campaign trio: Performance Max + Demand Gen + AI Max for Search."
allowed-tools: Read, Grep, Glob
---
# Skill 011: Google "Power Pack" Structure Assessment

## Purpose
Evaluate whether the account leverages Google's 2025 recommended campaign trio: Performance Max + Demand Gen + AI Max for Search. This structure represents Google's latest AI-driven architecture guidance for full-funnel coverage.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - All campaign types and settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Campaign performance

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.status,
  campaign.advertising_channel_type,
  campaign.advertising_channel_sub_type,
  campaign.bidding_strategy_type,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need additional campaign type details or different date ranges.

## Analysis Steps

1. **Inventory campaign types:** Categorize all campaigns (Performance Max, Search, Demand Gen, Display, Shopping, Video)
2. **Check Power Pack presence:** Has PMax? Has Demand Gen? Has AI Max for Search features?
3. **Analyze campaign balance:** Calculate % of spend and conversions per campaign type; identify over-reliance
4. **Check for PMax conflicts:** Is PMax capturing brand traffic? Competing with standard Shopping?
5. **Evaluate AI adoption:** Smart Bidding rate, RSA adoption, automated targeting features

## Thresholds

| Condition | Severity |
|-----------|----------|
| No Performance Max campaigns | Warning |
| PMax > 70% of spend (over-reliance) | Warning |
| Manual bidding used | Warning |
| No Demand Gen campaigns | Info |
| Standard Shopping alongside PMax (potential overlap) | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Power Pack Assessment
**Account:** [Name] | **Campaign Types:** [X] | **AI Adoption:** [Y]%

### Critical ([Count])
- (None expected - Power Pack issues are typically Warnings)

### Warnings ([Count])
- **No Performance Max**: Missing full-funnel automation → Create PMax campaign
- **PMax over-reliance**: [X]% of spend → Diversify campaign types
- **Manual bidding**: [X] campaigns → Migrate to Smart Bidding

### Recommendations
1. Implement Power Pack structure: PMax (45-55%) + AI Max Search (30-40%) + Demand Gen (10-15%)
2. Enable AI Max on [X] Search campaigns
3. Create Demand Gen campaign for upper-funnel coverage
```

**Detailed** adds:
- What Was Checked (campaign types, AI features, spend distribution)
- Campaign type distribution table (Type, Count, Spend, Conv, % of Total)
- Power Pack status table (Component, Present, Status, Notes)
- AI adoption scorecard
- Recommended architecture structure
