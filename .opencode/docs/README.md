# Development Plans for izgarden-dots

> Planning documents for maintaining and improving your Nix flake

## Quick Reference

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **FORK_INDEX.md** | Complete map of your fork structure | Starting any work |
| **HOME_CLEANUP.md** | Reorganizing home/gabz/ for macOS focus | When cleaning up configs |
| **UPSTREAM_SYNC.md** | Syncing with isabelroses/dotfiles | When pulling upstream updates |
| **EXPLORATION_PLANS.md** | Tools to explore later (atuin, jj, LazyVim) | When ready to experiment |

## Current Status

- **Branch**: `gabz-v2`
- **Current Host**: nebulanix (MBP M4)
- **Systems Owned**: nebulanix, spacehound
- **Primary Focus**: macOS + coding workflow

## Immediate Priorities

1. **Archive Linux-only files** from home/gabz/ (hyprland, quickshell, vicinae, rnnoise)
2. **Reorganize** into profile-based structure (core/, dev/, recreational/, media/)
3. **Implement new profiles** (coding, recreational, media.creation, media.consumption)
4. **Archive unexplored tools** (atuin, jj) for later

## File Locations

All plans are stored in:
```
.opencode/
├── docs/future/
│   ├── README.md              (this file)
│   ├── FORK_INDEX.md          (repo map)
│   ├── HOME_CLEANUP.md        (cleanup strategy)
│   ├── UPSTREAM_SYNC.md       (sync workflow)
│   └── EXPLORATION_PLANS.md   (future explorations)
│
├── time-room/                  # Prismo's Time Room (agent orchestration)
│   ├── README.md              # Time Room welcome
│   └── agents/
│       ├── AGENTS.md          # Agent index
│       ├── prismo.md          # Wish master orchestrator
│       ├── marceline.md       # Part 1: Fundamentals
│       ├── finn-shelby.md     # Recurring voices
│       └── [more agents coming]
│
└── plans/                      # Active execution plans
    └── [plan files]
```

## The Enchiridion & Agent System

This flake includes **The Enchiridion** - an AI agent handbook with Adventure Time themes:

```
scripts/enchiridion/
├── README.md                              # Book landing page
├── PROJECT_IDEAS.md                      # Tracking our progress
├── part1-ai-fundamentals/                # AI fundamentals
├── part2-opencode-deep-dive/              # OpenCode deep dive
├── part4-prompt-engineering/             # Prompt engineering
└── part5-practical-integrations/          # Model selection, etc.
```

### Using the Agents (Prismo's Time Room)

When working on documentation or writing tasks, invoke the appropriate agent:

- **@prismo** - Plan orchestration, "What do you wish for?"
- **@marceline** - Write foundational content ("Everything stays")
- **@finn** - Adventure notes throughout chapters
- **@shelby** - End-of-chapter verification ("Check please!")

See `.opencode/time-room/agents/AGENTS.md` for full agent list.

---

## Notes for AI Assistants

When working on this flake:

1. **Check FORK_INDEX.md first** - Understand the structure
2. **Refer to HOME_CLEANUP.md** - For any home/gabz/ changes
3. **Use UPSTREAM_SYNC.md** - When syncing with upstream
4. **Check EXPLORATION_PLANS.md** - Before suggesting new tools

### Key Constraints

- **Only modify**: `home/gabz/`, `systems/nebulanix/`, `systems/spacehound/`, `docs/future/`
- **Do not modify**: `home/isabel/`, `modules/nixos/`, `modules/wsl/`, other systems
- **Always test**: Run `just check` after nix changes
- **Deploy with**: `just switch` (macOS) or `just test` first

### Profile System

New profiles being implemented:
- `coding` - Dev tools (zellij, lazygit, navi, CLI tools)
- `recreational` - Gaming (modrinth, steam, bluestacks)
- `social` - Communication (Discord)
- `media.creation` - Content creation (OBS, inkscape, gimp)
- `media.consumption` - Entertainment (Spotify, mpv, vlc)
- `media.streaming` - Streaming (chatterino7)

These complement existing profiles:
- `workstation` - Base development environment
- `graphical` - GUI applications enabled
- `laptop` - Laptop-specific settings

---

*Last updated: 2026-02-16*  
*Maintained alongside the main flake*
