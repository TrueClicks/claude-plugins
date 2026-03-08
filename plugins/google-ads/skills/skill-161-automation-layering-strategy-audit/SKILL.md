---
name: skill-161-automation-layering-strategy-audit
description: "Evaluate whether Smart Bidding is layered with manual guardrails (scripts, rules, monitoring)."
allowed-tools: Read, Grep, Glob
---
# Skill 161: Automation Layering Strategy Audit

## Purpose
Assess whether Google automation (Smart Bidding, PMax, broad match) is supplemented with appropriate guardrails. Pure automation without oversight leads to runaway spend, missed opportunities, or gradual performance drift. Layered control provides the best balance of AI efficiency and strategic governance.

## Data Requirements

**Data Source:** Standard + Account Configuration Review

**Standard Data:**
- `data/account/campaigns/*/campaign.md` - Bid strategies, automation settings
- `data/account/bidding_strategies.md` - Portfolio strategies

**Additional Review Required:**
- Automated rules configuration (Google Ads UI)
- Scripts deployed in account
- Third-party tools connected
- Review/monitoring cadence documentation

**Reference GAQL:**
```sql
SELECT
  campaign.name,
  campaign.bidding_strategy_type,
  campaign.status
FROM campaign
WHERE campaign.status = 'ENABLED'
```
Use `/google-ads-get-custom` if you need to check specific automation configurations.

## Analysis Steps

1. **Inventory automation:** Document Smart Bidding strategies, PMax campaigns, broad match usage
2. **Evaluate guardrail coverage:** Check for budget pacing rules, spend anomaly alerts, auto-pause rules
3. **Assess script coverage:** Identify deployed scripts (budget pacing, n-gram analysis, anomaly detection)
4. **Review monitoring frequency:** Verify alert configuration, dashboard review schedule, escalation procedures
5. **Identify conflicts:** Check for competing automation or over-automation issues

## Thresholds

| Condition | Severity |
|-----------|----------|
| Smart Bidding with no budget protection rules | Critical |
| No anomaly detection (spend spike/drop alerts) | Critical |
| No script for search term/n-gram automation | Warning |
| Automated rules not running (check execution logs) | Warning |
| Weekly human review not documented | Warning |
| Scripts duplicating functionality | Info |

## Output

**Short format (default):**
```
## Automation Layering Audit
**Account:** [Name] | **Automation coverage:** [X]% | **Guardrail gaps:** [Y]

### Critical ([Count])
- **Budget protection**: No rules configured -> Add spend alert at 80% daily budget
- **Anomaly detection**: Missing -> Configure CPA spike alerts

### Warnings ([Count])
- **Search term automation**: No n-gram script -> Deploy to catch waste between reviews

### Automation Inventory
| Layer | Coverage | Status |
|-------|----------|--------|
| Google Auto | X% | Good/Needs work |
| Rules/Alerts | X% | Good/Needs work |
| Scripts | X% | Good/Needs work |
| Human Review | X% | Good/Needs work |

### Recommendations
1. Deploy [script/rule] for [purpose]
```

**Detailed adds:**
- Complete automation inventory by layer
- Rule configuration recommendations with specific triggers
- Script deployment priorities
- Human oversight schedule template
