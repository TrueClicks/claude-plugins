---
name: skill-159-ai-max-for-search-campaign-assessment
description: "Evaluate adoption of AI Max for Search, applying PMax-style AI to standard Search campaigns."
allowed-tools: Read, Grep, Glob
---
# Skill 159: AI Max for Search Campaign Assessment

## Purpose
Assess Search campaigns for AI Max adoption. AI Max extends Performance Max's AI capabilities to Search campaigns (automatic keyword expansion, dynamic headline generation, final URL expansion) while maintaining more control than full PMax. Campaigns using AI Max see average 18% increase in unique converting query categories.

## Data Requirements

**Data Source:** Standard + Custom GAQL

Standard export shows campaign settings; custom query needed for AI Max-specific configuration.

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign settings, bid strategies
- `data/performance/campaigns/*/campaign_metrics_30_days.md` - Conversion volume for eligibility

**Reference GAQL (Campaign Settings):**
```sql
SELECT
  campaign.name,
  campaign.status,
  campaign.bidding_strategy_type,
  campaign.advertising_channel_type,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE campaign.advertising_channel_type = 'SEARCH'
  AND campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` to get current AI Max configuration status (requires API access to campaign settings).

## Analysis Steps

1. **Identify eligible campaigns:** Find Search campaigns with Smart Bidding and sufficient conversion volume (30+/month)
2. **Check AI Max status:** Determine which features are enabled (search expansion, headlines, URL expansion)
3. **Evaluate prerequisites:** Verify conversion tracking accuracy, landing page quality, ad copy assets
4. **Assess risk profile:** Consider brand sensitivity, URL complexity, compliance requirements
5. **Review performance impact:** For enabled campaigns, compare pre/post metrics

## Thresholds

| Condition | Severity |
|-----------|----------|
| Campaign with >100 conv/month not using AI Max | Critical |
| AI Max enabled without negative keyword coverage | Critical |
| Campaign with 30-100 conv/month eligible for AI Max | Warning |
| URL expansion enabled on lead gen with dedicated forms | Warning |
| Campaign with <30 conv/month (insufficient for AI Max) | Info |

## Output

**Short format (default):**
```
## AI Max Assessment
**Account:** [Name] | **Search campaigns:** [X] | **AI Max enabled:** [Y]

### Critical ([Count])
- **[Campaign]**: [X] conv/mo, AI Max not enabled -> Enable all features

### Warnings ([Count])
- **[Campaign]**: AI Max eligible, [X] conv/mo -> Consider enabling

### AI Max Eligibility
| Campaign | Conv/Mo | AI Max | Recommendation |
|----------|---------|--------|----------------|
| [Name] | X | [On/Off] | [Action] |

### Recommendations
1. Enable AI Max on [Campaign] - Expected +15-20% conversions
```

**Detailed adds:**
- Feature-by-feature enablement recommendations per campaign
- Risk assessment for URL expansion and headline generation
- Pre/post performance comparison for enabled campaigns
- Negative keyword and URL exclusion requirements
