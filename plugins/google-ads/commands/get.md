# Download Google Ads data

## Step 1: Ask which entities to include

Use the AskUserQuestion tool to ask:
- **Question:** "Which entities should be included in the download?"
- **Options:**
  1. **Active only (Recommended)** - Only enabled campaigns, ad groups, ads, and keywords
  2. **Include paused** - Also include paused campaigns, ad groups, ads, and keywords

## Step 2: Run the data fetch script

Based on the user's answer:

- If **Active only**: Run:
  ```
  pwsh -ExecutionPolicy Bypass -File scripts/google-ads-get.ps1
  ```

- If **Include paused**: Run:
  ```
  pwsh -ExecutionPolicy Bypass -File scripts/google-ads-get.ps1 -IncludePaused
  ```

The script reads `config.json`, calls the API, downloads the zip, extracts it to `data/`, and prints the account summary.

## Step 3: Summarize results

After the script completes successfully:
1. Read `data/account/account_summary.md` to load account context.
2. Give the user a brief summary of what was downloaded (account name, number of campaigns, date range).
3. Mention whether paused entities were included or not.

If the script fails, show the error message to the user and suggest checking `config.json`.
