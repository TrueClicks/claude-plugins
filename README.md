# TrueClicks Claude Code Plugins

Claude Code plugins for PPC account management by [TrueClicks](https://www.trueclicks.com).

## Available Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [google-ads](./plugins/google-ads) | Google Ads account management by TrueClicks | 1.0.0 |

## Installation

Install a plugin by adding it to your Claude Code project:

```bash
claude plugin add https://github.com/TrueClicks/claude-plugins --plugin google-ads
```

Or clone the repo and reference a plugin locally:

```bash
git clone https://github.com/TrueClicks/claude-plugins.git
claude --plugin-dir ./claude-plugins/plugins/google-ads
```

## Prerequisites

- [Claude Code](https://claude.ai/code) CLI
- [PowerShell 7.0+](https://github.com/PowerShell/PowerShell/releases) (`pwsh` in PATH)

## License

MIT
