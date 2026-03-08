---
name: skill-095-pmax-new-customer-acquisition
description: "Evaluate whether New Customer Acquisition (NCA) mode is enabled to bid more aggressively for new customers vs existing customers."
allowed-tools: Read, Grep, Glob
---
# Skill 095: PMax New Customer Acquisition Mode

## Purpose
Evaluate whether New Customer Acquisition (NCA) mode is enabled to bid more aggressively for new customers vs existing customers. This helps grow the customer base rather than re-converting existing customers at inflated costs.

## Data Requirements

**Data Source:** Custom GAQL Required

**GAQL Query - NCA Settings:**
```sql
SELECT
  campaign_lifecycle_goal.campaign,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.optimization_mode,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.value_settings.value,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.value_settings.high_lifetime_value
FROM campaign_lifecycle_goal
```

**GAQL Query - Customer Lists:**
```sql
SELECT
  user_list.id,
  user_list.name,
  user_list.type,
  user_list.size_for_search
FROM user_list
WHERE user_list.type = 'CRM_BASED'
  AND user_list.membership_status = 'OPEN'
```
Run via `/google-ads-get-custom` with query name `pmax_nca_settings`.

## Analysis Steps

1. **Check NCA Configuration:** Is NCA enabled? What mode (bid higher vs. only new customers)?
2. **Review Customer Lists:** Existing customer list uploaded? Size and recency?
3. **Assess Business Fit:** E-commerce (typically valuable), lead gen (consider LTV differences)
4. **Analyze Current Performance:** New vs. returning customer split, CPA/ROAS by customer type

## Thresholds

| Condition | Severity |
|-----------|----------|
| NCA enabled but no customer list uploaded | Critical |
| Customer list <1,000 users | Warning |
| Customer list >30 days old | Warning |
| Value multiplier >3x | Warning |
| NCA disabled with >70% existing customer conversions | Info |

## Output

**Short (default):**
```
## PMax New Customer Acquisition Audit
**Account:** [name] | **NCA Enabled:** [Yes/No] | **Customer List:** [Yes/No] | **Issues:** [count]

### Critical
- **NCA enabled without customer list** - Upload purchaser list immediately

### Warnings
- **Customer list outdated** - Last updated [X days] ago, refresh weekly
- **Value multiplier at [X]x** - Consider reducing to 1.5-2x

### Recommendations
1. Enable NCA on [campaign] with 1.3-1.5x multiplier
2. Upload current customer list ([count] customers)
3. Expected impact: +[%] new customer conversions
```

**Detailed adds:**
- NCA status by campaign
- Customer list details (size, match rate, age)
- New vs. existing customer performance comparison
- Recommended multiplier calculation based on LTV
