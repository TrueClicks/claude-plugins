---
name: skill-004-ad-group-thematic-tightness
description: "Evaluate whether each ad group contains tightly themed, closely related keywords (ideally 5-20 per group)."
allowed-tools: Read, Grep, Glob
---
# Skill 004: Ad Group Thematic Tightness

## Purpose
Evaluate whether each ad group contains tightly themed, closely related keywords (ideally 5-20 per group). Loosely themed ad groups reduce ad relevance and Quality Score because ad copy cannot match all keyword intents.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keywords per ad group
- `data/account/campaigns/*/*/ads.md` - Ad copy per ad group
- `data/account/campaigns/*/*/ad_group.md` - Ad group settings
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Keyword performance with QS

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.quality_info.quality_score
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads-get-custom` if you need different date ranges or additional QS components.

## Analysis Steps

1. **Count keywords per ad group:** Flag <3 keywords (too few) or >30 keywords (too many); ideal range is 5-20
2. **Analyze keyword similarity:** Extract root themes, calculate semantic cohesion within each ad group
3. **Check ad relevance:** Verify ad copy contains keyword themes from the ad group
4. **Correlate with Quality Score:** Calculate average QS per ad group; identify loose theme → low QS patterns
5. **Identify splitting opportunities:** Find ad groups with distinct keyword clusters that should be separated

## Thresholds

| Condition | Severity |
|-----------|----------|
| Keywords per ad group > 30 | Critical |
| Low thematic cohesion (multiple distinct themes) | Critical |
| Keywords per ad group < 3 | Warning |
| Ad copy doesn't match keyword themes | Warning |
| Average QS in ad group < 5 | Warning |

## Output

Use **Short** format by default. Use **Detailed** if user requests comprehensive analysis.

**Short:**
```
## Ad Group Thematic Tightness Audit
**Account:** [Name] | **Analyzed:** [X] ad groups | **Issues:** [Y]

### Critical ([Count])
- **[Ad Group]**: [X] keywords, multiple themes detected → Split into themed ad groups

### Warnings ([Count])
- **[Ad Group]**: Only [X] keywords → Merge with similar ad group or add variations
- **[Ad Group]**: Ad copy missing keyword themes → Update RSA headlines

### Recommendations
1. Split "[Ad Group]" into [X] themed groups
2. Target 10-15 keywords per ad group
```

**Detailed** adds:
- What Was Checked (keyword counts, theme analysis, QS correlation)
- Theme breakdown for each problematic ad group
- Splitting recommendations with suggested new ad group names
- Summary table with all ad groups and their cohesion scores
