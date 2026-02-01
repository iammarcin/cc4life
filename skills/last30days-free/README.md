# last30days-free

**Research any topic from the last 30 days on Reddit + X — 100% FREE**

A free alternative to paid research skills. Uses:
- **bird CLI** for X/Twitter search (session cookies, no API)
- **Reddit public JSON API** (no auth required for searching)

## Features

- 🔍 Reddit + X search with engagement metrics (upvotes, likes, comments)
- 💬 Comment fetching from top Reddit threads
- 🎯 Sentiment analysis (positive/negative/neutral)
- 📁 Markdown export
- 💰 **Zero API costs**

## Installation

### For Claude Code / OpenClaw

Copy the `last30days-free` folder to your skills directory:

```bash
# Claude Code
cp -r last30days-free ~/.claude/skills/

# OpenClaw
cp -r last30days-free ~/clawd/skills/
```

### Dependencies

1. **bird CLI** — for X/Twitter search
   - Follow setup at: https://github.com/openclaw/bird
   - Requires Twitter session cookies

2. **Node.js** — for Reddit script

3. **jq** — for JSON parsing
   ```bash
   # Ubuntu/Debian
   sudo apt install jq
   
   # macOS
   brew install jq
   ```

## Usage

```bash
# Basic search
./scripts/last30days-free.sh "AI agents"

# With all features
./scripts/last30days-free.sh "Claude Code tips" --limit 15 --comments --export

# JSON output
./scripts/last30days-free.sh "topic" --json
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--limit N` | 10 | Results per source |
| `--time T` | month | day, week, month, year |
| `--comments` | off | Fetch top comments |
| `--export` | off | Save to markdown |
| `--json` | off | JSON output |
| `--quiet` | off | Minimal output |

## Comparison

| Feature | Paid alternatives | last30days-free |
|---------|-------------------|-----------------|
| X Search | xAI API ($$$) | bird CLI (free) |
| Reddit | OpenAI API ($$$) | Public JSON (free) |
| Cost per query | $0.05-0.20 | **$0.00** |
| Comments | ❌ | ✅ |
| Sentiment | ❌ | ✅ |
| Export | ❌ | ✅ |

## Credits

- Inspired by Matt Van Horn's [last30days-skill](https://github.com/mvanhorn/last30days-skill)
- Reddit scraper based on [theglove44/reddit](https://clawhub.ai/theglove44/reddit)
- Built by [@waiting4ai](https://x.com/waiting4ai) + Sherlock 🔍

## License

MIT
