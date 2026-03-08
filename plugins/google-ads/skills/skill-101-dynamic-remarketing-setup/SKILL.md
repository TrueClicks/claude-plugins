---
name: skill-101-dynamic-remarketing-setup
description: "Verify dynamic remarketing is properly configured with product feed integration and custom parameters."
allowed-tools: Read, Grep, Glob
---
# Skill 101: Dynamic Remarketing Setup

## Purpose
Verify dynamic remarketing is properly configured with product feed integration. Dynamic ads showing previously-viewed products outperform generic display by 2-3x in CTR and conversion rate.

## Data Requirements

**Data Source:** Standard + Custom GAQL

**Standard Data:**
- `data/account/account_summary.md` - Merchant Center linkage
- `data/account/campaigns/*/campaign.md` - Campaign types
- `data/account/campaigns/*/audience_targeting.md` - Audience configurations

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  campaign.advertising_channel_type,
  campaign.shopping_setting.merchant_id
FROM campaign
WHERE campaign.advertising_channel_type IN ('DISPLAY', 'PERFORMANCE_MAX', 'SHOPPING')
  AND campaign.status = 'ENABLED'
```
Use `/google-ads-get-custom` to verify Merchant Center linkage.

**Note:** Full dynamic remarketing audit requires website tag verification via Google Tag Assistant.

## Analysis Steps

1. **Identify Dynamic Campaigns:** Find Display/PMax/Shopping campaigns
2. **Verify Merchant Center Linkage:** Check for active linked account
3. **Assess Feed Health:** Review if product feed is connected (requires MC access)
4. **Review Audience Lists:** Verify product viewer and cart abandoner audiences exist

## Thresholds

| Condition | Severity |
|-----------|----------|
| No Merchant Center linked (e-commerce) | Critical |
| Display campaigns without dynamic feed | Warning |
| No product viewer audiences | Warning |
| No cart abandoner with product data | Warning |

## Output

**Short (default):**
```
## Dynamic Remarketing Setup Audit
**Account:** [name] | **Merchant Center:** [Linked/Not Linked] | **Dynamic Campaigns:** [count]

### Critical
- **No Merchant Center linked** - Cannot run dynamic remarketing

### Warnings
- **Display campaign without dynamic feed** - Enable product data
- **No product-specific audiences** - Create product viewer lists

### Recommendations
1. Link Merchant Center account
2. Enable dynamic remarketing on Display campaigns
3. Create product viewer and cart abandoner audiences
```

**Detailed adds:**
- Campaign-level dynamic status table
- Feed requirements checklist
- Custom parameter implementation guide
- Audience structure for dynamic remarketing
