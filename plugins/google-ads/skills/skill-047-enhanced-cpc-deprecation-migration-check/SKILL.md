---
name: skill-047-enhanced-cpc-deprecation-migration-check
description: "Verify that no campaigns are still using deprecated Enhanced CPC (ECPC) bidding and plan migration to modern strategies."
allowed-tools: Read, Grep, Glob
---
# Skill 047: Enhanced CPC Deprecation Migration Check

## Purpose

Enhanced CPC is being deprecated by Google with limited optimization compared to full Smart Bidding. This skill identifies campaigns still using ECPC, assesses migration readiness based on conversion volume, and recommends replacement strategies with migration timelines.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Bidding strategy settings
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion metrics

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.bidding_strategy_type,
  campaign.manual_cpc.enhanced_cpc_enabled,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value,
  metrics.clicks,
  campaign.status
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND campaign.bidding_strategy_type = 'MANUAL_CPC'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` if you need enhanced_cpc_enabled field.

## Analysis Steps

1. **Identify ECPC campaigns:** Find campaigns where bidding strategy = MANUAL_CPC and Enhanced CPC enabled = true.

2. **Assess migration readiness:** Evaluate conversion volume (need 15-30+/month for Smart Bidding), tracking reliability, performance stability.

3. **Determine replacement strategy:** High volume (50+ conv/mo) = Target CPA or Max Conversions. Medium (15-50) = Max Conversions. Low (<15) = Manual CPC or Max Clicks.

4. **Calculate risk factors:** Performance volatility during learning, budget impact, stakeholder concerns.

5. **Plan migration timeline:** Priority order (low-risk first), learning period allowances, rollback criteria.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Shopping campaign + ECPC | Critical |
| ECPC + poor conversion tracking | Critical |
| Any campaign using ECPC | High |
| ECPC + >$5000/month spend | High |
| ECPC + >50 conv/month (ready for migration) | High |
| ECPC + 15-50 conv/month | Warning |
| ECPC + <15 conv/month | Warning |

## Output

**Short (default):**
```
## Enhanced CPC Migration Audit

**Account:** [Name] | **ECPC Campaigns:** [X] | **Total ECPC Spend:** $[Y]/month

### Critical ([Count])
- **[Campaign]**: ECPC on Shopping → Migrate to Max Conversions/tROAS immediately

### High Priority ([Count])
- **[Campaign]**: [X] conv/mo, ready for migration → Target CPA at $[Y]

### Migration Timeline
| Phase | Campaign | Strategy | Start |
|-------|----------|----------|-------|
| 1 | [Name] | Target CPA | Week 1 |

### Recommendations
1. [Priority migration]
2. [Secondary migration]
```

**Detailed adds:**
- ECPC campaign inventory (campaign, type, spend/mo, conv/mo, CPA, status, risk)
- Migration readiness assessment (conv volume, tracking, history, budget ratio, readiness)
- Recommended migration strategies table (campaign, current, recommended, rationale)
- Migration risk analysis (performance risk, budget risk, learning impact, overall)
