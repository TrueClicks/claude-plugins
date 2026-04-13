# Download Google Ads data

## Step 1: Check Configuration

Check if `config.json` exists in the project root.

- If it **does not exist** or **contains placeholder values** (`YOUR-TOKEN-HERE`, `1234567890`): tell the user to run `/google-ads:start` first to set up their credentials. **Stop here.**
- If it **exists with real values**: continue to Step 2.

## Step 2: Ask what to download

Use the AskUserQuestion tool to ask two questions:

**Question 1:** "What data do you want to download?"
- **Structure + Performance 30d (Recommended)** - Full account structure plus last 30 days → previous 30 days performance comparison
- **Structure only** - Account settings, campaigns, ad groups, ads, keywords, targeting, extensions
- **Performance 30d** - Last 30 days → previous 30 days comparison
- **Performance 7d** - Last 7 days → previous 7 days comparison
- **Performance monthly** - This month → last month → 2 months ago comparison

**Question 2:** "Which entities should be included?"
- **Active only (Recommended)** - Only enabled campaigns, ad groups, ads, and keywords
- **Include paused** - Also include paused campaigns, ad groups, ads, and keywords

## Step 3: Run the data fetch

Based on the user's answers:
- Set `scope` to one of: `structure+30d`, `structure`, `30d`, `7d`, `monthly`
- Set `includePaused` to `false` (active only) or `true` (include paused)

**For `structure+30d`** — run **two sequential fetches**: first `structure`, then `30d`. Follow the fetch and extract steps below for each scope in order. Check for plugin update headers on both responses but only display the notice once.

For each fetch, run the following command (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -o tmp/response.zip -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/google-ads/get-data?includePaused={includePaused}&scope={scope}&pluginVersion=1.8.0" -F "config=@config.json"
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

Then extract based on scope:

**For `structure`** — wipe existing structure data and extract:
```
rm -rf data/account docs CLAUDE.md && unzip -o tmp/response.zip && rm tmp/response.zip
```

**For `30d`, `7d`, or `monthly`** — wipe only that performance dataset and extract:
```
rm -rf data/performance/{scope} && unzip -o tmp/response.zip && rm tmp/response.zip
```

If the command fails, show the error message to the user and suggest checking `config.json`.

## Step 4: Summarize results

After the download completes successfully:

**For `structure+30d`:**
1. Read `data/account/account_summary.md` to load account context.
2. Give the user a brief summary of what was downloaded (account name, number of campaigns, plus 30-day performance data).
3. Mention whether paused entities were included or not.

**For `structure`:**
1. Read `data/account/account_summary.md` to load account context.
2. Give the user a brief summary of what was downloaded (account name, number of campaigns).
3. Mention whether paused entities were included or not.
4. Check if `data/performance/` folder exists. If it does not, ask the user if they also want to download 30-day performance data — it enables performance-based analysis and auditing.

**For performance datasets (`30d`, `7d`, `monthly`):**
1. List the periods covered (shown in the file headers as `- Periods: ...`).
2. Mention the number of campaigns with performance data.
3. Remind the user that performance values use `→` to separate periods (newest → oldest).
