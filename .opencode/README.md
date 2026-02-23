# .opencode Documentation Index

Quick reference for all documentation in this directory.

## Structure

```
.opencode/
├── docs/           # General documentation
│   ├── README.md
│   ├── scripts/   # Script-specific docs
│   │   └── OLLAMA_*.md
│   └── systems/   # System-related docs
│       └── *.md
│
├── time-room/      # Agent orchestration (Prismo's domain)
│   ├── README.md
│   ├── agents/    # Agent personas
│   └── docs/      # Time Room docs
│
├── plans/         # Active execution plans
│   └── PLAN_*.md
│
└── issues/       # Issue tracking
    └── *.md
```

## Quick Links

| Topic | File | Purpose |
|-------|------|---------|
| Ollama Setup | [docs/scripts/OLLAMA_OPTIMIZATION.md](docs/scripts/OLLAMA_OPTIMIZATION.md) | Main Ollama guide |
| Model Updates | [docs/scripts/OLLAMA_MIGRATION.md](docs/scripts/OLLAMA_MIGRATION.md) | Model migration notes |
| Script Changes | [docs/scripts/OLLAMA_SCRIPTS_CHANGELOG.md](docs/scripts/OLLAMA_SCRIPTS_CHANGELOG.md) | Script changelog |
| Fork Strategy | [docs/systems/FORK_INDEX.md](docs/systems/FORK_INDEX.md) | Fork overview |
| Upstream Sync | [docs/systems/UPSTREAM_SYNC.md](docs/systems/UPSTREAM_SYNC.md) | Syncing with upstream |
| Undergarden | [docs/systems/UNDERGARDEN.md](docs/systems/UNDERGARDEN.md) | Hidden dotfiles plan |
| Time Room | [time-room/README.md](time-room/README.md) | Agent system |
| Portability | [time-room/docs/PORTABILITY.md](time-room/docs/PORTABILITY.md) | Using agents elsewhere |

---

*Last updated: 2026-02-17*
