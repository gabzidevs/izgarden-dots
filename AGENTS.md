# Agent Context

This file tells AI assistants where to find relevant documentation and context for this flake.

---

## Documentation Structure

```
.opencode/
├── docs/
│   ├── scripts/          # Ollama, scripts, toolchain
│   │   ├── OLLAMA_OPTIMIZATION.md   # Main roadmap
│   │   ├── OLLAMA_SCRIPTS_CHANGELOG.md
│   │   └── OLLAMA_MIGRATION.md
│   ├── systems/          # System configs, fork decisions
│   │   ├── FORK_INDEX.md
│   │   ├── HOME_CLEANUP.md
│   │   ├── DECISIONS.md
│   │   └── UPSTREAM_SYNC.md
│   ├── COMPLETION_SUMMARY.md
│   └── EXPLORATION_PLANS.md
├── issues/               # Active issues to fix
│   └── SPACEHOUND_ISSUES.md
└── plans/               # In-flight plans
    ├── PLAN_HOME_CLEANUP.md
    ├── PLAN_UPSTREAM_SYNC.md
    └── PLAN_OLLAMA_OPERATIONS.md
```

---

## Script Structure

### Parent Scripts (3)

```
scripts/
├── oll -> oll_core/oll.sh           # Ollama operations
├── opz -> opz_core/opz.sh           # OpenCode wrapper
└── doll -> doll_core/doll.sh        # Dashboard
```

### oll - Ollama Operations

```
oll <subcommand> [options]
├── oll connect [model]     # Switch model (alias: c)
├── oll server <action>    # start, stop, restart, status, health, logs (alias: s)
├── oll model <action>     # list, pull, rm, storage, recommend (alias: m)
├── oll tune [preset]      # speed, balanced, power, research (alias: t)
├── oll profile           # show, list, set (alias: p)
├── oll doctor            # Diagnostics
└── oll status            # Quick status
```

### opz - OpenCode Wrapper

```
opz [options]
├── opz                   # Launch with auto-detected profile
├── opz -s               # Show status
├── opz -l               # List profiles
├── opz -p <profile>     # Launch with specific profile
└── opz -h               # Show help
```

### doll - Dashboard

```
doll                     # Show status dashboard
```

### Internal Structure (oll_core)

```
oll_core/
├── lib/                 # Shared libraries
│   ├── host.sh         # Machine detection (SSH-aware)
│   ├── profile.sh     # OCX profile handling
│   ├── ollama.sh     # Ollama API helpers
│   └── ui.sh         # Colors & UI helpers
└── commands/
    ├── server/        # start, stop, restart, status, health, logs
    ├── model/         # list, pull, rm, storage, recommend
    ├── connect.sh     # Model switching
    ├── tune.sh       # Performance presets
    └── profile.sh    # Profile management
```

### Legacy Scripts (deleted)

All functionality consolidated into `oll` subcommands.

---

## Key Features

- **Host-aware**: Detects machine (nebulanix/spacehound) automatically, even via SSH
- **OCX profile-aware**: Profile name matches shortcode (`nebx`, `spchound`)
- **TUI-first**: Uses gum for interactive UI if available, CLI fallback otherwise
- **Nix + CLI separation**: Nix sets immutable defaults, CLI allows runtime overrides

---

## Provisioning (just-provision) - Enhanced with Git Branch Management

```bash
# Local provision
just provision spacehound   # Provision spacehound
just provision nebulanix    # Provision nebulanix
just provision <system> --heal  # Self-heal before provision
just provision --check      # Check prerequisites

# Enhanced features
just provision -b           # Pull current branch, then provision
just provision -b gabz-v2   # Pull specific branch, then provision
just provision -b --heal    # Branch + healing + provision
just provision --heal=ai    # AI-guided healing + provision
```

**Remote provision (from local machine):**
```bash
# Enhanced just-provision now supports remote operations
just-provision -b gabz-v2 spacehound    # Pull branch, provision remote
just-provision nebulanix --heal         # Heal and provision remote

# Or use opz for AI-guided operations
opz run provision spacehound
```

**OpenCode command:** `/provision <system>` - self-healing nix-darwin provision

---

## Key Notes

- **Nebulanix** (192.168.1.10): 48GB M4 Pro - Ollama server
- **Spacehound**: 18GB M3 - Client with local fallback
- Main Ollama docs: `.opencode/docs/scripts/OLLAMA_OPTIMIZATION.md`
- Operations guide: `.opencode/plans/PLAN_OLLAMA_OPERATIONS.md`
- Active issues: `.opencode/issues/`

---

## Working Memory Skills

The working-memory plugin provides persistent memory across sessions. These skills wrap the plugin for common workflows:

```bash
# Unified launcher
.opencode/skills/memory.sh <command>

# Commands:
memory checkpoint save <name> [desc]   # Save-point before risky ops
memory threads start <id> <summary>    # Track parallel conversations
memory delegate pack <agent> <task>    # Handover to subagent
memory recover check                  # Verify after compaction
memory snapshot create <thread> <label> # Mark thread milestones
memory health                          # Quick health check
```

**Direct tool usage:**
```bash
opencode --tool core_memory_update '{"goal":"...","progress":"...","context":"..."}'
opencode --tool core_memory_read
opencode --tool working_memory_add '{"content":"...","category":"..."}'
```

**Documentation:**
- Usage guide: `enchiridion/appendices/WORKING_MEMORY_USAGE.md`
- Agent quick ref: `.opencode/docs/WORKING_MEMORY_AGENT_REF.md`
- Time Room docs: `.opencode/time-room/docs/WORKING_MEMORY_SKILLS.md`

---

## Time Room Agents

For character-based subagents (Prismo, Finn, Jake, Simon, Fern, etc.), see:
[`.opencode/time-room/agents/AGENTS.md`](.opencode/time-room/agents/AGENTS.md)

---

## just-provision Test Results (2026-02-22)

### Test Matrix Results

| Command | Status | Notes |
|---------|--------|-------|
| `just-provision --help` | ✓ Pass | Shows full usage |
| `just-provision --check` | ✓ Pass | Detects nebulanix |
| `just-provision --check --debug` | ✓ Pass | Shows detection steps |
| `just-provision --timeout 60 --check` | ✓ Pass | Parses timeout |
| `just-provision -a spacehound --check` | ✓ Pass | Flag parsed (works in provision mode) |
| `just-provision -b main --check` | ✓ Pass | Flag parsed (works in provision mode) |
| `just-provision --heal --dry-run nebulanix` | ⚠ Partial | Shows healing, but **still provisions** |
| `just-provision invalid-system` | ✓ Pass | Validates correctly with error |
| `just-provision spacehound` | ✓ Pass | Attempts SSH to spacehound |
| SSH to 192.168.1.40 | ✓ Pass | Direct SSH works |

### Known Issues

1. **--dry-run doesn't stop provision**: Using `--heal --dry-run` still executes the actual provision after showing healing steps. Should skip provision when DRY_RUN=true.

2. **--check mode limitations**: Flags like `-a`, `-b`, `-ro`, `-w` are not processed in `--check` mode - only detection runs. This is by design but could confuse users.

3. **TUI selection blocking**: The `-ro` and `-w` flags use interactive TUI (gum) which blocks in non-interactive shells. Error message "Non-interactive shell" is shown.

### Validation Checklist

- [x] Flag parsing works correctly
- [x] SSH detection works (detects nebulanix via local IP)
- [x] Parallel output uses system prefix (via mise run --output prefix)
- [x] Error messages are helpful (shows valid systems on invalid input)
- [ ] Dry-run stops before provision (BUG - doesn't stop)
- [x] TUI works when gum available

### Edge Cases

- **mDNS resolution**: Script resolves spacehound.local/nebulanix.local correctly
- **SSH timeout**: Configurable via `--timeout` flag (default 30s)
- **Branch handling**: Supports `__current__` special value for current branch
