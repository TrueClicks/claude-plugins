# Google Ads Plugin for Claude

Free Google Ads account management plugin by [TrueClicks](https://www.trueclicks.com). Fetch account data, analyze and audit accounts, validate and execute changes - all from Claude. Works in Claude Cowork, the Code tab of the Claude desktop app, and Claude Code in the terminal.

For full documentation, visit [claudeppc.ai](https://claudeppc.ai).

## Setup

### 1. Create config.json

Go to [claudeppc.ai](https://claudeppc.ai) and click **Get GPT Token** to sign in with your Google account, select your MCC and Google Ads account, then download the `config.json` file.

Each config file is tied to a single Google Ads account. Managing multiple accounts? Create a separate config for each one.

### 2. Place config.json in a folder

Create a folder for the Google Ads account on your disk and move the downloaded `config.json` into it. This folder will be your working directory for Claude.

### 3. Start managing your account

Open Claude in that folder (the Cowork or Code tab, or Claude Code in a terminal) and run `/google-ads:get` to download your account data and start asking questions.

## Commands

| Command | Description |
|---------|-------------|
| `/google-ads:get` | Download account structure and performance data |
| `/google-ads:get-custom` | Run a custom GAQL query against the account |
| `/google-ads:validate-changes` | Validate pending changes before applying them |
| `/google-ads:execute-changes` | Apply validated changes to the account |

## FAQ

For frequently asked questions and troubleshooting, visit [claudeppc.ai](https://claudeppc.ai).
