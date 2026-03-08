---
name: skill-145-prelaunch-compliance-checklist
description: "Pre-launch compliance checklist for new ads covering prohibited content, editorial standards, and policy requirements."
allowed-tools: Read, Grep, Glob
---
# Skill 145: Pre-Launch Compliance Checklist

## Purpose

Provide a systematic pre-launch review checklist to catch policy violations before ads go live. Prevents disapprovals, delays, and potential strikes by ensuring all ads meet Google Ads policy requirements.

## Data Requirements

**Data Source:** Standard (for comparison)

**Standard Data:**
- `data/account/campaigns/*/*/ads.md` - Existing approved ads (for reference)
- `data/account/ext_*.md` - Extension templates

This skill is primarily a checklist guide rather than data analysis.

## Analysis Steps

1. **Check prohibited content:** Verify product/service is allowed
2. **Review editorial standards:** Check headlines and descriptions for formatting
3. **Verify claims:** Ensure all claims are substantiated
4. **Audit landing page:** Confirm destination compliance
5. **Check targeting alignment:** Verify audience/content appropriateness
6. **Review extensions:** Validate extension compliance

## Thresholds

| Condition | Severity |
|-----------|----------|
| Prohibited content detected | Critical |
| Restricted content without certification | Critical |
| Unsubstantiated claim ("Best", "#1") | Warning |
| Editorial issue (caps, punctuation) | Warning |
| Landing page missing required elements | Warning |

## Output

**Short format (default):**
```
## Pre-Launch Compliance Checklist

**Campaign:** [Name] | **Ads to Review:** [X]

### Prohibited Content Check
| Check | Status |
|-------|--------|
| Not counterfeit goods | [ ] Pass |
| Not dangerous products | [ ] Pass |
| Not enabling dishonest behavior | [ ] Pass |
| No adult content | [ ] Pass |

### Editorial Standards
| Check | Status | Issue |
|-------|--------|-------|
| No excessive CAPS | [ ] Pass/Fail | [Detail] |
| No gimmicky punctuation | [ ] Pass/Fail | [Detail] |
| Correct spelling | [ ] Pass/Fail | [Detail] |
| Proper grammar | [ ] Pass/Fail | [Detail] |

### Claims Verification
| Claim | Type | Substantiated |
|-------|------|---------------|
| "[Claim]" | Price | [ ] Yes/No |
| "[Claim]" | Comparison | [ ] Yes/No |

### Landing Page Compliance
| Requirement | Status |
|-------------|--------|
| URL accessible | [ ] Pass |
| SSL valid | [ ] Pass |
| Privacy policy present | [ ] Pass |
| Content matches ad | [ ] Pass |

### Launch Decision
[ ] APPROVED - All checks passed
[ ] CONDITIONAL - Fix noted issues first
[ ] NOT APPROVED - Critical violations
```

**Detailed adds:**
- Full checklist by category
- Common rejection reasons quick reference
- Extension compliance checklist
- Post-launch monitoring guidance
