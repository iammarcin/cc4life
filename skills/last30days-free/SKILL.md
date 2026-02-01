---
name: last30days-free
description: Research any topic from the last 30 days on Reddit + X. 100% FREE - uses bird CLI for X (cookies) and Reddit public JSON API. Zero API costs!
argument-hint: "[topic]"
---

# last30days-free: FREE Research Across Reddit + X

Research ANY topic across Reddit and X from the last 30 days. **Zero API costs** - uses:
- **X/Twitter**: `bird` CLI with session cookies (no xAI API)
- **Reddit**: Public JSON API (no OpenAI API)

## Features

- 🔍 **Reddit + X search** with full engagement metrics
- 💬 **Comment fetching** from top Reddit threads
- 🎯 **Sentiment analysis** (positive/negative/neutral)
- 📁 **Markdown export** to `~/clawd/output/research/`
- 📊 **Summary statistics** (total upvotes, comments, posts)
- 💰 **Zero cost** — no API keys required

## Usage

```bash
# Basic search
~/clawd/skills/last30days-free/scripts/last30days-free.sh "AI agents"

# Full featured (comments + export)
~/clawd/skills/last30days-free/scripts/last30days-free.sh "openclaw use cases" --limit 15 --comments --export

# Quick JSON output for scripting
~/clawd/skills/last30days-free/scripts/last30days-free.sh "Claude Code tips" --json --quiet
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--limit N` | 10 | Results per source |
| `--time T` | month | day, week, month, year |
| `--comments` | off | Fetch top comments from Reddit threads |
| `--export` | off | Save results to markdown file |
| `--json` | off | Output as JSON only |
| `--quiet` | off | Minimal output for scripting |

## Output Format

### Console Output
- Summary table with stats
- Reddit threads with scores, comments, dates
- Top comments (if `--comments`)
- X posts with engagement
- Key insights section

### Exported Markdown
Saved to: `~/clawd/output/research/YYYY-MM-DD-topic-slug.md`

Includes:
- Full metadata and stats
- All Reddit threads
- Top comments with context
- X posts
- Insights template

## Comparison with Paid Version

| Feature | last30days (paid) | last30days-free |
|---------|-------------------|-----------------|
| X Search | xAI API ($$$) | bird CLI (free) |
| Reddit Search | OpenAI API ($$$) | Public JSON (free) |
| Engagement data | ✅ Full | ✅ Full |
| Comments | ❌ | ✅ |
| Sentiment | ❌ | ✅ |
| Export | ❌ | ✅ |
| Cost | ~$0.05-0.20/query | **$0.00** |

## Dependencies

- `bird` CLI configured with Twitter cookies (personal account)
- Node.js for Reddit script
- `jq` for JSON parsing

## Example Workflow

1. **Research a topic:**
   ```bash
   ./last30days-free.sh "proactive AI assistants" --comments --export
   ```

2. **Review the markdown export** in `~/clawd/output/research/`

3. **Synthesize insights** — use the research to:
   - Identify patterns and trends
   - Find what people love/hate
   - Discover use cases and workflows
   - Generate informed prompts

## Files

```
last30days-free/
├── SKILL.md           # This file
└── scripts/
    ├── last30days-free.sh  # Main script
    └── reddit.mjs          # Reddit API client
```

---

*Built by Sherlock 🔍 — Our local project, zero API costs!*
