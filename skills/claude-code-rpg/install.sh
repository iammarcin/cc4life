#!/usr/bin/env bash
# Claude Code RPG Mode - Installer/Uninstaller
# https://github.com/iammarcin/cc4life

set -euo pipefail

RPG_DIR="${HOME}/.claude-rpg"
SETTINGS_FILE="${HOME}/.claude/settings.json"
BACKUP_FILE="${RPG_DIR}/backups/settings.backup.$(date +%Y%m%d_%H%M%S).json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

show_usage() {
    cat << EOF
${CYAN}Claude Code RPG Mode - Installer${RESET}

Usage: $0 [command]

Commands:
    install     Install RPG mode hooks and statusline
    uninstall   Remove RPG mode and restore original settings
    status      Check installation status
    help        Show this help message

Examples:
    $0 install
    $0 uninstall
    $0 status
EOF
}

check_requirements() {
    if [ ! -d "$HOME/.claude" ]; then
        echo -e "${RED}Error: Claude Code directory not found at ~/.claude${RESET}"
        echo "Please install Claude Code first: https://claude.com/claude-code"
        exit 1
    fi

    if [ ! -f "$SETTINGS_FILE" ]; then
        echo -e "${YELLOW}Warning: settings.json not found. Creating default...${RESET}"
        echo '{}' > "$SETTINGS_FILE"
    fi
}

backup_settings() {
    mkdir -p "${RPG_DIR}/backups"
    if [ -f "$SETTINGS_FILE" ]; then
        cp "$SETTINGS_FILE" "$BACKUP_FILE"
        echo -e "${GREEN}✓ Backed up settings to: $BACKUP_FILE${RESET}"
    fi
}

install_rpg() {
    echo -e "${CYAN}Installing Claude Code RPG Mode...${RESET}\n"

    check_requirements
    backup_settings

    # Create RPG directory structure if needed
    mkdir -p "$RPG_DIR"/{scripts,sounds,backups}

    # Initialize state if doesn't exist
    if [ ! -f "$RPG_DIR/state.json" ]; then
        cat > "$RPG_DIR/state.json" << 'EOFSTATE'
{
  "xp": 0,
  "level": 0,
  "total_sessions": 0,
  "streak_days": 0,
  "last_session": ""
}
EOFSTATE
        echo -e "${GREEN}✓ Initialized RPG state${RESET}"
    fi

    # Install hooks configuration
    python3 << EOFPYTHON
import json

settings_file = "$SETTINGS_FILE"
rpg_dir = "$RPG_DIR"

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)
except:
    settings = {}

# Add RPG hooks
settings['hooks'] = {
    "SessionStart": [{
        "hooks": [{
            "type": "command",
            "command": f"{rpg_dir}/scripts/rpg-engine.sh session_start"
        }]
    }],
    "UserPromptSubmit": [{
        "hooks": [{
            "type": "command",
            "command": f"{rpg_dir}/scripts/rpg-engine.sh quest_accept"
        }]
    }],
    "Stop": [{
        "hooks": [{
            "type": "command",
            "command": f"{rpg_dir}/scripts/rpg-engine.sh quest_complete"
        }]
    }],
    "Notification": [{
        "hooks": [{
            "type": "command",
            "command": f"{rpg_dir}/scripts/rpg-engine.sh notification"
        }]
    }],
    "PostToolUse": [
        {
            "matcher": "Edit",
            "hooks": [{
                "type": "command",
                "command": f"{rpg_dir}/scripts/rpg-engine.sh code_forge"
            }]
        },
        {
            "matcher": "Write",
            "hooks": [{
                "type": "command",
                "command": f"{rpg_dir}/scripts/rpg-engine.sh artifact_create"
            }]
        },
        {
            "matcher": "Bash",
            "hooks": [{
                "type": "command",
                "command": f"{rpg_dir}/scripts/rpg-engine.sh spell_cast"
            }]
        }
    ],
    "SubagentStop": [{
        "hooks": [{
            "type": "command",
            "command": f"{rpg_dir}/scripts/rpg-engine.sh subquest"
        }]
    }]
}

# Add statusline
settings['statusLine'] = {
    "type": "command",
    "command": f"{rpg_dir}/scripts/rpg-statusline.sh"
}

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

print("✓ Installed hooks configuration")

EOFPYTHON

    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}✓ RPG Mode installed successfully!${RESET}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    echo -e "Restart Claude Code to activate your adventure!"
    echo -e "\n${YELLOW}To uninstall: $0 uninstall${RESET}\n"
}

uninstall_rpg() {
    echo -e "${CYAN}Uninstalling Claude Code RPG Mode...${RESET}\n"

    if [ ! -f "$SETTINGS_FILE" ]; then
        echo -e "${RED}Error: settings.json not found${RESET}"
        exit 1
    fi

    backup_settings

    # Remove hooks and statusline
    python3 << EOFPYTHON
import json

settings_file = "$SETTINGS_FILE"

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)
except:
    print("Error reading settings.json")
    sys.exit(1)

# Remove RPG-related keys
removed = []
if 'hooks' in settings:
    del settings['hooks']
    removed.append('hooks')
if 'statusLine' in settings:
    del settings['statusLine']
    removed.append('statusLine')

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

if removed:
    print(f"✓ Removed: {', '.join(removed)}")
else:
    print("⚠ No RPG configuration found")

EOFPYTHON

    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}✓ RPG Mode uninstalled${RESET}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    echo -e "Your progress is saved in: ${RPG_DIR}/state.json"
    echo -e "Backups are in: ${RPG_DIR}/backups/\n"
    echo -e "${YELLOW}Note: RPG files kept in ${RPG_DIR}${RESET}"
    echo -e "${YELLOW}To reinstall: $0 install${RESET}"
    echo -e "${YELLOW}To delete everything: rm -rf ${RPG_DIR}${RESET}\n"
}

check_status() {
    echo -e "${CYAN}Claude Code RPG Mode Status${RESET}\n"

    if [ ! -d "$RPG_DIR" ]; then
        echo -e "${RED}✗ Not installed${RESET}"
        echo -e "\nRun: $0 install"
        exit 0
    fi

    echo -e "${GREEN}✓ RPG directory exists: $RPG_DIR${RESET}"

    if [ -f "$RPG_DIR/state.json" ]; then
        echo -e "${GREEN}✓ State file exists${RESET}"
        echo -e "\nCurrent progress:"
        cat "$RPG_DIR/state.json" | python3 -m json.tool
    else
        echo -e "${YELLOW}⚠ State file missing${RESET}"
    fi

    if [ -f "$SETTINGS_FILE" ]; then
        if grep -q "rpg-engine.sh" "$SETTINGS_FILE" 2>/dev/null; then
            echo -e "\n${GREEN}✓ Hooks are installed${RESET}"
        else
            echo -e "\n${YELLOW}⚠ Hooks not found in settings.json${RESET}"
            echo -e "Run: $0 install"
        fi
    else
        echo -e "\n${RED}✗ settings.json not found${RESET}"
    fi

    echo ""
}

# Main
case "${1:-help}" in
    install)
        install_rpg
        ;;
    uninstall)
        uninstall_rpg
        ;;
    status)
        check_status
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${RESET}\n"
        show_usage
        exit 1
        ;;
esac
