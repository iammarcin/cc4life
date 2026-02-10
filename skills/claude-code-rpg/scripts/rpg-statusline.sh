#!/usr/bin/env bash
# Claude Code RPG Mode - Status Line Script
# Model always visible. RPG notifications show for a few turns after events.
#
# Setup: bash install.sh --statusline

set -euo pipefail

STATE_FILE="${HOME}/.claude-rpg/state.json"
EVENT_FILE="${HOME}/.claude-rpg/.last_event"
STATS_FILE="${HOME}/.claude/stats-cache.json"
EVENT_READS=3  # Show event for this many status line updates

# Read stdin (Claude Code passes session JSON)
input=$(cat)

# Extract model name and context from input JSON
usage_and_model=$(echo "$input" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    model = data.get('model', {}).get('display_name', '')
    ctx_pct = data.get('context_window', {}).get('used_percentage', 0)
    usage_str = f'Context: {ctx_pct}%' if ctx_pct > 0 else ''
    print(f'{model}\t{usage_str}')
except:
    print('\t')
" 2>/dev/null || echo "	")

# Split by tab delimiter
IFS=$'\t' read -r model usage_info <<< "$usage_and_model"

# If no RPG state yet, just show model | context
if [[ ! -f "$STATE_FILE" ]]; then
    output="$model"
    [[ -n "$usage_info" ]] && output="$output | $usage_info"
    echo "$output"
    exit 0
fi

# Read RPG state
read -r xp level title <<< "$(python3 -c "
import json
with open('$STATE_FILE') as f:
    d = json.load(f)
print(d.get('xp', 0), d.get('level', 1), d.get('title', 'Apprentice'))
" 2>/dev/null || echo "0 1 Apprentice")"

# Level config
EMOJIS=("📜" "🗡️" "⚔️" "🛡️" "🧙" "🔮" "👑" "🌟" "✨" "🌌")
emoji="${EMOJIS[$((level-1))]}"

# Check for event and track how many times we've shown it
rpg_info=""
if [[ -f "$EVENT_FILE" ]]; then
    IFS='|' read -r read_count event_type event_msg < "$EVENT_FILE"

    # Increment read count
    new_count=$((read_count + 1))

    if [[ $new_count -le $EVENT_READS ]]; then
        # Still showing — display it and update counter
        case "$event_type" in
            level_up)       rpg_info="⚡ ${event_msg} ⚡" ;;
            achievement)    rpg_info="🏆 ${event_msg}" ;;
            quest_complete) rpg_info="${emoji} ${event_msg}" ;;
            session_start)  rpg_info="⚔️ ${event_msg}" ;;
        esac

        # Write back with incremented count
        echo "${new_count}|${event_type}|${event_msg}" > "$EVENT_FILE"
    else
        # Shown enough times — clean up
        rm -f "$EVENT_FILE"
    fi
fi

# Output: model | context | RPG (when active)
output="$model"
[[ -n "$usage_info" ]] && output="$output | $usage_info"
[[ -n "$rpg_info" ]] && output="$output | $rpg_info"
echo "$output"
