# Google Ads Plugin for Claude Code

Free Google Ads account management plugin by [TrueClicks](https://www.trueclicks.com). Fetch account data, analyze and audit accounts, validate and execute changes - all from Claude Code.

For full documentation, visit [claudeppc.ai](https://claudeppc.ai).

## Setup

### 1. Create config.json

Go to [claudeppc.ai](https://claudeppc.ai) and click **Get GPT Token** to sign in with your Google account, select your MCC and Google Ads account, then download the `config.json` file.

Each config file is tied to a single Google Ads account. Managing multiple accounts? Create a separate config for each one.

### 2. Place config.json in a folder

Create a folder for the Google Ads account on your disk and move the downloaded `config.json` into it. This folder will be your working directory for Claude Code.

### 3. Start managing your account

Open Claude Code in that folder and run `/google-ads:get` to download your account data and start asking questions.

## Commands

| Command | Description |
|---------|-------------|
| `/google-ads:start` | Welcome screen with setup instructions |
| `/google-ads:get` | Download account structure and performance data |
| `/google-ads:get-custom` | Run a custom GAQL query against the account |
| `/google-ads:validate-changes` | Validate pending changes before applying them |
| `/google-ads:execute-changes` | Apply validated changes to the account |

## FAQ

For frequently asked questions and troubleshooting, visit [claudeppc.ai](https://claudeppc.ai).
