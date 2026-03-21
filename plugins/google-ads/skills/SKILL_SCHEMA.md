# PPC Skill Schema

This document defines the standard structure for all PPC analysis skills.

## Design Principles

1. **Concise** - Skills should be 80-120 lines maximum
2. **Actionable** - Focus on what to check and what to report, not educational background
3. **Issue-focused** - Output should only show problems and recommendations, never "passed" items
4. **DRY** - Don't repeat information; Example Findings should be brief, not duplicate Output Format
5. **No Fluff** - Remove "Why It Matters", "Important Notes", excessive explanations - Claude already knows PPC best practices

---

## SKILL.md Structure

```yaml
---
name: skill-XXX-descriptive-name
description: "One-line description of what this skill checks."
allowed-tools: Read, Grep, Glob
---
```

### Required Sections (in order)

#### 1. Title
```markdown
# Skill XXX: Short Descriptive Title
```
- Single line, no subtitle or category

#### 2. Purpose
```markdown
## Purpose
One paragraph (2-3 sentences max) explaining what this audit checks and why it matters.
```

#### 3. Data Requirements
```markdown
## Data Requirements

**Data Source:** Standard  ← or "Custom GAQL Required"

**Standard Data:**
- `data/account/...` - Brief description
- `data/performance/...` - Brief description

**Reference GAQL:**
```sql
SELECT ... FROM ... WHERE ...
```
Use `/google-ads:get-custom` if you need to adjust date range, add filters, or fetch additional fields.
```

**Data Source Values:**
- `Standard` - The `/google-ads-get` export contains all required data
- `Custom GAQL Required` - Must run `/google-ads:get-custom` because standard export lacks required fields

**GAQL Rules:**
- **Always include GAQL** as reference, even when standard data is sufficient
- This allows Claude to adjust queries (date range, filters, additional metrics)
- Mark clearly whether it's required or just for reference

**GAQL Date Range Rules:**
- **Valid DURING literals:** `LAST_7_DAYS`, `LAST_14_DAYS`, `LAST_30_DAYS`, `THIS_MONTH`, `LAST_MONTH`, `TODAY`, `YESTERDAY`
- **Invalid DURING literals:** `LAST_90_DAYS`, `LAST_365_DAYS`, `THIS_YEAR`, `THIS_QUARTER` — these do NOT exist in GAQL
- **For ranges >30 days:** Use `BETWEEN '{start_date}' AND '{end_date}'` with placeholder variables. Claude will replace these with actual dates at execution time.
- **Example:** `WHERE segments.date BETWEEN '{start_date}' AND '{end_date}'`
- **Fields referenced in WHERE must be in SELECT** when querying from `shopping_performance_view` (e.g., `campaign.advertising_channel_type`)

#### 4. Analysis Steps
```markdown
## Analysis Steps

1. **Step name:** Brief description of what to check
2. **Step name:** Brief description of what to check
3. **Step name:** Brief description of what to check
```
- 3-6 steps maximum
- Action-oriented, not explanatory
- No sub-bullets unless necessary

#### 5. Thresholds
```markdown
## Thresholds

| Condition | Severity |
|-----------|----------|
| [specific condition] | Critical |
| [specific condition] | Warning |
| [specific condition] | Info |
```
- Table format only
- Specific, measurable conditions
- 3-6 thresholds maximum

#### 6. Output
```markdown
## Output

Report ONLY issues found. Do not list passed items.

### Issues Found
| Entity | Issue | Impact | Severity |
|--------|-------|--------|----------|

### Recommendations
1. [Specific action]
2. [Specific action]
```
- Minimal template
- Never show "OK" or "Pass" items
- Focus on actionable recommendations

---

## Data Requirements Examples

### Example A: Standard Data Sufficient

```markdown
## Data Requirements

**Data Source:** Standard

**Standard Data:**
- `data/account/campaigns/*/*/keywords.md` - Keywords with match types and QS
- `data/account/campaigns/*/*/negative_keywords.md` - Negative keywords
- `data/account/shared_negative_lists.md` - Shared negative lists

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
Use `/google-ads:get-custom` if you need different date ranges or additional metrics.
```

### Example B: Custom GAQL Required

```markdown
## Data Requirements

**Data Source:** Custom GAQL Required

The standard export does not include network-segmented metrics.

**GAQL Query:**
```sql
SELECT
  campaign.name,
  segments.ad_network_type,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```
Run via `/google-ads:get-custom` with query name `network_performance`.
```

---

## OUTPUT Schema (What Claude Should Report)

Two output formats are available. Use **Short** by default, or **Detailed** when user requests more information.

---

### Short Output Format

Concise summary focused on issues and actions.

```markdown
## [Skill Name] Audit

**Account:** [Name] | **Analyzed:** [X] campaigns, [Y] keywords | **Issues:** [Z]

### Critical ([Count])
- **[Entity]**: [Issue] → [Fix]

### Warnings ([Count])
- **[Entity]**: [Issue] → [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Short format rules:**
- Single line header with key stats
- Issues as bullet points with inline fix
- No tables, no sections for passed items
- Target: 15-30 lines

---

### Detailed Output Format

Comprehensive report with context and analysis.

```markdown
## [Skill Name] Audit

**Account:** [Account Name]
**Date:** [Date]
**Entities Analyzed:** [Count breakdown]

### What Was Checked
- [Aspect 1 checked]
- [Aspect 2 checked]
- [Aspect 3 checked]

### Critical Issues ([Count])

1. **[Entity Name]**: [Specific issue]
   - Impact: [What this causes]
   - Evidence: [Data supporting the finding]
   - Fix: [Specific action to take]

### Warnings ([Count])

1. **[Entity Name]**: [Specific issue]
   - Fix: [Specific action to take]

### Summary
| Metric | Value |
|--------|-------|
| Total entities | X |
| Issues found | Y |
| Critical | Z |
| Warnings | W |

### Recommendations
1. **[Priority action]** - [Brief rationale]
2. **[Secondary action]** - [Brief rationale]
```

**Detailed format rules:**
- "What Was Checked" section for transparency
- Issues with Impact + Evidence + Fix
- Summary table with metrics
- **Never list passed entities or areas** - focus only on issues
- Target: 40-70 lines

---

### Output Rules (Both Formats)

1. **Never list passed entities individually** - Don't show "Campaign X: OK" rows
2. **Group by severity** - Critical → Warnings → Info
3. **Be specific** - Name the exact entity (campaign, ad group, keyword)
4. **Include the fix** - Every issue needs a specific recommendation
5. **Quantify impact** - When possible, estimate cost/conversion impact
6. **No educational content** - Don't explain why something is a best practice

### When No Issues Found

**Short:**
```markdown
## [Skill Name] Audit
**Account:** [Name] | **Analyzed:** [X] entities | **Issues:** 0

No issues found.
```

**Detailed:**
```markdown
## [Skill Name] Audit

**Account:** [Name]
**Entities Analyzed:** [X]

### What Was Checked
- [Aspect 1]
- [Aspect 2]

### Result
No issues found. All [X] entities pass the audit criteria.
```

### Example: Short Output

```markdown
## Brand/Non-Brand Split Audit

**Account:** TrueClicks - Dev Test | **Analyzed:** 2 campaigns, 15 keywords | **Issues:** 2

### Critical (1)
- **"Manual - ROAS - For Cost campaign"**: Mixed brand + non-brand keywords → Split into separate campaigns

### Warnings (1)
- **No brand negatives in non-brand campaigns** → Add "trueclicks" as exact match negative

### Recommendations
1. Create dedicated "Brand - Search" campaign
2. Add brand negatives to all non-brand campaigns
```

### Example: Detailed Output

```markdown
## Brand/Non-Brand Split Audit

**Account:** TrueClicks - Dev Test
**Date:** 2024-01-15
**Entities Analyzed:** 2 campaigns, 15 keywords

### What Was Checked
- Campaign keyword composition (brand vs non-brand)
- Brand negative keyword coverage
- Campaign naming conventions

### Critical Issues (1)

1. **"Manual - ROAS - For Cost campaign"**: Contains both brand and non-brand keywords
   - Impact: Inflated CTR metrics, distorted Smart Bidding signals
   - Evidence: 2 brand keywords ("trueclicks", "trueclicks pricing") + 7 non-brand keywords
   - Fix: Move brand keywords to dedicated Brand campaign

### Warnings (1)

1. **No brand negatives in non-brand campaigns**
   - Fix: Add "trueclicks" as exact match negative to non-brand campaigns

### Summary
| Metric | Value |
|--------|-------|
| Campaigns analyzed | 2 |
| Keywords analyzed | 15 |
| Critical issues | 1 |
| Warnings | 1 |

### Recommendations
1. **Create "Brand - Search" campaign** - Isolate brand traffic for accurate measurement
2. **Add brand negatives** - Prevent brand queries triggering non-brand campaigns
```

### Example: Bad Output (What to Avoid)

```markdown
## Brand/Non-Brand Split Audit

### Campaign Analysis

| Campaign | Classification | Brand KW | Non-Brand KW | Status |
|----------|---------------|----------|--------------|--------|
| Brand Campaign | Brand | 15 | 0 | ✓ OK |
| Generic Campaign | Non-Brand | 0 | 45 | ✓ OK |
| Mixed Campaign | Mixed | 8 | 22 | ⚠ Issue |

### Why This Matters
Brand and non-brand keywords have different performance characteristics...
[3 paragraphs of explanation]
```

**Problems:**
- Shows passing items as table rows ("OK" rows)
- Includes educational content ("Why This Matters")
- No specific fix recommendations
- Verbose explanations nobody asked for

---

## Skill Categories

For reference, skills fall into these categories:

| Category | Skills | Focus |
|----------|--------|-------|
| Account Structure | 001-011 | Campaign organization, naming, settings |
| Keyword Strategy | 012-024 | Match types, negatives, search terms |
| Ad Copy & Creative | 025-038 | RSA, extensions, ad quality |
| Bidding & Budget | 039-052 | Strategies, budgets, targets |
| Targeting | 053-063 | Location, device, audience |
| Quality Score | 064-069 | QS components, improvement |
| Conversion Tracking | 070-081 | Tracking setup, accuracy |
| Shopping/PMax | 082-095 | Feed optimization, PMax settings |
| Remarketing | 098-112 | Audiences, lists, measurement |
| Waste Prevention | 113-129 | Placements, automation, monitoring |
| Competitive | 130-138 | Auction insights, competitive analysis |
| Compliance | 139-145 | Policy, compliance |
| Seasonal | 146-152 | Seasonal adjustments |
| Platform-Specific | 153-162 | MS Ads, AI features |
