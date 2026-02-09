#!/usr/bin/env bash
# Claude Code RPG Mode - One-command installer
# https://github.com/iammarcin/cc4life

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GOLD='\033[38;5;220m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

RPG_DIR="$HOME/.claude-rpg"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
SETUP_STATUSLINE=false

for arg in "$@"; do
    case "$arg" in
        --statusline) SETUP_STATUSLINE=true ;;
    esac
done

echo ""
printf "  ${GOLD}╔══════════════════════════════════════╗${RESET}\n"
printf "  ${GOLD}║${RESET}  ${BOLD}⚔️  Claude Code RPG Mode  ⚔️${RESET}         ${GOLD}║${RESET}\n"
printf "  ${GOLD}║${RESET}  ${DIM}Turn your coding into an adventure${RESET}   ${GOLD}║${RESET}\n"
printf "  ${GOLD}╚══════════════════════════════════════╝${RESET}\n"
echo ""

# Step 1: Create RPG directory
printf "  ${CYAN}[1/4]${RESET} Setting up RPG directory...\n"
mkdir -p "$RPG_DIR/scripts"
mkdir -p "$RPG_DIR/sounds"

# Step 2: Copy scripts
printf "  ${CYAN}[2/4]${RESET} Installing RPG engine...\n"
cp "$PROJECT_DIR/scripts/rpg-engine.sh" "$RPG_DIR/scripts/"
cp "$PROJECT_DIR/scripts/rpg-statusline.sh" "$RPG_DIR/scripts/"
chmod +x "$RPG_DIR/scripts/rpg-engine.sh"
chmod +x "$RPG_DIR/scripts/rpg-statusline.sh"

# Step 3: Backup existing settings
printf "  ${CYAN}[3/4]${RESET} Backing up Claude Code settings...\n"
BACKUP_DIR="$RPG_DIR/backups"
mkdir -p "$BACKUP_DIR"

if [[ -f "$CLAUDE_SETTINGS" ]]; then
    BACKUP_FILE="$BACKUP_DIR/settings.json.$(date +%Y%m%d_%H%M%S).bak"
    cp "$CLAUDE_SETTINGS" "$BACKUP_FILE"
    printf "  ${GREEN}✓${RESET} Backup saved to ${DIM}${BACKUP_FILE}${RESET}\n"
else
    printf "  ${DIM}  No existing settings to back up${RESET}\n"
fi

# Step 4: Set up hooks
printf "  ${CYAN}[4/4]${RESET} Configuring Claude Code hooks...\n"

if [[ -f "$CLAUDE_SETTINGS" ]]; then
    # Check if hooks already exist
    if python3 -c "
import json
with open('$CLAUDE_SETTINGS') as f:
    data = json.load(f)
if 'hooks' in data and data['hooks']:
    exit(1)
exit(0)
" 2>/dev/null; then
        # No existing hooks - safe to merge
        python3 -c "
import json

with open('$CLAUDE_SETTINGS') as f:
    settings = json.load(f)

with open('$PROJECT_DIR/settings.json') as f:
    rpg_hooks = json.load(f)

settings['hooks'] = rpg_hooks['hooks']

with open('$CLAUDE_SETTINGS', 'w') as f:
    json.dump(settings, f, indent=2)
" 2>/dev/null
        printf "  ${GREEN}✓${RESET} Hooks added to existing settings\n"
    else
        # Existing hooks found - don't overwrite
        printf "  ${YELLOW}⚠${RESET}  Existing hooks found in ${CLAUDE_SETTINGS}\n"
        printf "    ${DIM}To avoid conflicts, hooks were NOT auto-merged.${RESET}\n"
        printf "    ${DIM}Merge manually from: ${PROJECT_DIR}/settings.json${RESET}\n"
        echo ""
        printf "    ${BOLD}Quick option:${RESET} Copy RPG settings to project-level hooks instead:\n"
        printf "    ${DIM}cp ${PROJECT_DIR}/settings.json .claude/settings.json${RESET}\n"
    fi
else
    # No settings file at all - create one
    mkdir -p "$HOME/.claude"
    cp "$PROJECT_DIR/settings.json" "$CLAUDE_SETTINGS"
    printf "  ${GREEN}✓${RESET} Created ${CLAUDE_SETTINGS} with RPG hooks\n"
fi

# Optional: Set up status line
if [[ "$SETUP_STATUSLINE" == true ]]; then
    printf "  ${CYAN}[+]${RESET} Setting up RPG status line...\n"
    python3 -c "
import json, os
settings_path = os.path.expanduser('$CLAUDE_SETTINGS')
with open(settings_path) as f:
    settings = json.load(f)
settings['statusline_command'] = os.path.expanduser('~/.claude-rpg/scripts/rpg-statusline.sh')
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
" 2>/dev/null
    printf "  ${GREEN}✓${RESET} Status line configured — your level & XP show at the bottom of Claude Code\n"
fi

# Done!
echo ""
printf "  ${GREEN}${BOLD}✅ Installation complete!${RESET}\n"
echo ""
printf "  ${DIM}RPG data:${RESET}    $RPG_DIR/\n"
printf "  ${DIM}Scripts:${RESET}     $RPG_DIR/scripts/\n"
printf "  ${DIM}Sounds:${RESET}      $RPG_DIR/sounds/ ${DIM}(add .wav/.mp3 files here)${RESET}\n"
echo ""
printf "  ${BOLD}Quick commands:${RESET}\n"
printf "    ${CYAN}~/.claude-rpg/scripts/rpg-engine.sh stats${RESET}  - View your character\n"
printf "    ${CYAN}~/.claude-rpg/scripts/rpg-engine.sh reset${RESET}  - Start fresh\n"
echo ""
printf "  ${GOLD}Now open Claude Code and start your adventure! 🎮${RESET}\n"
echo ""

# Tips for optional features
printf "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
if [[ "$SETUP_STATUSLINE" != true ]]; then
    printf "  ${DIM}💡 Want to see your level & XP at the bottom of Claude Code?${RESET}\n"
    printf "  ${DIM}   Run: ${RESET}${CYAN}bash install.sh --statusline${RESET}\n"
    echo ""
fi
if [[ ! "$(ls -A "$RPG_DIR/sounds/" 2>/dev/null)" ]]; then
    printf "  ${DIM}🔊 Want RPG sound effects? Add .wav/.mp3 files to ~/.claude-rpg/sounds/${RESET}\n"
    printf "  ${DIM}   Named: session_start, quest_accept, quest_complete,${RESET}\n"
    printf "  ${DIM}   code_forge, spell_cast, notification, level_up, achievement${RESET}\n"
    printf "  ${DIM}   Free sounds: https://opengameart.org/art-search?keys=rpg+sound${RESET}\n"
fi
printf "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
echo ""
