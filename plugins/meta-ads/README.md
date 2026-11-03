# Meta Ads Plugin for Claude

Free Meta Ads account management plugin by [TrueClicks](https://www.trueclicks.com). Fetch Facebook and Instagram campaign data, analyze and audit accounts, validate and execute changes - all from Claude. Works in Claude Cowork, the Code tab of the Claude desktop app, and Claude Code in the terminal.

For full documentation, visit [claudeppc.ai](https://claudeppc.ai).

## Setup

### 1. Create config.json

Go to [claudeppc.ai](https://claudeppc.ai) and sign in with your Meta account, select your ad account, then download the `config.json` file.

Each config file is tied to a single Meta ad account. Managing multiple accounts? Create a separate config for each one.

Note: Meta access tokens last about 60 days. When the token expires, sign in again at claudeppc.ai and download a fresh `config.json`.

### 2. Place config.json in a folder

Create a folder for the Meta ad account on your disk and move the downloaded `config.json` into it. This folder will be your working directory for Claude.

### 3. Start managing your account

Open Claude in that folder (the Cowork or Code tab, or Claude Code in a terminal) and run `/meta-ads:get` to set up the workspace, download your account data, and start asking questions.

## Commands

| Command | Description |
|---------|-------------|
| `/meta-ads:get` | Download the workspace and account data (structure and performance) |
| `/meta-ads:get-custom` | Run a custom Meta Marketing API query against the account |
| `/meta-ads:validate-changes` | Validate pending changes before applying them |
| `/meta-ads:execute-changes` | Apply validated changes to the account |

## FAQ

For frequently asked questions and troubleshooting, visit [claudeppc.ai](https://claudeppc.ai).
