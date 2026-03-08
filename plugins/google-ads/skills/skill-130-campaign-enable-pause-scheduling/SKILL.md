---
name: skill-130-campaign-enable-pause-scheduling
description: "Identify campaigns needing scheduling rules for promotions, events, and time-bound activities."
allowed-tools: Read, Grep, Glob
---
# Skill 130: Campaign Enable/Pause Scheduling

## Purpose

Review campaign inventory to identify those needing automated enable/pause scheduling for promotions, seasonal events, and time-limited offers. Provide rule configurations to ensure campaigns start and stop on time.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Campaign settings, status, dates
- `data/account/account_summary.md` - Campaign inventory

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  campaign.status,
  campaign.start_date_time,
  campaign.end_date_time,
  campaign.labels
FROM campaign
WHERE campaign.status IN ('ENABLED', 'PAUSED')
```
Use `/google-ads-get-custom` for label-based filtering.

## Analysis Steps

1. **Read campaign inventory:** List all campaigns with status and dates
2. **Identify scheduling candidates:** Flag promotional, seasonal, and event campaigns
3. **Check existing schedules:** Review start/end dates already configured
4. **Map to events calendar:** Align campaigns with known promotional periods
5. **Generate rule configurations:** Provide enable/pause rule specifications

## Thresholds

| Condition | Severity |
|-----------|----------|
| Promotional campaign without end date | Warning |
| Event campaign enabled past event date | Critical |
| Seasonal campaign paused during peak season | Critical |
| Campaign with end date in next 7 days, no replacement | Info |

## Output

**Short format (default):**
```
## Campaign Scheduling Audit

**Account:** [Name] | **Campaigns:** [X] | **Scheduling Needed:** [Y]

### Campaigns Requiring Scheduling
| Campaign | Type | Suggested Schedule |
|----------|------|-------------------|
| [Name] | Promotion | Enable [date], Pause [date] |
| [Name] | Seasonal | Enable [date], Pause [date] |

### Missing End Dates
- **[Campaign]**: Active promotion with no end date → Add end date

### Recommended Rules
**[Promotion Name]:**
- Enable: [Date] at 12:00 AM
- Pause: [Date] at 12:00 AM
- Apply to: Campaigns with label "[Label]"

### Implementation Checklist
1. Create labels for scheduled campaigns
2. Set up enable rules for [X] campaigns
3. Set up pause rules for [Y] campaigns
```

**Detailed adds:**
- Full scheduling calendar view
- Label-based organization recommendations
- Pre-event and post-event checklists
- Emergency override procedures
