#!/usr/bin/env bash
# Claude Code RPG Mode - Status Line Script
# Model name always visible. RPG notifications appear after it for ~30 seconds on events.
#
# Setup: bash install.sh --statusline

set -euo pipefail

STATE_FILE="${HOME}/.claude-rpg/state.json"
EVENT_FILE="${HOME}/.claude-rpg/.last_event"
EVENT_DURATION=30  # seconds to show RPG notification

# Read stdin (Claude Code passes session JSON)
input=$(cat)

# Extract model name from session data
model=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('model',{}).get('display_name',''))" 2>/dev/null || echo "")

# If no RPG state yet, just show model
if [[ ! -f "$STATE_FILE" ]]; then
    echo "${model}"
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

# Check for recent event (stays visible for EVENT_DURATION seconds, then auto-expires)
rpg_info=""
if [[ -f "$EVENT_FILE" ]]; then
    IFS='|' read -r event_ts event_type event_msg < "$EVENT_FILE"
    now=$(date +%s)
    age=$(( now - ${event_ts:-0} ))

    if [[ $age -lt $EVENT_DURATION ]]; then
        # Event is fresh — show it
        case "$event_type" in
            level_up)     rpg_info="⚡ ${event_msg} ⚡" ;;
            achievement)  rpg_info="🏆 ${event_msg}" ;;
            quest_complete) rpg_info="${emoji} +25 XP ${event_msg}" ;;
            session_start)  rpg_info="⚔️ ${event_msg}" ;;
        esac
    else
        # Event expired — clean up
        rm -f "$EVENT_FILE"
    fi
fi

# Output: model always first, RPG notification appended when active
if [[ -n "$rpg_info" ]]; then
    echo "${model} | ${rpg_info}"
else
    echo "${model}"
fi
