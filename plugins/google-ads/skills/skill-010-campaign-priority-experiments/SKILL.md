---
name: skill-010-campaign-priority-experiments
description: "Ensure campaign priorities (especially for Shopping) are correctly configured and that experiments/drafts are properly structured."
allowed-tools: Read, Grep, Glob
---
# Skill 010: Campaign Priority and Experiment Structure

## Purpose
Ensure campaign priorities (especially for Shopping) are correctly configured and that experiments/drafts are properly structured. Incorrect priority settings cause traffic to route to the wrong campaigns, distorting results.

## Data Requirements

**Data Source:** Custom GAQL Required

Standard export includes basic shopping settings but may lack complete priority data. Custom GAQL provides experiment information.

**GAQL Query (Shopping priorities):**
```sql
SELECT
  campaign.id,
  campaign.name,
  campaign.status,
  campaign.shopping_setting.campaign_priority,
  campaign.shopping_setting.merchant_id,
  campaign.advertising_channel_type
FROM campaign
WHERE campaign.advertising_channel_type = 'SHOPPING'
  AND campaign.status != 'REMOVED'
```

**GAQL Query (experiments):**
```sql
SELECT
  experiment.experiment_id,
  experiment.name,
  experiment.status,
  experiment.type,
  experiment.start_date,
  experiment.end_date
FROM experiment
```
Run via `/google-ads-get-custom` with query names `shopping_priorities` and `experiments`.

## Analysis Steps

1. **Analyze Shopping priorities:** List all Shopping campaigns with priorities (0=Low, 1=Medium, 2=High); check for conflicts
2. **Validate priority logic:** Higher priority campaigns should have negatives to funnel specific queries
3. **Review experiments:** List active experiments; check duration (2-4 weeks recommended) and traffic split
4. **Check experiment best practices:** One variable tested, sufficient budget, clear success metrics
5. **Identify issues:** Overlapping priorities without differentiation, experiments running too long/short

## Thresholds

| Condition | Severity |
|-----------|----------|
| Multiple Shopping campaigns with same priority and overlapping products | Critical |
| High priority campaign without negatives | Warning |
| Experiment running > 8 weeks | Warning |
| Experiment < 2 weeks | Info |
| Experiment traffic split uneven (>60/40) | Info |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Campaign Priority & Experiments Audit
**Account:** [Name] | **Shopping Campaigns:** [X] | **Active Experiments:** [Y]

### Critical ([Count])
- **[Campaign A] & [Campaign B]**: Same priority (Medium), overlapping products → Differentiate priorities

### Warnings ([Count])
- **[Campaign]**: High priority without negatives → Add negatives to filter queries
- **[Experiment]**: Running [X] weeks (>8 weeks) → Conclude and implement winner

### Recommendations
1. Resolve priority conflicts in Shopping campaigns
2. Conclude long-running experiments
```

**Detailed** adds:
- What Was Checked (priority structure, negative keywords, experiment duration)
- Shopping priority table (Campaign, Priority, Products, Negatives)
- Experiment status table (Experiment, Base, Duration, Split, Status)
- Recommended priority structure
