---
name: skill-048-bid-adjustment-layer-review
description: "Audit device, location, schedule, and audience bid modifiers to ensure they are optimized and not conflicting with Smart Bidding."
allowed-tools: Read, Grep, Glob
---
# Skill 048: Bid Adjustment Layer Review

## Purpose

Bid adjustments modify bids based on context signals, but Smart Bidding already considers these signals automatically. This skill audits current bid adjustment settings, identifies conflicts with Smart Bidding strategies, flags stale or extreme adjustments, and recommends optimization for Manual CPC campaigns.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/bid_adjustments.md` - Device and location modifiers
- `data/account/campaigns/*/campaign.md` - Bidding strategy
- `data/account/campaigns/*/*/bid_adjustments.md` - Ad group modifiers

**Reference GAQL:**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.bidding_strategy_type,
  campaign_criterion.device.type,
  campaign_criterion.bid_modifier,
  campaign_criterion.type
FROM campaign_criterion
WHERE campaign.status = 'ENABLED'
  AND campaign_criterion.type IN ('DEVICE', 'LOCATION')
```
Use `/google-ads-get-custom` for schedule or audience bid adjustments.

## Analysis Steps

1. **Inventory all bid adjustments:** Collect device (Desktop/Mobile/Tablet), location, schedule, and audience adjustments at campaign and ad group levels.

2. **Cross-reference with bidding strategy:** Smart Bidding campaigns: only device exclusions (-100%) have effect. Manual/ECPC: all adjustments apply directly.

3. **Identify conflicts and issues:** Non-device adjustments on Smart Bidding (no effect), extreme device adjustments, conflicting campaign/ad group adjustments.

4. **Flag stale adjustments:** Adjustments not updated in 90+ days on Manual CPC campaigns.

5. **Calculate recommendations:** Remove conflicting adjustments, update stale ones, simplify over-complex structures.

## Thresholds

| Condition | Severity |
|-----------|----------|
| Device -100% (exclusion) on Smart Bidding | High |
| Adjustment vs actual performance mismatch >30% | High |
| Campaign and ad group adjustment conflict | High |
| Non-device adjustment on Smart Bidding | Warning |
| Adjustment not updated in 90+ days | Warning |
| Extreme adjustment (>+/-50%) without justification | Warning |
| >10 location adjustments | Info |

## Output

**Short (default):**
```
## Bid Adjustment Audit

**Account:** [Name] | **Campaigns with Adjustments:** [X] | **Issues:** [Y]

### High Priority ([Count])
- **[Campaign]**: Mobile -100% on Target CPA → Review if exclusion intended

### Warnings ([Count])
- **[Campaign]**: Location adjustments have no effect on Smart Bidding → Remove or keep for reference

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Bid adjustment overview table (type, campaigns with, avg adjustment, range, conflicts)
- Smart Bidding conflict analysis (campaign, bidding, adjustment type, setting, issue)
- Device adjustment analysis per campaign (strategy, desktop, mobile, tablet, impact)
- Stale adjustment detection (campaign, type, last updated, current value, recommended)
