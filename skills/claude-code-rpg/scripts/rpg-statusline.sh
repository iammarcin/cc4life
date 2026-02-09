#!/usr/bin/env bash
# Claude Code RPG Mode - Status Line Script
# Compact by default, expands briefly on big moments (level up, achievement, quest complete)
#
# Setup: bash install.sh --statusline

set -euo pipefail

STATE_FILE="${HOME}/.claude-rpg/state.json"
EVENT_FILE="${HOME}/.claude-rpg/.last_event"

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
LEVELS=(0 100 300 600 1000 1500 2200 3000 4000 5500)
EMOJIS=("📜" "🗡️" "⚔️" "🛡️" "🧙" "🔮" "👑" "🌟" "✨" "🌌")

emoji="${EMOJIS[$((level-1))]}"
next_xp=999999
if [[ $level -lt ${#LEVELS[@]} ]]; then
    next_xp="${LEVELS[$level]}"
fi

# Check for recent event (show expanded if event happened in last 30 seconds)
expanded=""
if [[ -f "$EVENT_FILE" ]]; then
    # Format: timestamp|type|message (message may contain pipes)
    IFS='|' read -r event_ts event_type event_msg < "$EVENT_FILE"
    now=$(date +%s)
    age=$(( now - ${event_ts:-0} ))

    if [[ $age -lt 30 ]]; then
        case "$event_type" in
            level_up)
                expanded="⚡ ${event_msg} ⚡"
                ;;
            achievement)
                expanded="🏆 ${event_msg}"
                ;;
            quest_complete)
                expanded="${emoji} ${title} Lvl ${level} | ${event_msg}"
                ;;
            session_start)
                expanded="⚔️ ${event_msg}"
                ;;
        esac
    fi

    # Clear event after reading so it only shows once
    rm -f "$EVENT_FILE"
fi

# Build output
if [[ -n "$expanded" ]]; then
    # Expanded mode: show the event message
    if [[ -n "$model" ]]; then
        echo "${expanded} | ${model}"
    else
        echo "${expanded}"
    fi
else
    # Compact mode: just a small badge
    if [[ -n "$model" ]]; then
        echo "${model} | ${emoji} Lvl ${level} ${xp}/${next_xp}"
    else
        echo "${emoji} ${title} Lvl ${level} | ${xp}/${next_xp}"
    fi
fi
