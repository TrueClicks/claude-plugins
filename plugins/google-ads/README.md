# Google Ads Plugin for Claude Code

Free Google Ads account management plugin by [TrueClicks](https://www.trueclicks.com). Fetch account data, analyze and audit accounts, validate and execute changes - all from Claude Code.

## Setup

### Prerequisites

- [PowerShell 7.0+](https://github.com/PowerShell/PowerShell/releases) (`pwsh` must be in PATH)
- A `config.json` file in your project root with API credentials (see below)

### Configuration

Edit `config.json` in the plugin root and fill in your values:

```json
{
  "loginCustomerId": 1234567890,
  "clientCustomerId": 1234567890,
  "gptToken": "YOUR-TOKEN-HERE"
}
```

| Field | Description |
|-------|-------------|
| `loginCustomerId` | Manager account (MCC) ID used for authentication |
| `clientCustomerId` | The Google Ads customer ID to operate on |
| `gptToken` | API token from [gaql.app](https://api.gaql.app) |

> **Note:** `config.json` contains credentials. Do not share it or commit it to version control.

## Commands

| Command | Description |
|---------|-------------|
| `/google-ads:start` | Initialize session, refresh data, check pending changes |
| `/google-ads:get` | Download account data (structure + 30-day performance) to `data/`. Prompts to include paused entities (default: active only) |
| `/google-ads:get-custom` | Run a custom GAQL query, save results to `data/custom/` |
| `/google-ads:validate-changes` | Validate `pending_changes.json` against the API (dry-run) |
| `/google-ads:execute-changes` | Execute `pending_changes.json` in the live account |

## Data Structure

The export is split into two main folders:

### Account Structure (`data/account/`)

Contains account settings and targeting configuration (no performance data).

```
data/account/
  account_summary.md                # Account-level overview
  conversion_actions.md             # Conversion action settings (type, attribution, values)
  shared_negative_lists.md          # Shared negative keyword lists (account-level)
  bidding_strategies.md             # Portfolio bidding strategies (account-level)
  budgets.md                        # Shared and campaign budgets
  ext_sitelinks.md                  # Sitelink extensions (all)
  ext_callouts.md                   # Callout extensions (all)
  ext_structured_snippets.md        # Structured snippet extensions (all)
  ext_price.md                      # Price extensions (all)
  ext_promotion.md                  # Promotion extensions (all)
  ext_call.md                       # Call extensions (all)
  campaigns/
    <Campaign Name>/
      campaign.md                    # Campaign settings (type, bidding, budget, network, geo, shopping, dates, labels)
      bid_adjustments.md             # Device bid modifiers + location targeting
      audience_targeting.md          # User lists, interests, custom audiences
      negative_keywords.md           # Campaign-level negative keywords
      <Ad Group Name>/
        ad_group.md                  # Ad group settings (bid, target CPA)
        ads.md                       # RSA ad copy (headlines, descriptions, URLs, approval status, policy issues)
        keywords.md                  # Keyword settings (match type, bid, quality score, CTR/relevance/landing page components)
        bid_adjustments.md           # Ad group device bid modifiers (overrides campaign)
        audience_targeting.md        # Ad group audience targeting (overrides campaign)
        negative_keywords.md         # Ad group-level negative keywords
```

#### Data Fields by Entity

**Account**: name, currency, timezone, status, auto-tagging, conversion tracking, enhanced conversions for leads, tracking URL template, Google global site tag

**Conversion Actions**: type, origin, category, status, primary for goal, counting type, attribution model, default value/currency, lookback window

**Campaigns**: name, status, channel type/subtype, bidding strategy, budget, serving status, network targeting (search/content), geo target types, shopping settings (merchant ID, priority), start/end dates, labels, asset automation settings

**Ad Groups**: name, status, CPC bid, target CPA

**Ads**: type, status, approval status, policy issues, final URL, paths, headlines, descriptions

**Keywords**: match type, status, CPC bid, quality score (overall + expected CTR, ad relevance, landing page experience), final URL

### Extensions (`ext_*.md`)

All extension files are prefixed with `ext_` for easy identification and sorting:
- Extensions show which level they're linked to: Account (customer-wide), Campaign(s), or Ad Group(s)
- An extension can be linked at multiple levels simultaneously
- "Not linked" means the asset exists but is not currently active

### Performance Metrics (`data/performance/`)

Contains 30-day performance data for all entities.

```
data/performance/
  campaigns/
    <Campaign Name>/
      campaign_metrics_30_days.md    # Campaign performance
      <Ad Group Name>/
        ad_group_metrics_30_days.md  # Ad group performance
        ads_metrics_30_days.md       # Ad performance
        keywords_metrics_30_days.md  # Keyword performance
        search_terms_metrics_30_days.md  # Actual search queries triggering ads
```

### Custom Data (`data/custom/`)

Contains results from custom GAQL queries fetched via `/google-ads:get-custom`.

```
data/custom/
  <query_name>.md                    # Results from custom GAQL queries
```

Use `/google-ads:get-custom` when the standard data export is insufficient (different date ranges, additional metrics, specific segments).

## Working With This Data

### File Formats
- All files are markdown. Settings files use key-value tables. Metrics files use columnar tables.
- Metrics columns: Impressions, Clicks, Cost (currency value), Conversions, Conv Value, CTR (percentage), Avg CPC (currency value).

### Keyword Notation
- `[keyword]` = exact match
- `"keyword"` = phrase match
- bare `keyword` = broad match

### Bid Modifier Notation
- `+20%` = increase bid by 20%
- `-30%` = decrease bid by 30%
- `Excluded` = device/location excluded (bid modifier = 0 or negative location)
- `No adjustment` = default bid (modifier = 1.0 or 100%)

### Other Notes
- Search term Status: "Added" = exists as a keyword, "None" = triggered by match type expansion, "Excluded" = added as a negative keyword.
- Quality Score of "N/A" means insufficient data (not that it's missing).
- Ad group-level bid adjustments and audience targeting override campaign-level settings.

## Making Changes

- **Only propose changes when the user explicitly asks** to plan or make changes. Do not proactively suggest a change plan during analysis or auditing unless requested.
- Claude does **not** execute changes in Google Ads directly. It prepares a structured change plan in `pending_changes.json` for human review and approval.
- If a `pending_changes.json` file already exists, read it to review and give the user an overview of pending changes before proposing new ones.

### Documentation

See the `docs/` folder for complete specifications:

- **[docs/PENDING_CHANGES.md](docs/PENDING_CHANGES.md)** - Main specification, root structure, supported operations
- **[docs/PENDING_CHANGES_BUDGET.md](docs/PENDING_CHANGES_BUDGET.md)** - Budget create/update operations
- **[docs/PENDING_CHANGES_CAMPAIGN.md](docs/PENDING_CHANGES_CAMPAIGN.md)** - Campaign create/update/pause operations
- **[docs/PENDING_CHANGES_ADGROUP.md](docs/PENDING_CHANGES_ADGROUP.md)** - Ad group create/update/pause operations
- **[docs/PENDING_CHANGES_AD.md](docs/PENDING_CHANGES_AD.md)** - RSA ad create/update/pause operations
- **[docs/PENDING_CHANGES_KEYWORD.md](docs/PENDING_CHANGES_KEYWORD.md)** - Keyword create/update/pause operations
- **[docs/PENDING_CHANGES_NEGATIVE_KEYWORD.md](docs/PENDING_CHANGES_NEGATIVE_KEYWORD.md)** - Negative keyword create/remove operations
- **[docs/PENDING_CHANGES_BIDDING_STRATEGY.md](docs/PENDING_CHANGES_BIDDING_STRATEGY.md)** - Portfolio bidding strategy operations
- **[docs/PENDING_CHANGES_EXTENSION.md](docs/PENDING_CHANGES_EXTENSION.md)** - All extension types (sitelinks, callouts, etc.)
