# Download Google Ads data

## Step 1: Check Configuration

Check if `config.json` exists in the project root.

- If it **does not exist** or **contains placeholder values** (`YOUR-TOKEN-HERE`, `1234567890`): tell the user to run `/google-ads:start` first to set up their credentials. **Stop here.**
- If it **exists with real values**: continue to Step 2.

## Step 2: Ask which entities to include

Use the AskUserQuestion tool to ask:
- **Question:** "Which entities should be included in the download?"
- **Options:**
  1. **Active only (Recommended)** - Only enabled campaigns, ad groups, ads, and keywords
  2. **Include paused** - Also include paused campaigns, ad groups, ads, and keywords

## Step 3: Run the data fetch

Based on the user's answer, set `includePaused` to `false` (active only) or `true` (include paused).

Read `config.json` to get `loginCustomerId`, `clientCustomerId`, and `gptToken`.

Run the following command:

```
curl -s -o response.zip -X POST "https://api.claudeppc.ai/api/cli/google-ads/get-data?includePaused={includePaused}" -F "config=@config.json"
```

Then extract and clean up:
```
rm -rf data && unzip -o response.zip && rm response.zip
```

If the command fails, show the error message to the user and suggest checking `config.json`.

## Step 4: Summarize results

After the download completes successfully:
1. Read `data/account/account_summary.md` to load account context.
2. Give the user a brief summary of what was downloaded (account name, number of campaigns, date range).
3. Mention whether paused entities were included or not.
