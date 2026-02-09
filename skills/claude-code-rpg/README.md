# ⚔️ Claude Code RPG Mode

**Turn your coding sessions into an adventure.** Every prompt is a quest. Every edit forges code. Every task completed earns XP. Level up as you work.

Built on [Claude Code hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) — inspired by [@delba_oliveira's viral game sounds idea](https://x.com/delba_oliveira/status/2020515023412744477).

---

## What It Looks Like

**Quest complete:**
```
  ⚔️  Legendary work, adventurer!  +25 XP
  ─────────────────────────────────
  🧙 Wizard (Lvl 5)  823/1200 XP
  [████████████████░░░░░░] 69%
```

**Level up:**
```
  ╔══════════════════════════════════════╗
  ║        ⚡ LEVEL UP! ⚡              ║
  ║                                      ║
  ║     You are now a                    ║
  ║     ⚔️  CODE WARRIOR               ║
  ║                                      ║
  ║  "The bugs flee before you."         ║
  ╚══════════════════════════════════════╝
```

**Achievement unlocked:**
```
  🏆 ACHIEVEMENT UNLOCKED: First Blood
```

**Full stats (`rpg-engine.sh stats`):**
```
  ╔═══════════════════════════════════════════╗
  ║     ⚔️  ADVENTURER'S JOURNAL  ⚔️         ║
  ╠═══════════════════════════════════════════╣
  ║                                           ║
  ║   🧙 Wizard       Level 5                ║
  ║   XP: 823 / 1200                         ║
  ║   [████████████████░░░░░░░░░] 69%        ║
  ║                                           ║
  ║   Quests Completed:  47                   ║
  ║   Code Forged:       123 edits            ║
  ║   Spells Cast:       89 commands          ║
  ║   Artifacts Created: 12 files             ║
  ║   Sessions:          15                   ║
  ║   Streak:            5 days               ║
  ║                                           ║
  ║   🏆 Achievements:                        ║
  ║     • First Blood                         ║
  ║     • Code Forger                         ║
  ║     • Night Owl                           ║
  ╚═══════════════════════════════════════════╝
```

---

## Install (30 seconds)

```bash
git clone https://github.com/iammarcin/cc4life.git
cd cc4life/skills/claude-code-rpg
bash install.sh
```

That's it. Open Claude Code and start questing.

### Enable the Status Line (recommended)

Want to see your level and XP **permanently at the bottom** of Claude Code? Run:

```bash
bash install.sh --statusline
```

This adds an RPG status bar that updates in real-time:
```
⚔️ Code Warrior Lvl 3 | 423/600 XP [███░░] | claude-opus-4-6
```

---

## How It Works

Claude Code [hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) trigger shell commands on events. RPG Mode maps these events to an RPG system:

| Claude Code Event | RPG Event | XP |
|---|---|---|
| `SessionStart` | New adventure begins | — |
| `UserPromptSubmit` | Quest accepted | +5 |
| `Stop` | Quest complete! | +25 |
| `PostToolUse` → Edit | Code forged | +10 |
| `PostToolUse` → Write | Artifact created | +12 |
| `PostToolUse` → Bash | Spell cast | +8 |
| `PostToolUse` → Read/Grep | Scouting | +3 |
| `SubagentStop` | Subquest done | +15 |
| `Notification` | NPC alert | — |

### Levels

| Lvl | Title | XP Required |
|---|---|---|
| 1 | 📜 Apprentice | 0 |
| 2 | 🗡️ Journeyman | 100 |
| 3 | ⚔️ Code Warrior | 300 |
| 4 | 🛡️ Bug Slayer | 600 |
| 5 | 🧙 Wizard | 1,000 |
| 6 | 🔮 Archmage | 1,500 |
| 7 | 👑 Legend | 2,200 |
| 8 | 🌟 Mythic | 3,000 |
| 9 | ✨ Transcendent | 4,000 |
| 10 | 🌌 Digital Deity | 5,500 |

### Achievements

Unlock achievements as you code:

- **First Blood** — Complete your first quest
- **Adventurer** — 10 quests completed
- **Code Forger** — 10 edits
- **Master Smith** — 100 edits
- **Night Owl** — Code between midnight and 6 AM
- **Early Bird** — Code before 7 AM
- **Hat Trick** — 3-day coding streak
- **Week Warrior** — 7-day coding streak
- **Marathon Runner** — 50 quests in one day
- **Code Warrior** — Reach level 3
- **Wizard's Path** — Reach level 5
- **Digital Deity** — Reach level 10
- ...and more

---

## Add Sounds (Optional)

The visual experience works out of the box. Want audio? Drop `.wav` or `.mp3` files into `~/.claude-rpg/sounds/`:

```
~/.claude-rpg/sounds/
├── session_start.wav     # "A new quest begins"
├── quest_accept.wav      # Sword unsheathe
├── quest_complete.wav    # Victory fanfare
├── code_forge.wav        # Anvil strike
├── spell_cast.wav        # Magic whoosh
├── notification.wav      # Alert chime
├── level_up.wav          # Level up fanfare
└── achievement.wav       # Achievement sound
```

Free RPG sounds: [OpenGameArt](https://opengameart.org/art-search?keys=rpg+sound) | [Freesound](https://freesound.org/search/?q=rpg+8bit)

On Mac, level-ups automatically play the system Hero sound as a fallback.

---

## Commands

```bash
# View your full character sheet
~/.claude-rpg/scripts/rpg-engine.sh stats

# Reset your character (start fresh)
~/.claude-rpg/scripts/rpg-engine.sh reset
```

---

## Customization

### Change XP rewards

Edit `~/.claude-rpg/scripts/rpg-engine.sh` — the XP values are at the top:

```bash
XP_QUEST_ACCEPT=5      # UserPromptSubmit
XP_CODE_FORGE=10       # Edit
XP_SPELL_CAST=8        # Bash
XP_ARTIFACT_CREATE=12  # Write
XP_SCOUT=3             # Read/Grep/Glob
XP_QUEST_COMPLETE=25   # Stop
```

### Change level titles

Want different class names? Edit the `TITLES` array in the script. Make it yours.

### Add your own achievements

The achievement system is simple — just add new `check_achievement` calls to any event handler.

---

## How It's Built

- Pure bash — no dependencies beyond `python3` (for JSON state management)
- State stored in `~/.claude-rpg/state.json`
- Cross-platform: macOS + Linux
- Hooks config in `.claude/settings.json`

### What the installer touches

| File | Action |
|---|---|
| `~/.claude/settings.json` | Adds hooks config (backed up automatically before any changes) |
| `~/.claude-rpg/` | Created new — RPG engine, state, sounds, backups |

No other files are modified. The installer **always creates a timestamped backup** of your settings before making changes. Backups are stored in `~/.claude-rpg/backups/`.

---

## Uninstall

```bash
# Option 1: Restore your original settings from backup
cp ~/.claude-rpg/backups/settings.json.*.bak ~/.claude/settings.json

# Option 2: Just remove the hooks (keep other settings)
python3 -c "
import json
with open('$HOME/.claude/settings.json') as f:
    s = json.load(f)
s.pop('hooks', None)
with open('$HOME/.claude/settings.json', 'w') as f:
    json.dump(s, f, indent=2)
"

# Remove RPG data
rm -rf ~/.claude-rpg
```

---

## Credits

- Inspired by [@delba_oliveira](https://x.com/delba_oliveira/status/2020515023412744477) and the Claude Code hooks community
- Built by [@waiting4agi](https://x.com/waiting4agi)
- Part of [cc4life](https://github.com/iammarcin/cc4life)

---

**Now go quest, adventurer.** ⚔️
