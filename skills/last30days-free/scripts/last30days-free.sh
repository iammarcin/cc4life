#!/bin/bash
# last30days-free v2.0 - Research any topic from the last 30 days
# Uses FREE methods: bird CLI for X + Reddit public JSON API
# Zero API costs!
#
# Features:
# - Reddit + X search with engagement metrics
# - Top comments fetching for context
# - Basic sentiment analysis
# - Markdown export

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
BIRD_SCRIPT="${HOME}/clawd/skills/twitter/scripts/check_twitter.sh"
OUTPUT_DIR="${HOME}/clawd/output/research"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;93m'
CYAN='\033[0;96m'
MAGENTA='\033[0;95m'
BOLD='\033[1m'
NC='\033[0m'

usage() {
    cat << EOF
Usage: $0 <topic> [options]

Research any topic across Reddit + X from the last 30 days.
100% FREE - uses bird CLI + Reddit public JSON API.

Options:
  --limit N       Number of results per source (default: 10)
  --time T        Time range: day, week, month, year (default: month)
  --comments      Fetch top comments from Reddit threads
  --export        Export results to markdown file
  --json          Output as JSON only
  --quiet         Minimal output (for scripting)
  --help          Show this help

Examples:
  $0 "AI agents"
  $0 "openclaw use cases" --limit 15 --comments --export
  $0 "Claude Code tips" --time week --json

EOF
    exit 0
}

# Sentiment analysis (simple keyword-based)
analyze_sentiment() {
    local text="$1"
    local positive=0
    local negative=0
    
    # Positive indicators
    for word in "love" "great" "amazing" "awesome" "best" "excellent" "fantastic" "helpful" "useful" "recommend" "perfect" "easy" "works" "solved" "success"; do
        if echo "$text" | grep -qi "$word"; then
            ((positive++)) || true
        fi
    done
    
    # Negative indicators
    for word in "hate" "awful" "terrible" "worst" "bad" "broken" "frustrating" "useless" "difficult" "problem" "issue" "bug" "fail" "expensive" "complicated"; do
        if echo "$text" | grep -qi "$word"; then
            ((negative++)) || true
        fi
    done
    
    if [[ $positive -gt $negative ]]; then
        echo "positive"
    elif [[ $negative -gt $positive ]]; then
        echo "negative"
    else
        echo "neutral"
    fi
}

# Parse arguments
TOPIC=""
LIMIT=10
TIME="month"
FETCH_COMMENTS=false
EXPORT=false
JSON_OUTPUT=false
QUIET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --time)
            TIME="$2"
            shift 2
            ;;
        --comments)
            FETCH_COMMENTS=true
            shift
            ;;
        --export)
            EXPORT=true
            shift
            ;;
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --quiet|-q)
            QUIET=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            if [[ -z "$TOPIC" ]]; then
                TOPIC="$1"
            else
                TOPIC="$TOPIC $1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$TOPIC" ]]; then
    echo "Error: Topic is required"
    usage
fi

# Slugify topic for filename
TOPIC_SLUG=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
DATE_STR=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

[[ "$QUIET" == "false" ]] && echo -e "${MAGENTA}${BOLD}/last30days-free${NC} · researching: ${TOPIC}"
[[ "$QUIET" == "false" ]] && echo -e "⏳ ${YELLOW}Reddit${NC} Searching public API..."
[[ "$QUIET" == "false" ]] && echo -e "⏳ ${CYAN}X${NC} Searching via bird CLI..."

# Create temp files
REDDIT_FILE=$(mktemp)
X_FILE=$(mktemp)
COMMENTS_FILE=$(mktemp)
trap "rm -f $REDDIT_FILE $X_FILE $COMMENTS_FILE" EXIT

# Search Reddit (background)
(
    node "${SCRIPT_DIR}/reddit.mjs" search all "$TOPIC" --limit "$LIMIT" --time "$TIME" 2>/dev/null > "$REDDIT_FILE" || echo "[]" > "$REDDIT_FILE"
) &
REDDIT_PID=$!

# Search X via bird CLI (background)
(
    "$BIRD_SCRIPT" search "$TOPIC" "$LIMIT" --account personal 2>/dev/null > "$X_FILE" || touch "$X_FILE"
) &
X_PID=$!

# Wait for searches
wait $REDDIT_PID 2>/dev/null || true
REDDIT_COUNT=$(cat "$REDDIT_FILE" | jq -r 'length' 2>/dev/null || echo "0")
[[ "$QUIET" == "false" ]] && echo -e "✓ ${YELLOW}Reddit${NC} Found ${REDDIT_COUNT} threads"

wait $X_PID 2>/dev/null || true
X_COUNT=$(grep -c "^🔗" "$X_FILE" 2>/dev/null || echo "0")
[[ "$QUIET" == "false" ]] && echo -e "✓ ${CYAN}X${NC} Found ${X_COUNT} posts"

# Fetch comments for top Reddit threads if requested
if [[ "$FETCH_COMMENTS" == "true" && "$REDDIT_COUNT" -gt "0" ]]; then
    [[ "$QUIET" == "false" ]] && echo -e "⏳ ${YELLOW}Reddit${NC} Fetching comments from top threads..."
    
    # Get top 3 thread IDs
    TOP_IDS=$(cat "$REDDIT_FILE" | jq -r '.[0:3] | .[].id' 2>/dev/null)
    
    echo "[" > "$COMMENTS_FILE"
    first=true
    for id in $TOP_IDS; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$COMMENTS_FILE"
        fi
        node "${SCRIPT_DIR}/reddit.mjs" comments "$id" --limit 5 2>/dev/null | jq "{thread_id: \"$id\", comments: .}" >> "$COMMENTS_FILE" || echo "{\"thread_id\": \"$id\", \"comments\": []}" >> "$COMMENTS_FILE"
    done
    echo "]" >> "$COMMENTS_FILE"
    
    COMMENTS_COUNT=$(cat "$COMMENTS_FILE" | jq '[.[].comments | length] | add' 2>/dev/null || echo "0")
    [[ "$QUIET" == "false" ]] && echo -e "✓ ${YELLOW}Reddit${NC} Fetched ${COMMENTS_COUNT} comments"
fi

# Calculate sentiment from Reddit titles
REDDIT_SENTIMENT="neutral"
if [[ "$REDDIT_COUNT" -gt "0" ]]; then
    ALL_TITLES=$(cat "$REDDIT_FILE" | jq -r '.[].title' 2>/dev/null | tr '\n' ' ')
    REDDIT_SENTIMENT=$(analyze_sentiment "$ALL_TITLES")
fi

# Calculate totals
TOTAL_REDDIT_SCORE=$(cat "$REDDIT_FILE" | jq '[.[].score] | add // 0' 2>/dev/null || echo "0")
TOTAL_REDDIT_COMMENTS=$(cat "$REDDIT_FILE" | jq '[.[].comments] | add // 0' 2>/dev/null || echo "0")

[[ "$QUIET" == "false" ]] && echo ""

# JSON output mode
if [[ "$JSON_OUTPUT" == "true" ]]; then
    cat << JSONEOF
{
  "topic": "$TOPIC",
  "time_range": "$TIME",
  "generated_at": "$(date -Iseconds)",
  "stats": {
    "reddit_threads": $REDDIT_COUNT,
    "reddit_total_score": $TOTAL_REDDIT_SCORE,
    "reddit_total_comments": $TOTAL_REDDIT_COMMENTS,
    "x_posts": $X_COUNT,
    "sentiment": "$REDDIT_SENTIMENT"
  },
  "reddit": $(cat "$REDDIT_FILE"),
  "x_raw": "$(cat "$X_FILE" | tr '\n' '|' | sed 's/"/\\"/g')"
}
JSONEOF
    exit 0
fi

# Build markdown output
build_markdown() {
    cat << MDEOF
# Research: $TOPIC

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**Time Range:** Last $TIME  
**Method:** FREE (bird CLI + Reddit public JSON API)  
**Cost:** \$0.00

---

## 📊 Summary

| Metric | Value |
|--------|-------|
| Reddit Threads | $REDDIT_COUNT |
| Reddit Total Upvotes | $TOTAL_REDDIT_SCORE |
| Reddit Total Comments | $TOTAL_REDDIT_COMMENTS |
| X Posts | $X_COUNT |
| Overall Sentiment | $REDDIT_SENTIMENT |

---

## 🟠 Reddit Threads

MDEOF

    # Reddit threads
    cat "$REDDIT_FILE" | jq -r '.[] | "### r/\(.subreddit) — \(.score) pts, \(.comments) comments\n\n**\(.title | gsub("&gt;"; ">") | gsub("&lt;"; "<") | gsub("&amp;"; "&"))**\n\n- Author: u/\(.author)\n- Date: \(.created | split("T")[0])\n- Link: \(.permalink)\n\n---\n"' 2>/dev/null || echo "_No Reddit results found._"

    # Comments section
    if [[ "$FETCH_COMMENTS" == "true" && -s "$COMMENTS_FILE" ]]; then
        cat << MDEOF

## 💬 Top Comments

MDEOF
        cat "$COMMENTS_FILE" | jq -r '.[] | select(.comments | length > 0) | "### Thread: \(.thread_id)\n\n" + (.comments[:3] | map("**u/\(.author)** (\(.score) pts):\n> \(.body | split("\n")[0:3] | join(" ") | .[0:300])...\n") | join("\n"))' 2>/dev/null || echo "_No comments fetched._"
    fi

    cat << MDEOF

---

## 🔵 X Posts

MDEOF

    # X posts - parse the bird output
    cat "$X_FILE" | sed 's/──────────────────────────────────────────────────/\n---\n/g' || echo "_No X results found._"

    cat << MDEOF

---

## 🎯 Key Insights

_Based on the research above, key themes and patterns:_

1. **Most discussed aspects:** _(analyze the titles and content)_
2. **Community sentiment:** $REDDIT_SENTIMENT
3. **Top voices:** _(users with highest engagement)_
4. **Actionable takeaways:** _(what can be learned)_

---

*Generated by last30days-free — Zero API costs!*
MDEOF
}

# Output to console
build_markdown

# Export to file if requested
if [[ "$EXPORT" == "true" ]]; then
    mkdir -p "$OUTPUT_DIR"
    EXPORT_FILE="${OUTPUT_DIR}/${DATE_STR}-${TOPIC_SLUG}.md"
    build_markdown > "$EXPORT_FILE"
    echo ""
    echo -e "📁 ${GREEN}Exported to:${NC} $EXPORT_FILE"
fi

echo ""
echo -e "✓ ${GREEN}${BOLD}Research complete${NC} — Reddit: ${REDDIT_COUNT} threads (${TOTAL_REDDIT_SCORE} pts), X: ${X_COUNT} posts"
echo -e "💰 ${GREEN}Cost: \$0.00${NC} (bird CLI + Reddit public API)"
