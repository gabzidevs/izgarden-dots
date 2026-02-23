# Fork Modifications Map

> Comprehensive map of gabz's dotfiles fork from [isabelroses/dotfiles](https://github.com/isabelroses/dotfiles)

**Last Updated:** 2026-02-17  
**Current Branch:** gabz-v2  
**Primary Hosts:** nebulanix (MBP M4), spacehound (MBP M3)

---

## Summary

This fork transforms Isabel's Nix/NixOS-focused dotfiles into a **macOS-centric development environment** optimized for AI-powered coding workflows. The main differences:

1. **macOS-First Focus** - Dropped Linux-specific tools (Hyprland, Quickshell, PipeWire)
2. **AI/LLM Stack** - Complete Ollama management system for local LLM inference
3. **Multi-Machine Setup** - Server (nebulanix) + Client (spacehound) architecture
4. **Documentation Heavy** - Comprehensive Enchiridion handbook and agent personas
5. **Simplified Home Structure** - Profile-based organization replacing Isabel's modular approach

---

## Custom Additions

### Systems

| System | Type | Purpose | Custom Features |
|--------|------|---------|-----------------|
| **nebulanix** | darwin (aarch64) | Primary workstation (MBP M4 48GB) | Ollama server, work.focus profile |
| **spacehound** | darwin (aarch64) | Secondary workstation (MBP M3 18GB) | Ollama client, recreational.focus, local fallback models |

**Isabel's Systems (Preserved/Not Used):**
- amaterasu, aphrodite, athena, hephaestus, isis (NixOS)
- lilith (ISO builder)
- minerva (NixOS)
- skadi (ARM64 NixOS)
- tatsumaki (darwin ARM64)
- valkyrie (WSL)

#### System Configuration Details

**nebulanix/default.nix:**
```nix
garden = {
  profiles = {
    laptop.enable = true;
    graphical.enable = true;
    workstation.enable = true;
    work.focus = true;
    recreational.focus = false;
  };
};
```

**spacehound/default.nix:**
```nix
garden = {
  profiles = {
    laptop.enable = true;
    graphical.enable = true;
    workstation.enable = true;
    work.focus = false;
    recreational.focus = true;
  };
};
```

---

### Scripts

**Complete Ollama Management Suite** (scripts/):

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `ollamactl` | Server control | start/stop/restart/status/list/health/logs, auto-loads optimizations |
| `ollama-optimize` | Performance tuner | Presets (speed/balanced/power/research), per-model configs |
| `ollama-model` | Model manager | Interactive browser, pull/rm/purge, storage tracking, recommendations |
| `ollama-sysopt` | System optimizations | VRAM override (45GB), service cleanup, thermal monitoring (smctemp) |
| `connect-ollama --check` | Connection tester | Host resolution, connectivity check, config snippet generation |
| `connect-ollama` | Model switcher | Interactive selection, updates opencode.json, fallback to local |
| `crush-setup` | Crush AI config | Server URL, model selection, LSP integration |
| `test-opencode-ollama` | Integration test | Validates Ollama + OpenCode connection |

**Utility Scripts:**

| Script | Purpose |
|--------|---------|
| `decrypt-sops-secrets.sh` | Decrypt SOPS secrets |
| `nix-daemon-workaround.sh` | Switch to upstream Nix daemon for large builds |
| `toggle-capslock.sh` | Toggle caps lock state |

---

### Documentation

#### The Enchiridion (enchiridion/)

A comprehensive 6-part handbook for AI-powered development workflows, styled after Adventure Time:

| Part | Title | Contents |
|------|-------|----------|
| 1 | AI Fundamentals | What is an AI agent, LLM basics |
| 2 | OpenCode Deep Dive | Tool architecture, MCP ecosystem |
| 3 | Agentic Workflows | Exploration, planning, delegation patterns |
| 4 | Prompt Engineering | Crafting effective prompts |
| 5 | Practical Integrations | Ollama setup, model selection |
| 6 | Ecosystem | MCP servers, CLI tools, local-first alternatives |

**Key Files:**
- `README.md` - Philosophy and quick start
- `BORROWERS_LOG.md` - Chapter assignments to agents

#### OpenCode Docs (.opencode/docs/)

| Document | Purpose |
|----------|---------|
| `OLLAMA_OPTIMIZATION.md` | Complete Ollama system roadmap (1127 lines!) |
| `OLLAMA_SCRIPTS_CHANGELOG.md` | Script version history |
| `OLLAMA_MIGRATION.md` | Migration guides |
| `FORK_INDEX.md` | Repository map and branch structure |
| `HOME_CLEANUP.md` | Reorganization plan |
| `DECISIONS.md` | Architectural decisions log |
| `UPSTREAM_SYNC.md` | Sync workflow with upstream |
| `KEYBOARD_TOGGLE.md` | Keyboard customization |

#### Time Room (.opencode/time-room/)

Agent personas based on Adventure Time characters for documentation:

| Agent | Persona | Domain |
|-------|---------|--------|
| Prismo | The Wish Master | Orchestrator |
| Marceline | Vampire Queen | Part 1: Fundamentals |
| Jake | Stretchy Dog | Part 2: Tools |
| Bubblegum | Princess | Part 3: Workflows |
| Huntress | Huntress Wizard | Part 4: Prompt Engineering |
| Simon | Ice King | Nix/NixOS |
| BMO | Game Console | Appendices |
| Fern | The Fork | Dotfiles |
| Finn | The Hero | Git operations |
| Shelby | The Worm | Verification |

---

### Agent System

**Location:** `.opencode/time-room/`

Created a complete agent persona system for AI-assisted documentation:
- Each Adventure Time character represents a writing style
- Agents mapped to documentation domains
- Prismo orchestrates between agents
- Enables "summoning" specific agents for tasks

**Example Usage:**
```
"I need help with git" → Finn appears!
"I have a nix question" → Simon appears!
"Help with dotfiles" → Fern appears!
```

---

### Home Configuration Structure

**New Profile-Based Organization** (home/gabz/):

```
home/gabz/
├── default.nix          # Entry point
├── core/                # ALWAYS ENABLED
│   ├── shell/           # Fish, zsh configs
│   ├── git.nix          # Git configuration
│   ├── packages.nix     # Core packages
│   ├── starship.nix     # Shell prompt
│   ├── chromium.nix      # Browser
│   └── system/          # Mise, SSH, secrets
├── dev/                 # CODING PROFILE
│   ├── bat.nix
│   ├── direnv.nix
│   ├── eza.nix
│   ├── fd.nix
│   ├── fzf.nix
│   ├── gh.nix
│   ├── lazygit.nix
│   ├── navi.nix
│   ├── ripgrep.nix
│   ├── zellij.nix
│   └── zoxide.nix
├── media/               # MEDIA PROFILES
│   ├── creation.nix
│   ├── listening.nix
│   └── watching.nix
├── recreational/        # RECREATIONAL PROFILE
│   └── discord.nix
├── terminals/           # TERMINALS
│   ├── ghostty.nix
│   └── wezterm.nix
└── themes/             # THEMING
    ├── catppuccin.nix
    ├── fonts.nix
    └── global.nix
```

**Archived (Not Imported):** `.archived/` - Linux-only and unexplored tools

---

## Maintained from Isabel

### Core Infrastructure (Unchanged)

| Component | Source | Usage |
|-----------|--------|-------|
| flake.nix | isabelroses/dotfiles | Entry point, inputs |
| flake-parts | hercules-ci/flake-parts | Flake structure |
| modules/base/ | isabelroses/dotfiles | Users, system, nix config |
| modules/darwin/ | isabelroses/nix-darwin | macOS support |
| home-manager | nix-community/home-manager | User environment |
| sops-nix | Mic92/sops-nix | Secrets management |
| catppuccin | catppuccin/nix | Theming |
| easy-hosts | tgirlcloud/easy-hosts | Host management |

### Preserved Modules

- All base modules (users, system, nix)
- Darwin modules (brew, hardware, preferences, security)
- Generic modules (profiles)
- Most isabel's CLI tools adapted for gabz

### Unchanged Files

- `.editorconfig`
- `.envrc`
- `.gitattributes`
- `.gitignore`
- `flake.lock`
- `stylua.toml`
- `LICENSE` (MIT)
- `.github/` workflows

---

## Fork Philosophy

### What's Different from Isabel

| Aspect | Isabel | This Fork |
|--------|--------|-----------|
| **Primary OS** | NixOS + Linux | macOS only |
| **System Count** | 10+ systems | 2 systems (nebulanix, spacehound) |
| **AI Stack** | None | Complete Ollama system |
| **Documentation** | Basic | Enchiridion + Agent personas |
| **Home Structure** | Modular (cli/gui/tui) | Profile-based (core/dev/media) |
| **Windows** | WSL, NixOS VMs | None |
| **Remote** | None | Server-client (Ollama) |

### Architecture Decision: Profile-Based Home

Isabel uses a modular structure (cli/, gui/, tui/, services/, system/, themes/) that includes Linux-specific tools. This fork:

1. **Archives Linux-only** to `.archived/linux-only/`
2. **Enables by default** only what's needed for macOS
3. **Uses profiles** to enable/disable categories (dev, media, recreational)

### Architecture Decision: Ollama Server

```
┌─────────────────────┐     HTTP      ┌─────────────────────┐
│   NEBULANIX         │◄──────────────►│   SPACEHOUND        │
│   48GB RAM (M4)     │                │   18GB RAM (M3)    │
├─────────────────────┤                ├─────────────────────┤
│  Ollama Server      │                │  OpenCode Client    │
│  - qwen3:8b         │                │  - Remote: nebulanix│
│  - qwen3-coder:30b │                │  - Local: llama3.2  │
│  - deepseek-r1:8b   │                │  Crush Client       │
│  - gemma3:4b        │                │  - Fallback         │
└─────────────────────┘                └─────────────────────┘
```

---

## Future Opportunities

### High Priority

| Opportunity | Description | Current State |
|------------|-------------|---------------|
| **Provision Script Fixes** | Fix sudo/mise issues in justfile | Issue documented in SPACEHOUND_ISSUES.md |
| **Profile Implementation** | Complete profile-based brew module | Phase 3 in progress |
| **Thermal Auto-Adjust** | Reduce context when temps >90C | Planned in OLLAMA_OPTIMIZATION.md |

### Medium Priority

| Opportunity | Description | Current State |
|------------|-------------|---------------|
| **Auto-Routing** | Auto-select model based on task analysis | Roadmap in OLLAMA_OPTIMIZATION.md |
| **Karabiner Integration** | Complex key remapping (hyper key) | Decision documented, ready when needed |
| **Model Sets** | Save/load model combinations | Planned for ollama-model |

### Lower Priority

| Opportunity | Description | Current State |
|------------|-------------|---------------|
| **Atuin** | Shell history sync across machines | Archived, low priority |
| **Jujutsu (jj)** | Git alternative VCS | Archived, learn git first |
| **Neovim** | Full vim config via izvim | Disabled, using mise |

### Manual Tasks That Could Be Automated

| Task | Current | Potential |
|------|---------|-----------|
| Model switching | connect-ollama (manual) | Auto based on task |
| Ollama health | ollamactl health (manual) | Auto-restart on crash |
| Storage cleanup | ollama-model purge (manual) | Cron job for old models |
| Thermal monitoring | ollama-sysopt --thermal (manual) | Background daemon |

### Not Nix-Managed That Could Be

| Component | Current | Potential |
|-----------|---------|-----------|
| Ollama models | Scripts | Nix package overlay |
| VRAM override | ollama-sysopt | Homebrew service |
| Caps lock | System prefs | Nix-darwin (done) |

### What's Working Well

1. **Ollama Scripts** - Complete, well-documented toolkit
2. **Profile Structure** - Clean separation of concerns
3. **Documentation** - Enchiridion is comprehensive
4. **Agent System** - Creative persona approach
5. **Provision Workflow** - Just commands for rebuild

### Areas Needing Improvement

1. **Spacehound Provision** - sudo password and mise issues
2. **Multi-User** - Not fully implemented (rodz, grcee)
3. **Upstream Sync** - Workflow documented but not regularly used
4. **Archive Cleanup** - Still some dead code in home/gabz/

---

## Branch Structure

```
origin/gabz-v2     ← Current development (HEAD)
origin/main         ← Stable
origin/gabz         ← Previous iteration (archived)
upstream/main       ← Isabel's latest
```

---

## Dependencies Overview

| Input | Status | Notes |
|-------|--------|-------|
| nixpkgs | Active | Unstable channel |
| darwin | Active | isabelroses fork |
| home-manager | Active | Latest |
| flake-parts | Active | Structure |
| easy-hosts | Active | Host management |
| sops | Active | Secrets |
| homebrew | Active | Brew integration |
| catppuccin | Active | Theming |
| izlix | Optional | Lix fork |
| izvim | Disabled | Neovim config |
| tgirlpkgs | Referenced | Custom packages |
| nixos-wsl | Not needed | Linux only |
| lanzaboote | Not needed | Linux only |
| simple-nixos-mailserver | Not needed | Linux only |

---

## Quick Commands

```bash
# Rebuild
just switch                    # Local
just deploy <host>             # Remote
just provision <host>          # New macOS

# Ollama
ollamactl start                # Start server
ollama-optimize --preset balanced
ollama-model pull qwen3:8b
connect-ollama                # Switch models

# Development
opencode                       # Use AI assistant
crush                          # Alternative AI

# Update
just update                    # Update flake inputs
git push origin gabz-v2        # Push changes
```

---

*Document maintained in: `.opencode/docs/systems/FORK_MODIFICATIONS.md`*
