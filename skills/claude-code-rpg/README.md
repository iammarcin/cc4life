# Claude Code RPG Mode 🎮⚔️

Turn your coding sessions into an epic adventure! Gain XP, level up, and track your progress as you code.

## What is this?

Claude Code RPG Mode adds a gamification layer to your Claude Code sessions. Every interaction earns XP:

- **Quest Accept** (+2 XP) - Submit a prompt
- **Code Forge** (+5 XP) - Edit files
- **Spell Cast** (+3 XP) - Run bash commands
- **Artifact Create** (+6 XP) - Write new files
- **Quest Complete** (+10 XP) - Finish a task
- **Subquest** (+7 XP) - Complete a subagent task

## Features

- 🎯 **Level System** - Progress from Apprentice to The Eternal (12 levels)
- 📊 **Status Line** - Real-time XP and level display
- 🎨 **Visual Feedback** - Colorful notifications for each action
- 💾 **Progress Tracking** - Session count and streak tracking
- 🔄 **Easy Install/Uninstall** - One command to add or remove

## Installation

```bash
cd ~/.claude-rpg
chmod +x install.sh
./install.sh install
```

Then restart Claude Code.

## Uninstallation

```bash
cd ~/.claude-rpg
./install.sh uninstall
```

Your progress is saved in `state.json` and can be restored by reinstalling.

## Check Status

```bash
cd ~/.claude-rpg
./install.sh status
```

Shows your current level, XP, and installation state.

## How It Works

The system uses Claude Code's hook system:
- **SessionStart** - Welcome message with current level
- **UserPromptSubmit** - XP on each prompt
- **PostToolUse** - XP for Edit, Write, Bash commands
- **Stop** - Quest complete bonus
- **SubagentStop** - Subquest bonus

## Files

```
~/.claude-rpg/
├── scripts/
│   ├── rpg-engine.sh      # Main XP and leveling logic
│   └── rpg-statusline.sh  # Status bar display
├── state.json             # Your progress (XP, level, sessions)
├── backups/               # Settings backups
├── sounds/                # Optional sound effects
└── install.sh             # This installer
```

## Configuration

Edit `scripts/rpg-engine.sh` to customize:
- XP rewards per action
- Level thresholds
- Title names
- Colors and visual style

## Why Would I Want This?

**You probably won't.** This is a fun experiment, but let's be honest:
- The novelty wears off quickly
- It adds visual noise to your terminal
- You'll get bored of the XP notifications

That's totally fine! This is why we made uninstall easy. Try it, have some fun, and remove it when you're done.

## Troubleshooting

**Not seeing XP notifications?**
- Make sure you ran `./install.sh install`
- Restart Claude Code
- Check status: `./install.sh status`

**Want to reset progress?**
```bash
rm ~/.claude-rpg/state.json
```

**Want to completely remove everything?**
```bash
./install.sh uninstall
rm -rf ~/.claude-rpg
```

## Credits

Created for [cc4.life](https://cc4.life) - A collection of Claude Code experiments and tools.

Part of the BetterAI toolkit for making AI assistants more fun and productive.

## License

MIT - Use it, modify it, forget about it. Whatever you want.

---

**Remember:** This is a toy. It's meant to be installed, enjoyed briefly, and probably uninstalled. That's the lifecycle of most gamification experiments, and that's okay! 🎮
