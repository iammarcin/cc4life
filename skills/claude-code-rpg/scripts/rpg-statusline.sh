#!/usr/bin/env bash
# Claude Code RPG Mode - Status Line Script
# Shows your RPG stats persistently at the bottom of Claude Code
#
# Setup: Run install.sh --statusline
# Or manually: claude config set statusline_command ~/.claude-rpg/scripts/rpg-statusline.sh

set -euo pipefail

STATE_FILE="${HOME}/.claude-rpg/state.json"

# Read stdin (Claude Code passes session JSON)
input=$(cat)

# Extract model name from session data
model=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('model',{}).get('display_name',''))" 2>/dev/null || echo "")

# If no RPG state yet, just show model
if [[ ! -f "$STATE_FILE" ]]; then
    if [[ -n "$model" ]]; then
        echo "$model"
    fi
    exit 0
fi

# Read RPG state
read -r xp level title <<< "$(python3 -c "
import json
with open('$STATE_FILE') as f:
    d = json.load(f)
print(d.get('xp', 0), d.get('level', 1), d.get('title', 'Apprentice'))
" 2>/dev/null || echo "0 1 Apprentice")"

# Level thresholds
LEVELS=(0 100 300 600 1000 1500 2200 3000 4000 5500)
EMOJIS=("📜" "🗡️" "⚔️" "🛡️" "🧙" "🔮" "👑" "🌟" "✨" "🌌")

emoji="${EMOJIS[$((level-1))]}"
next_xp=999999
current_xp="${LEVELS[$((level-1))]}"
if [[ $level -lt ${#LEVELS[@]} ]]; then
    next_xp="${LEVELS[$level]}"
fi

xp_in_level=$(( xp - current_xp ))
xp_needed=$(( next_xp - current_xp ))
pct=0
if [[ $xp_needed -gt 0 ]]; then
    pct=$(( xp_in_level * 100 / xp_needed ))
fi

# Build mini progress bar (5 chars wide)
bar_width=5
filled=$(( pct * bar_width / 100 ))
empty=$(( bar_width - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Output: emoji Title Lvl X | XP/Next [█████] | model
parts="${emoji} ${title} Lvl ${level} | ${xp}/${next_xp} XP [${bar}]"
if [[ -n "$model" ]]; then
    parts="${parts} | ${model}"
fi

echo "$parts"
