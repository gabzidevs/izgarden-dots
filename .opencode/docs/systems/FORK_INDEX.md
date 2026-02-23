# Fork Index & Repository Map

> Your fork of [isabelroses/dotfiles](https://github.com/isabelroses/dotfiles)  
> Maintained for: **macOS Development Workstations** (nebulanix & spacehound)

---

## 1. Repository Structure Index

### 1.1 Root Level Organization

```
flake/
├── flake.nix              # Entry point - uses flake-parts
├── flake.lock             # Locked dependency versions
├── justfile               # Task runner (rebuild, update, deploy, etc.)
├── README.md              # Simple redirect to upstream
├── shell.nix              # Dev shell entry
├── .sops.yaml             # Secrets management config
├──
├── systems/               # SYSTEM CONFIGURATIONS (per-host)
│   ├── default.nix        # easy-hosts configuration defining all hosts
│   ├── nebulanix/         # MBP M4 (current system - primary)
│   └── spacehound/        # Montz MBP-M3 (secondary)
│   └── [other hosts...]   # Isabel's systems (not your concern)
│
├── home/                  # USER HOME CONFIGURATIONS
│   ├── gabz/              # Your user configuration (shallow copy of isabel/)
│   └── isabel/            # Isabel's original config (reference)
│
├── modules/               # MODULE LIBRARY
│   ├── flake/             # Flake-level modules (checks, packages, lib)
│   ├── base/              # Shared base configuration
│   ├── darwin/            # macOS-specific modules
│   ├── nixos/             # NixOS-specific modules
│   ├── wsl/               # WSL-specific modules
│   ├── home/              # Home-manager modules
│   └── generic/           # Cross-platform utilities
│
├── scripts/               # Helper scripts
├── secrets/               # Encrypted secrets (sops)
└── docs/                  # Documentation
    ├── plans/             # THIS DIRECTORY - Your planning documents
    │   ├── FORK_INDEX.md
    │   ├── HOME_CLEANUP.md
    │   ├── UPSTREAM_SYNC.md
    │   └── EXPLORATION_PLANS.md
    └── ...
```

### 1.2 Your Active Systems (Owned)

| Hostname | Class | Arch | Purpose | Location |
|----------|-------|------|---------|----------|
| **nebulanix** | darwin | aarch64 | Primary workstation (MBP M4) | systems/nebulanix/ |
| **spacehound** | darwin | aarch64 | Secondary (Montz MBP-M3) | systems/spacehound/ |

### 1.3 Profiles System

Your systems use these profiles (defined in modules/home/profiles.nix):

- `workstation.enable` - Development tools, git, editors
- `graphical.enable` - GUI applications and theming
- `laptop.enable` - Laptop-specific settings

**Planned new profiles** (see HOME_CLEANUP.md):
- `coding.enable` - Dev tools (TUI, CLI)
- `recreational.enable` - Gaming, entertainment
- `social.enable` - Communication apps
- `media.creation.enable` - Content creation
- `media.consumption.enable` - Media playback
- `media.streaming.enable` - Streaming tools

### 1.4 Home Configuration Structure (home/gabz/)

**CURRENT STATE** (pre-cleanup):
```
home/gabz/               # Shallow copy of isabel/
├── default.nix          # Entry point
├── packages.nix         # Package selections
├── cli/                 # Command line tools
│   ├── shell/           # Fish, zsh, bash
│   ├── git.nix          # Your git config
│   ├── [active tools]   # bat, direnv, eza, etc.
│   └── [disabled]       # atuin.nix, jj.nix
├── gui/                 # GUI apps
│   ├── [active]         # chromium.nix, ghostty.nix
│   ├── [disabled]       # discord.nix, notes.nix, wezterm.nix
│   ├── [Linux-only]     # hyprland.nix, quickshell.nix
│   ├── quickshell/      # Linux-only (archive)
│   ├── vicinae/         # Linux-only (archive)
│   └── media/           # Currently not imported
├── tui/                 # TUI apps
│   ├── [active]         # lazygit.nix, navi.nix, zellij.nix
│   └── [disabled]       # izrss.nix, neovim.nix
├── services/            # User services
│   └── [Linux-only]     # rnnoise.nix
├── system/              # System config
│   ├── docs.nix
│   ├── mise.nix         # Version manager
│   ├── secrets.nix
│   └── ssh.nix
└── themes/              # Theming
    ├── catppuccin.nix
    ├── fonts.nix
    ├── global.nix
    └── [Linux-only]     # gtk.nix, qt.nix
```

**TARGET STATE** (post-cleanup):
```
home/gabz/
├── core/                # ALWAYS ENABLED
│   ├── shell/
│   ├── git.nix
│   ├── packages.nix
│   └── system/
├── dev/                 # PROFILE: coding
├── recreational/        # PROFILE: recreational
├── media/               # PROFILES: mediaCreation/mediaConsumption
├── terminals/           # Ghostty, WezTerm
├── themes/              # Catppuccin, fonts
└── .archived/           # Linux-only, unexplored tools
    ├── linux-only/
    └── unexplored/
```

### 1.5 Module Architecture

```
modules/
├── flake/                 # Flake composition
│   ├── default.nix        # Aggregates all flake modules
│   ├── args.nix           # Common arguments
│   ├── checks/            # Flake checks
│   ├── lib/               # Custom library functions
│   ├── packages/          # Custom package definitions
│   └── programs/          # Dev shell programs
│
├── base/                  # Shared across all system classes
│   ├── default.nix        # Imports: generic, home, nix/, nixpkgs.nix, programs.nix, system/, users/
│   ├── nix/               # Nix configuration
│   ├── system/            # System settings
│   └── users/             # User management
│
├── darwin/               # macOS-specific (your primary target)
│   ├── default.nix        # Imports: base, brew/, config-path, docs, extras, hardware/, legacy, nix, preferences/, security/, system-packages
│   ├── brew/              # Homebrew integration
│   ├── hardware/          # Keyboard, trackpad settings
│   ├── preferences/       # macOS system preferences
│   └── security/          # macOS security settings
│
├── nixos/                # NixOS-specific (ISABEL'S - can ignore)
│
├── wsl/                  # WSL-specific (ISABEL'S - can ignore)
│
└── home/                 # Home-manager modules
    ├── default.nix        # Imports: generic, docs, environment/, extras, home.nix, profiles.nix, programs/, secrets.nix, themes/
    ├── profiles.nix       # Profile definitions
    ├── programs/          # Program option definitions
    └── themes/            # Home theming
```

---

## 2. Upstream Relationship

### 2.1 Current Remotes

- origin: git@github.com:gabzidevs/izgarden-dots.git (Your fork)
- upstream: git@github.com:isabelroses/dotfiles.git (Original repo)

### 2.2 Current Branch Structure

| Branch | Purpose | Base |
|--------|---------|------|
| `main` | Your stable branch (origin) | - |
| `gabz-v2` | CURRENT ACTIVE BRANCH | Your development |
| `gabz` | Previous iteration | Archived |
| `v2` | Version 2 work | - |
| `upstream/main` | Isabel's latest | Reference |

### 2.3 Merge Base

Your current work (`gabz-v2`) diverged from upstream at commit: `fbe0fe0e4f4296dcb9fd44fa7b3f9c8509b0f466`

---

## 3. Dependencies (flake.nix inputs)

| Input | Purpose | Your Status |
|-------|---------|-------------|
| nixpkgs | Package source | Active |
| darwin | macOS support (isabelroses fork) | Critical |
| home-manager | User environment | Active |
| flake-parts | Flake structure | Active |
| easy-hosts | Host management | Active |
| sops | Secret management | Active |
| homebrew | Brew integration | Active |
| catppuccin | Theming | Active |
| izvim | Neovim config | Currently disabled |
| tgirlpkgs | Custom packages | Referenced |
| nixos-wsl | WSL support | Not needed |
| lanzaboote | Secure boot | Not needed |
| simple-nixos-mailserver | Mail server | Not needed |
| spicetify | Spotify theming | Not needed |
| hostling | Host management | Not needed |
| izlix | Lix fork | Optional |

---

## 4. Key Files for Your Context

### System Configs (Your Systems)
- `systems/nebulanix/default.nix` - Primary MBP M4
- `systems/nebulanix/users.nix` - User assignment (gabz)
- `systems/nebulanix/apps.nix` - Homebrew apps
- `systems/spacehound/default.nix` - Secondary MBP M3
- `systems/spacehound/users.nix` - User assignment
- `systems/spacehound/apps.nix` - Homebrew apps

### Home Configs (Your User)
- `home/gabz/default.nix` - Entry point
- `home/gabz/packages.nix` - Your packages
- `home/gabz/cli/git.nix` - Git config with your aliases
- `home/gabz/cli/shell/fish.nix` & `zsh.nix` - Shell configs
- `home/gabz/gui/ghostty.nix` - Terminal (primary)
- `home/gabz/themes/` - Your theming

### Build Commands (from justfile)
```bash
just switch           # Apply system configuration
just test             # Test configuration without applying
just update [input]   # Update flake inputs
just provision <host> # Provision new macOS host
```

---

## 5. Planning Documents

All plans stored in `docs/future/` (or `~/.local/share/opencode/plans/` during development):

| Document | Purpose | Status |
|----------|---------|--------|
| **FORK_INDEX.md** | This file - repository map | Current |
| **HOME_CLEANUP.md** | Reorganizing home/gabz/ | Ready to implement |
| **UPSTREAM_SYNC.md** | Workflow for syncing with isabelroses/dotfiles | Ready to use |
| **EXPLORATION_PLANS.md** | Tools to explore later (atuin, jj, LazyVim) | Reference |

---

## 6. Next Steps

See individual plan documents:
- **HOME_CLEANUP.md** - Start with Linux file archival
- **UPSTREAM_SYNC.md** - Use when syncing with upstream
- **EXPLORATION_PLANS.md** - Reference when ready to experiment

---

*Generated: 2026-02-16*  
*Current Host: nebulanix*  
*Active Branch: gabz-v2*
