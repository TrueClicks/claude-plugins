---
name: skill-074-server-side-tagging-assessment
description: "Evaluate the readiness and benefit of migrating from client-side to server-side tagging."
allowed-tools: Read, Grep, Glob
---
# Skill 074: Server-Side Tagging Assessment

## Purpose
Evaluate the readiness and benefit of migrating from client-side to server-side tagging. Server-side tagging improves data accuracy, reduces page load impact, and provides better control over data flowing to advertising platforms.

## Data Requirements

**Data Source:** Standard (plus external assessment)

**Standard Data:**
- `data/account/conversion_actions.md` - Conversion tracking setup
- `data/account/account_summary.md` - Account configuration

Note: Full server-side tagging assessment requires website/infrastructure access beyond Google Ads data.

**Reference GAQL:**
```sql
SELECT
  conversion_action.name,
  conversion_action.type,
  conversion_action.origin
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```
Use `/google-ads:get-custom` to check conversion action origins.

## Analysis Steps

1. **Assess current tracking:** Review conversion action types and origins (website tag, import, etc.).
2. **Identify benefit triggers:** High ad blocker impact, page speed issues, privacy requirements.
3. **Evaluate readiness:** GTM usage, development resources, infrastructure availability.
4. **Recommend approach:** Migration priority based on benefits vs. effort.

## Thresholds

| Condition | Severity |
|-----------|----------|
| GDPR/CCPA strict requirements + no server-side | Critical |
| Estimated >20% tracking loss to ad blockers | Critical |
| Page speed heavily impacted by tags (>500ms) | Warning |
| No server-side tagging but high traffic | Warning |
| Simple tracking setup, low traffic | Info (may not need) |

## Output

**Short (default):**
```
## Server-Side Tagging Assessment

**Account:** [Name] | **Recommendation:** [Proceed/Wait/Not Needed]

### Current State
| Factor | Status | Impact |
|--------|--------|--------|
| Tracking method | [Client-side/Server-side] | - |
| Privacy requirements | [High/Medium/Low] | [Assessment] |
| Estimated ad blocker impact | [%] | [Assessment] |

### Critical ([Count])
- **[Issue]**: [Description] -> [Fix]

### Recommendations
1. [Priority action]
2. [Secondary action]
```

**Detailed adds:**
- Readiness checklist
- Effort estimation
- ROI projection
- Implementation roadmap
