---
name: skill-024-keyword-intent-alignment
description: "Evaluate whether keyword search intent matches campaign goals and landing page content."
allowed-tools: Read, Grep, Glob
---
# Skill 024: Keyword Intent Alignment Assessment

## Purpose

Ensure keywords target users at the right funnel stage for campaign goals. Informational keywords in conversion campaigns drain budget, while transactional keywords with 0 conversions indicate landing page issues. Intent misalignment is a major source of wasted ad spend.

## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keywords to analyze
- `data/performance/campaigns/*/*/keywords_metrics_30_days.md` - Performance metrics
- `data/performance/campaigns/*/*/search_terms_metrics_30_days.md` - Actual queries revealing intent
- `data/account/campaigns/*/*/ads.md` - Final URLs for landing page context
- `data/account/campaigns/*/campaign.md` - Campaign goals/bidding

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  campaign.bidding_strategy_type,
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM keyword_view
WHERE ad_group_criterion.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Use `/google-ads:get-custom` for conversion rate analysis or landing page URL extraction.

## Analysis Steps

1. **Classify keyword intent:** Transactional (buy, purchase, pricing), Navigational (brand, login), Informational (how to, what is), Commercial Investigation (vs, compare, review)
2. **Map intent to campaign goals:** Match keyword intent against campaign objective (conversions, leads, awareness)
3. **Analyze performance by intent:** Compare CTR, conversion rate, CPA across intent types
4. **Check landing page alignment:** Verify Final URLs match keyword intent (info keywords to guides, transactional to product pages)
5. **Flag misalignments:** Informational in conversion campaigns, transactional with 0 conversions

## Thresholds

| Condition | Severity |
|-----------|----------|
| Informational keyword in conversion campaign, CPA > 3x target | Critical |
| Informational keywords > 30% of conversion campaign | Critical |
| Transactional keyword, 50+ clicks, 0 conversions | Warning |
| Commercial investigation keyword to generic page | Info |

## Output

**Short (default):**
```
## Keyword Intent Audit
**Account:** [Name] | **Keywords:** [X] | **Misalignments:** [Y]

### Critical ([Count])
- **"[keyword]"** (informational) in [Campaign]: $[X] spent, [Y] CPA vs $[Z] target -> Move to awareness or negative

### Warnings ([Count])
- **"[keyword]"** (transactional): [X] clicks, 0 conv -> Check landing page

### Intent Distribution
| Intent | Keywords | Spend | Conv | CPA |
|--------|----------|-------|------|-----|

### Recommendations
1. [Priority action]
```

**Detailed adds:**
- Full intent classification table by campaign
- Landing page relevance assessment
- Recommended landing pages by intent type
