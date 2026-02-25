# Google Ads Plugin for Claude Code

Free Google Ads account management plugin by [TrueClicks](https://www.trueclicks.com). Fetch account data, analyze and audit accounts, validate and execute changes - all from Claude Code.

## Setup

### Prerequisites

- [PowerShell 7.0+](https://github.com/PowerShell/PowerShell/releases) (`pwsh` must be in PATH)

### Getting Started

1. Create a project folder for your Google Ads account
2. Edit `config.json` with your credentials:

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

3. Run `/google-ads:start` to download account data, scripts, commands, and docs into your project folder.

After the first run, all commands and scripts are available locally in your project.
