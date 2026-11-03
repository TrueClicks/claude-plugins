# Download Meta Ads data

## Step 1: Check Configuration

Check if `config.json` exists in the project root.

- If it **does not exist**: tell the user to visit [claudeppc.ai](https://claudeppc.ai) to download their Meta Ads `config.json` and place it in the project root. **Stop here.**
- If it exists but `platform` is **not** `meta-ads` (e.g. `google-ads`): tell the user this config.json belongs to a different platform; for Google Ads use the `google-ads` plugin, or download a Meta Ads config.json from [claudeppc.ai](https://claudeppc.ai). **Stop here.**
- If it **exists with** `"platform": "meta-ads"`: continue to Step 2.

## Step 2: Download the workspace

Unlike Google Ads, there is no default data export for Meta: this step downloads the workspace (CLAUDE.md plus the query and change documentation in `docs/`), and account data is fetched with targeted queries in Step 3.

Run (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -o tmp/response.zip -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/meta-ads/get-data?pluginVersion=1.0.0" -F "config=@config.json"
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

Extract (this refreshes the workspace docs but leaves previously fetched data in `data/` untouched):

```
rm -rf docs CLAUDE.md && unzip -o tmp/response.zip && rm tmp/response.zip
```

If the command fails, show the error message to the user and suggest checking `config.json`.

## Step 3: Ask what to download

Read the `adAccountId` value from `config.json` — it is needed for the query paths below.

Use the AskUserQuestion tool to ask: "What data do you want to download?"

- **Structure + Performance 30d (Recommended)** - Campaigns, ad sets, and ads with settings, plus last-30-day performance
- **Structure only** - Campaigns, ad sets, and ads with settings and targeting
- **Performance 30d** - Last-30-day performance per campaign, daily
- **Skip for now** - Fetch data later with custom queries

## Step 4: Run the data fetches

Read `docs/CUSTOM_QUERY.md` first. Then run the queries for the chosen option. Each fetch follows this pattern (**set Bash timeout to 240000ms**), with `{AD_ACCOUNT_ID}` replaced by the `adAccountId` from `config.json`:

```
mkdir -p tmp && curl -s --max-time 230 -o tmp/response.zip -X POST "https://api.claudeppc.ai/api/cli/meta-ads/get-custom-data?pluginVersion=1.0.0" -F "config=@config.json" -F "name={name}" -F "path={path}" -F 'params={params}' && unzip -o tmp/response.zip -d data && rm tmp/response.zip
```

**Structure** (3 queries):

| name | path | params |
|------|------|--------|
| `campaigns` | `act_{AD_ACCOUNT_ID}/campaigns` | `{"fields":"name,status,effective_status,objective,special_ad_categories,daily_budget,lifetime_budget,bid_strategy,spend_cap,start_time,stop_time","limit":200}` |
| `adsets` | `act_{AD_ACCOUNT_ID}/adsets` | `{"fields":"name,status,effective_status,campaign_id,daily_budget,lifetime_budget,optimization_goal,billing_event,bid_strategy,bid_amount,promoted_object,targeting,start_time,end_time","limit":200}` |
| `ads` | `act_{AD_ACCOUNT_ID}/ads` | `{"fields":"name,status,effective_status,adset_id,campaign_id,creative{title,body,object_story_spec}","limit":100}` |

**Performance 30d** (1 query):

| name | path | params |
|------|------|--------|
| `performance-30d` | `act_{AD_ACCOUNT_ID}/insights` | `{"level":"campaign","fields":"campaign_id,campaign_name,spend,impressions,clicks,ctr,cpm,actions,action_values","date_preset":"last_30d","time_increment":1,"limit":500}` |

For **Structure + Performance 30d**, run all 4 queries.

If a `data/custom/<name>.TRUNCATED.txt` file appears, that result is incomplete — tell the user and refetch with a narrower query (see `docs/CUSTOM_QUERY.md`).

## Step 5: Summarize results

Results are JSONL files in `data/custom/` (one JSON object per line). After the downloads complete, give the user a brief summary:

1. Number of campaigns, ad sets, and ads, and how many of each are actually running (`effective_status` = `ACTIVE`).
2. For performance data: total 30-day spend, clicks, and conversions (sum the `actions` entries).

Watch the data gotchas from `docs/CUSTOM_QUERY.md` when summarizing:
- Insights metric values are **strings** — convert before math.
- `daily_budget` / `lifetime_budget` are in **cents**; insights `spend` is in **whole currency units**.
