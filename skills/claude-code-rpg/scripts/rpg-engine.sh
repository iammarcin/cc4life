#!/usr/bin/env bash
# Claude Code RPG Mode - Turn your coding sessions into an adventure
# https://github.com/iammarcin/cc4life

set -euo pipefail

# ═══════════════════════════════════════════════
#  CONFIG
# ═══════════════════════════════════════════════

RPG_DIR="${CLAUDE_RPG_DIR:-$HOME/.claude-rpg}"
STATE_FILE="$RPG_DIR/state.json"
SOUNDS_DIR="$RPG_DIR/sounds"
LOG_FILE="$RPG_DIR/adventure.log"
EVENT_FILE="$RPG_DIR/.last_event"

# XP rewards per event
XP_QUEST_ACCEPT=2      # UserPromptSubmit
XP_CODE_FORGE=5        # Edit
XP_SPELL_CAST=3        # Bash
XP_ARTIFACT_CREATE=6   # Write
XP_SCOUT=1             # Read/Grep/Glob
XP_QUEST_COMPLETE=10   # Stop
XP_SUBQUEST=7          # SubagentStop

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GOLD='\033[38;5;220m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ═══════════════════════════════════════════════
#  LEVEL SYSTEM
# ═══════════════════════════════════════════════

LEVELS=(0 500 1500 4000 8000 15000 25000 40000 60000 85000 120000 170000)
TITLES=(
    "Apprentice"
    "Journeyman"
    "Code Warrior"
    "Bug Slayer"
    "Wizard"
    "Archmage"
    "Legend"
    "Mythic"
    "Transcendent"
    "Digital Deity"
    "Omniscient"
    "The Eternal"
)
LEVEL_EMOJIS=(
    "📜"
    "🗡️"
    "⚔️"
    "🛡️"
    "🧙"
    "🔮"
    "👑"
    "🌟"
    "✨"
    "🌌"
    "💫"
    "♾️"
)

# Flavor text for quest acceptance
QUEST_FLAVORS=(
    "A new challenge approaches..."
    "The quest board updates..."
    "Adventure awaits!"
    "Your blade thirsts for code..."
    "The compiler gods demand tribute..."
    "A bug stirs in the darkness..."
    "The code beckons..."
    "Ready your keyboard, warrior..."
    "The repository trembles..."
    "A pull request is forming..."
)

# Flavor text for quest completion
COMPLETE_FLAVORS=(
    "Victory is yours!"
    "The quest is complete!"
    "Another bug vanquished!"
    "The code submits to your will!"
    "Legendary work, adventurer!"
    "The repository grows stronger!"
    "A worthy conquest!"
    "The compiler smiles upon you!"
    "Flawless execution!"
    "The tests bow before you!"
)

# Flavor text for level-up subtitles
LEVELUP_QUOTES=(
    "The journey of a thousand commits begins with a single line."
    "Your code-fu grows stronger."
    "The bugs flee before you."
    "You have mastered the ancient art of debugging."
    "Reality bends to your refactoring."
    "The codebase recognizes its master."
    "Legends speak of your merge commits."
    "The stars align in your git log."
    "You transcend mere programming."
    "You have achieved digital enlightenment."
)

# ═══════════════════════════════════════════════
#  STATE MANAGEMENT
# ═══════════════════════════════════════════════

init_state() {
    mkdir -p "$RPG_DIR"
    if [[ ! -f "$STATE_FILE" ]]; then
        cat > "$STATE_FILE" << 'INITSTATE'
{
    "xp": 0,
    "level": 1,
    "title": "Apprentice",
    "quests_completed": 0,
    "edits": 0,
    "commands": 0,
    "files_written": 0,
    "files_read": 0,
    "sessions": 0,
    "streak_days": 0,
    "last_session": "",
    "today_quests": 0,
    "today_date": "",
    "achievements": [],
    "created": ""
}
INITSTATE
        # Set creation date
        local now
        now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        update_field "created" "$now"
    fi
}

get_field() {
    local field="$1"
    python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
print(data.get('$field', ''))
" 2>/dev/null || echo ""
}

get_int_field() {
    local field="$1"
    local val
    val=$(get_field "$field")
    echo "${val:-0}"
}

get_array_field() {
    local field="$1"
    python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
arr = data.get('$field', [])
for item in arr:
    print(item)
" 2>/dev/null
}

update_field() {
    local field="$1"
    local value="$2"
    python3 -c "
import json
with open('$STATE_FILE', 'r') as f:
    data = json.load(f)
try:
    data['$field'] = json.loads('$value')
except (json.JSONDecodeError, ValueError):
    data['$field'] = '$value'
with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=4)
" 2>/dev/null
}

add_achievement() {
    local achievement="$1"
    python3 -c "
import json
with open('$STATE_FILE', 'r') as f:
    data = json.load(f)
if '$achievement' not in data.get('achievements', []):
    data.setdefault('achievements', []).append('$achievement')
    with open('$STATE_FILE', 'w') as f:
        json.dump(data, f, indent=4)
    print('NEW')
else:
    print('EXISTS')
" 2>/dev/null
}

# ═══════════════════════════════════════════════
#  DISPLAY FUNCTIONS
# ═══════════════════════════════════════════════

progress_bar() {
    local current=$1
    local max=$2
    local width=${3:-20}
    local filled=$(( current * width / max ))
    local empty=$(( width - filled ))

    printf "${GREEN}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${DIM}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${RESET}"
}

show_status() {
    local xp=$1
    local level=$2
    local title=$3
    local xp_gained=${4:-0}
    local event_text=${5:-""}

    local emoji="${LEVEL_EMOJIS[$((level-1))]}"
    local next_level_xp=999999
    local current_level_xp="${LEVELS[$((level-1))]}"

    if [[ $level -lt ${#LEVELS[@]} ]]; then
        next_level_xp="${LEVELS[$level]}"
    fi

    local xp_in_level=$(( xp - current_level_xp ))
    local xp_needed=$(( next_level_xp - current_level_xp ))
    local pct=0
    if [[ $xp_needed -gt 0 ]]; then
        pct=$(( xp_in_level * 100 / xp_needed ))
    fi

    echo ""
    if [[ -n "$event_text" ]]; then
        if [[ $xp_gained -gt 0 ]]; then
            printf "  ${GOLD}${event_text}${RESET}  ${GREEN}+${xp_gained} XP${RESET}\n"
        else
            printf "  ${CYAN}${event_text}${RESET}\n"
        fi
    fi
    printf "  ${DIM}─────────────────────────────────${RESET}\n"
    printf "  ${emoji} ${BOLD}${title}${RESET} ${DIM}(Lvl ${level})${RESET}  ${WHITE}${xp}${RESET}${DIM}/${next_level_xp} XP${RESET}\n"
    printf "  [$(progress_bar $xp_in_level $xp_needed 22)] ${DIM}${pct}%%${RESET}\n"
    echo ""
}

show_level_up() {
    local level=$1
    local title=$2
    local emoji="${LEVEL_EMOJIS[$((level-1))]}"
    local quote="${LEVELUP_QUOTES[$((level-1))]}"

    echo ""
    printf "  ${GOLD}╔══════════════════════════════════════╗${RESET}\n"
    printf "  ${GOLD}║${RESET}        ${YELLOW}⚡ LEVEL UP! ⚡${RESET}              ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}                                      ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}     You are now a                    ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}     ${emoji}  ${BOLD}${WHITE}%-20s${RESET}      ${GOLD}║${RESET}\n" "$title"
    printf "  ${GOLD}║${RESET}                                      ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}  ${DIM}${CYAN}%-36s${RESET}  ${GOLD}║${RESET}\n" "$quote"
    printf "  ${GOLD}╚══════════════════════════════════════╝${RESET}\n"
    echo ""
}

show_achievement() {
    local name="$1"
    echo ""
    printf "  ${MAGENTA}🏆 ACHIEVEMENT UNLOCKED: ${BOLD}${name}${RESET}\n"
    echo ""
}

show_session_start() {
    local level=$1
    local title=$2
    local sessions=$3
    local streak=$4
    local emoji="${LEVEL_EMOJIS[$((level-1))]}"

    echo ""
    printf "  ${CYAN}╔══════════════════════════════════════╗${RESET}\n"
    printf "  ${CYAN}║${RESET}   ${BOLD}${WHITE}⚔️  A New Adventure Begins  ⚔️${RESET}      ${CYAN}║${RESET}\n"
    printf "  ${CYAN}║${RESET}                                      ${CYAN}║${RESET}\n"
    printf "  ${CYAN}║${RESET}   ${emoji} ${title}  ${DIM}(Lvl ${level})${RESET}%-$((20 - ${#title}))s${CYAN}║${RESET}\n" ""
    printf "  ${CYAN}║${RESET}   ${DIM}Sessions: ${sessions}  |  Streak: ${streak}d${RESET}%-$((14 - ${#sessions} - ${#streak}))s${CYAN}║${RESET}\n" ""
    printf "  ${CYAN}╚══════════════════════════════════════╝${RESET}\n"
    echo ""
}

# ═══════════════════════════════════════════════
#  STATUS LINE EVENT NOTIFICATIONS
# ═══════════════════════════════════════════════

# Write a transient event for the status line to pick up
notify_statusline() {
    local event_type="$1"  # level_up, achievement, quest_complete, session_start
    local message="$2"
    # Format: read_count|type|message (starts at 0, status line increments)
    echo "0|${event_type}|${message}" > "$EVENT_FILE"
}

# ═══════════════════════════════════════════════
#  SOUND SYSTEM
# ═══════════════════════════════════════════════

play_sound() {
    local sound_name="$1"
    local sound_file="$SOUNDS_DIR/${sound_name}.wav"
    local mp3_file="$SOUNDS_DIR/${sound_name}.mp3"

    # Try WAV first, then MP3
    local file_to_play=""
    if [[ -f "$sound_file" ]]; then
        file_to_play="$sound_file"
    elif [[ -f "$mp3_file" ]]; then
        file_to_play="$mp3_file"
    fi

    if [[ -n "$file_to_play" ]]; then
        if command -v afplay &>/dev/null; then
            afplay "$file_to_play" &
        elif command -v paplay &>/dev/null; then
            paplay "$file_to_play" &
        elif command -v aplay &>/dev/null; then
            aplay -q "$file_to_play" &
        fi
    elif command -v afplay &>/dev/null && [[ "$sound_name" == "level_up" ]]; then
        # Mac fallback: play system sound for level-ups
        afplay /System/Library/Sounds/Hero.aiff &>/dev/null &
    fi
}

# ═══════════════════════════════════════════════
#  XP & LEVEL LOGIC
# ═══════════════════════════════════════════════

calculate_level() {
    local xp=$1
    local level=1
    for ((i=1; i<${#LEVELS[@]}; i++)); do
        if [[ $xp -ge ${LEVELS[$i]} ]]; then
            level=$((i + 1))
        else
            break
        fi
    done
    echo $level
}

award_xp() {
    local amount=$1
    local event_text="$2"
    local sound_name="${3:-}"

    local xp
    xp=$(get_int_field "xp")
    local old_level
    old_level=$(get_int_field "level")

    local new_xp=$((xp + amount))
    local new_level
    new_level=$(calculate_level $new_xp)
    local new_title="${TITLES[$((new_level-1))]}"

    update_field "xp" "$new_xp"
    update_field "level" "$new_level"
    update_field "title" "$new_title"

    # Play sound
    if [[ -n "$sound_name" ]]; then
        play_sound "$sound_name"
    fi

    # Show status
    show_status "$new_xp" "$new_level" "$new_title" "$amount" "$event_text"

    # Level up?
    if [[ $new_level -gt $old_level ]]; then
        play_sound "level_up"
        show_level_up "$new_level" "$new_title"
        notify_statusline "level_up" "LEVEL UP! ${new_title} Lvl ${new_level}"

        # Achievement for reaching specific levels
        case $new_level in
            3) check_achievement "Code Warrior" "Reached level 3" ;;
            5) check_achievement "Wizard's Path" "Reached level 5" ;;
            7) check_achievement "Legendary" "Reached level 7" ;;
            10) check_achievement "Digital Deity" "Reached level 10" ;;
        esac
    fi
}

# ═══════════════════════════════════════════════
#  ACHIEVEMENTS
# ═══════════════════════════════════════════════

check_achievement() {
    local name="$1"
    local _description="$2"  # reserved for future use

    local result
    result=$(add_achievement "$name")
    if [[ "$result" == "NEW" ]]; then
        play_sound "achievement"
        show_achievement "$name"
        notify_statusline "achievement" "UNLOCKED: ${name}"
    fi
}

check_quest_achievements() {
    local quests=$1
    case $quests in
        1) check_achievement "First Blood" "Completed your first quest" ;;
        10) check_achievement "Adventurer" "Completed 10 quests" ;;
        50) check_achievement "Veteran" "Completed 50 quests" ;;
        100) check_achievement "Centurion" "Completed 100 quests" ;;
        500) check_achievement "Quest Machine" "Completed 500 quests" ;;
    esac
}

check_edit_achievements() {
    local edits=$1
    case $edits in
        10) check_achievement "Code Forger" "Made 10 edits" ;;
        100) check_achievement "Master Smith" "Made 100 edits" ;;
        500) check_achievement "Refactoring God" "Made 500 edits" ;;
    esac
}

check_time_achievements() {
    local hour
    hour=$(date +%H)
    if [[ $hour -ge 0 && $hour -lt 6 ]]; then
        check_achievement "Night Owl" "Coded between midnight and 6 AM"
    elif [[ $hour -ge 5 && $hour -lt 7 ]]; then
        check_achievement "Early Bird" "Coded before 7 AM"
    fi
}

check_daily_achievements() {
    local today_quests=$1
    case $today_quests in
        25) check_achievement "Daily Grind" "25 quests in one day" ;;
        50) check_achievement "Marathon Runner" "50 quests in one day" ;;
        100) check_achievement "Unstoppable" "100 quests in one day" ;;
    esac
}

check_streak_achievements() {
    local streak=$1
    case $streak in
        3) check_achievement "Hat Trick" "3-day coding streak" ;;
        7) check_achievement "Week Warrior" "7-day coding streak" ;;
        30) check_achievement "Monthly Master" "30-day coding streak" ;;
    esac
}

# ═══════════════════════════════════════════════
#  STREAK TRACKING
# ═══════════════════════════════════════════════

update_streak() {
    local today
    today=$(date +%Y-%m-%d)
    local last_session
    last_session=$(get_field "last_session")
    local streak
    streak=$(get_int_field "streak_days")

    if [[ "$last_session" == "$today" ]]; then
        return  # Already counted today
    fi

    local yesterday
    if date --version &>/dev/null 2>&1; then
        yesterday=$(date -d "yesterday" +%Y-%m-%d)
    else
        yesterday=$(date -v-1d +%Y-%m-%d)
    fi

    if [[ "$last_session" == "$yesterday" ]]; then
        streak=$((streak + 1))
    elif [[ -z "$last_session" ]]; then
        streak=1
    else
        streak=1  # Streak broken
    fi

    update_field "streak_days" "$streak"
    update_field "last_session" "$today"

    # Reset daily counter if new day
    local today_date
    today_date=$(get_field "today_date")
    if [[ "$today_date" != "$today" ]]; then
        update_field "today_quests" "0"
        update_field "today_date" "$today"
    fi

    check_streak_achievements "$streak"
}

# ═══════════════════════════════════════════════
#  EVENT HANDLERS
# ═══════════════════════════════════════════════

handle_session_start() {
    init_state
    update_streak

    local sessions
    sessions=$(get_int_field "sessions")
    sessions=$((sessions + 1))
    update_field "sessions" "$sessions"

    local level
    level=$(get_int_field "level")
    local title
    title=$(get_field "title")
    local streak
    streak=$(get_int_field "streak_days")

    play_sound "session_start"
    show_session_start "$level" "$title" "$sessions" "$streak"
    notify_statusline "session_start" "New adventure! ${title} Lvl ${level} | Streak ${streak}d"
    check_time_achievements
}

handle_quest_accept() {
    init_state
    local flavor="${QUEST_FLAVORS[$((RANDOM % ${#QUEST_FLAVORS[@]}))]}"
    award_xp $XP_QUEST_ACCEPT "$flavor" "quest_accept"
}

handle_quest_complete() {
    init_state
    local quests
    quests=$(get_int_field "quests_completed")
    quests=$((quests + 1))
    update_field "quests_completed" "$quests"

    local today_quests
    today_quests=$(get_int_field "today_quests")
    today_quests=$((today_quests + 1))
    update_field "today_quests" "$today_quests"

    local flavor="${COMPLETE_FLAVORS[$((RANDOM % ${#COMPLETE_FLAVORS[@]}))]}"
    award_xp $XP_QUEST_COMPLETE "$flavor" "quest_complete"
    notify_statusline "quest_complete" "+${XP_QUEST_COMPLETE} XP | ${flavor}"

    check_quest_achievements "$quests"
    check_daily_achievements "$today_quests"
}

handle_code_forge() {
    init_state
    local edits
    edits=$(get_int_field "edits")
    edits=$((edits + 1))
    update_field "edits" "$edits"
    award_xp $XP_CODE_FORGE "Code forged!" "code_forge"
    check_edit_achievements "$edits"
}

handle_spell_cast() {
    init_state
    local commands
    commands=$(get_int_field "commands")
    commands=$((commands + 1))
    update_field "commands" "$commands"
    award_xp $XP_SPELL_CAST "Spell cast!" "spell_cast"
}

handle_artifact_create() {
    init_state
    local files
    files=$(get_int_field "files_written")
    files=$((files + 1))
    update_field "files_written" "$files"
    award_xp $XP_ARTIFACT_CREATE "Artifact created!" "artifact_create"
}

handle_scout() {
    init_state
    local reads
    reads=$(get_int_field "files_read")
    reads=$((reads + 1))
    update_field "files_read" "$reads"
    award_xp $XP_SCOUT "Scouting the codebase..." "scout"
}

handle_subquest() {
    init_state
    award_xp $XP_SUBQUEST "Subquest complete!" "quest_complete"
}

handle_notification() {
    init_state
    local level
    level=$(get_int_field "level")
    local emoji="${LEVEL_EMOJIS[$((level-1))]}"
    echo ""
    printf "  ${YELLOW}🔔 An NPC requires your attention...${RESET}\n"
    echo ""
    play_sound "notification"
}

handle_stats() {
    init_state
    local xp level title quests edits commands files_written sessions streak
    xp=$(get_int_field "xp")
    level=$(get_int_field "level")
    title=$(get_field "title")
    quests=$(get_int_field "quests_completed")
    edits=$(get_int_field "edits")
    commands=$(get_int_field "commands")
    files_written=$(get_int_field "files_written")
    sessions=$(get_int_field "sessions")
    streak=$(get_int_field "streak_days")
    local emoji="${LEVEL_EMOJIS[$((level-1))]}"

    local next_level_xp=999999
    local current_level_xp="${LEVELS[$((level-1))]}"
    if [[ $level -lt ${#LEVELS[@]} ]]; then
        next_level_xp="${LEVELS[$level]}"
    fi
    local xp_in_level=$(( xp - current_level_xp ))
    local xp_needed=$(( next_level_xp - current_level_xp ))
    local pct=0
    if [[ $xp_needed -gt 0 ]]; then
        pct=$(( xp_in_level * 100 / xp_needed ))
    fi

    echo ""
    printf "  ${GOLD}╔═══════════════════════════════════════════╗${RESET}\n"
    printf "  ${GOLD}║${RESET}     ${BOLD}${WHITE}⚔️  ADVENTURER'S JOURNAL  ⚔️${RESET}           ${GOLD}║${RESET}\n"
    printf "  ${GOLD}╠═══════════════════════════════════════════╣${RESET}\n"
    printf "  ${GOLD}║${RESET}                                           ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}   ${emoji} ${BOLD}%-12s${RESET} ${DIM}Level ${level}${RESET}%-$((17 - ${#level}))s${GOLD}║${RESET}\n" "$title" ""
    printf "  ${GOLD}║${RESET}   XP: ${WHITE}${xp}${RESET} / ${next_level_xp}%-$((27 - ${#xp} - ${#next_level_xp}))s${GOLD}║${RESET}\n" ""
    printf "  ${GOLD}║${RESET}   [$(progress_bar $xp_in_level $xp_needed 25)] ${DIM}${pct}%%${RESET}%-$((5 - ${#pct}))s${GOLD}║${RESET}\n" ""
    printf "  ${GOLD}║${RESET}                                           ${GOLD}║${RESET}\n"
    printf "  ${GOLD}║${RESET}   ${CYAN}Quests Completed:${RESET}  %-21s${GOLD}║${RESET}\n" "$quests"
    printf "  ${GOLD}║${RESET}   ${CYAN}Code Forged:${RESET}       %-21s${GOLD}║${RESET}\n" "${edits} edits"
    printf "  ${GOLD}║${RESET}   ${CYAN}Spells Cast:${RESET}       %-21s${GOLD}║${RESET}\n" "${commands} commands"
    printf "  ${GOLD}║${RESET}   ${CYAN}Artifacts Created:${RESET} %-21s${GOLD}║${RESET}\n" "${files_written} files"
    printf "  ${GOLD}║${RESET}   ${CYAN}Sessions:${RESET}          %-21s${GOLD}║${RESET}\n" "$sessions"
    printf "  ${GOLD}║${RESET}   ${CYAN}Streak:${RESET}            %-21s${GOLD}║${RESET}\n" "${streak} days"
    printf "  ${GOLD}║${RESET}                                           ${GOLD}║${RESET}\n"

    # Show achievements
    local achievements
    achievements=$(get_array_field "achievements")
    if [[ -n "$achievements" ]]; then
        printf "  ${GOLD}║${RESET}   ${MAGENTA}🏆 Achievements:${RESET}                        ${GOLD}║${RESET}\n"
        while IFS= read -r ach; do
            printf "  ${GOLD}║${RESET}     ${DIM}•${RESET} %-35s${GOLD}║${RESET}\n" "$ach"
        done <<< "$achievements"
    else
        printf "  ${GOLD}║${RESET}   ${DIM}No achievements yet. Keep questing!${RESET}     ${GOLD}║${RESET}\n"
    fi

    printf "  ${GOLD}║${RESET}                                           ${GOLD}║${RESET}\n"
    printf "  ${GOLD}╚═══════════════════════════════════════════╝${RESET}\n"
    echo ""
}

handle_reset() {
    if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
        echo ""
        printf "  ${RED}💀 Character deleted. A new adventure awaits...${RESET}\n"
        echo ""
    fi
    init_state
}

# ═══════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════

main() {
    local event="${1:-help}"

    case "$event" in
        session_start)   handle_session_start ;;
        quest_accept)    handle_quest_accept ;;
        quest_complete)  handle_quest_complete ;;
        code_forge)      handle_code_forge ;;
        spell_cast)      handle_spell_cast ;;
        artifact_create) handle_artifact_create ;;
        scout)           handle_scout ;;
        subquest)        handle_subquest ;;
        notification)    handle_notification ;;
        stats)           handle_stats ;;
        reset)           handle_reset ;;
        *)
            echo ""
            echo "  Claude Code RPG Mode"
            echo "  Usage: rpg-engine.sh <event>"
            echo ""
            echo "  Events:"
            echo "    session_start   - New session began"
            echo "    quest_accept    - Prompt submitted"
            echo "    quest_complete  - Task finished"
            echo "    code_forge      - File edited"
            echo "    spell_cast      - Command executed"
            echo "    artifact_create - File created"
            echo "    scout           - File read/searched"
            echo "    subquest        - Subagent finished"
            echo "    notification    - Needs attention"
            echo "    stats           - Show full stats"
            echo "    reset           - Reset character"
            echo ""
            ;;
    esac
}

main "$@"
