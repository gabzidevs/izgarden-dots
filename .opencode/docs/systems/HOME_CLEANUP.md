# Plan: Home/gabz Cleanup & Reorganization

> Transforming a shallow copy of isabel's config into a focused macOS+coding setup

## Current Situation

Your `home/gabz/` is a shallow copy of `home/isabel/`, containing:
- **Active configs**: Shell, git, ghostty, chromium, lazygit, zellij, navi
- **Disabled configs**: Discord, media apps, neovim, wezterm, notes
- **Linux-only cruft**: Hyprland, Quickshell, Vicinae, GTK/QT themes, rnnoise
- **Unexplored tools**: atuin, jj

## Target State

A profile-based organization where each category can be toggled via `garden.profiles`.

## Phase 1: Archive Linux-Only Files (Immediate)

Move these to `home/gabz/.archived/`:

```
home/gabz/.archived/
├── linux-only/
│   ├── gui/
│   │   ├── hyprland.nix
│   │   ├── quickshell.nix
│   │   ├── quickshell/          (whole directory)
│   │   └── vicinae/             (whole directory)
│   ├── services/
│   │   └── rnnoise.nix
│   └── themes/
│       ├── gtk.nix              (isLinux guarded, but purely Linux)
│       └── qt.nix               (review if used on macOS)
```

**Files to move:**
- `home/gabz/gui/hyprland.nix`
- `home/gabz/gui/quickshell.nix`
- `home/gabz/gui/quickshell/` (directory)
- `home/gabz/gui/vicinae/` (directory)
- `home/gabz/services/rnnoise.nix`
- `home/gabz/themes/gtk.nix`
- `home/gabz/themes/qt.nix`

## Phase 2: Create New Profile-Based Structure

### New Directory Layout

```
home/gabz/
├── README.md                    # This file explains the structure
├── default.nix                  # Entry point
│
├── core/                        # ALWAYS ENABLED
│   ├── default.nix
│   ├── shell/                   # Fish, zsh, bash, aliases
│   ├── git.nix                  # Your git config
│   ├── packages.nix             # Core packages
│   └── system/                  # Docs, mise, secrets, SSH
│
├── dev/                         # PROFILE: coding
│   ├── default.nix              # coding.enable guard
│   ├── tools.nix                # bat, direnv, eza, fd, fzf, ripgrep, zoxide
│   ├── tui.nix                  # lazygit, navi, zellij
│   └── editors.nix              # (Empty for now, for future editors)
│
├── recreational/                # PROFILE: recreational
│   ├── default.nix              # recreational.enable guard
│   ├── gaming.nix               # modrinth, steam (casks in system config)
│   └── entertainment.nix        # Discord
│
├── media/                       # PROFILE: mediaCreation + mediaConsumption
│   ├── default.nix              # Checks both profiles
│   ├── creation.nix             # mediaCreation: obs, inkscape, gimp
│   ├── consumption.nix          # mediaConsumption: spotify, mpv, vlc
│   └── streaming.nix            # chatterino7
│
├── social/                      # PROFILE: social
│   └── default.nix              # social.enable guard
│                                 # Slack, Discord (if separate from recreational)
│
├── terminals/                   # ALWAYS ENABLED
│   ├── default.nix
│   ├── ghostty.nix
│   └── wezterm.nix              # Enabled via programs.wezterm.enable
│
├── themes/                      # ALWAYS ENABLED (mostly)
│   ├── default.nix
│   ├── catppuccin.nix
│   ├── fonts.nix
│   └── global.nix               # Remove gtk.nix, qt.nix references
│
└── .archived/                   # ARCHIVED (not imported)
    ├── linux-only/              # Linux-only configs
    └── unexplored/              # atuin.nix, jj.nix
```

## Phase 3: Profile Definitions

### Extend `modules/home/profiles.nix`

Add these profile options:

```nix
options.garden.profiles = {
  # Existing profiles (inherited from osConfig)
  graphical.enable = mkEnableOption "graphical profile";
  workstation.enable = mkEnableOption "workstation profile";
  laptop.enable = mkEnableOption "laptop profile";
  
  # New application profiles
  coding.enable = mkEnableOption "coding profile" // {
    default = config.garden.profiles.workstation.enable;
  };
  
  recreational.enable = mkEnableOption "recreational profile" // {
    default = false;
  };
  
  social.enable = mkEnableOption "social profile" // {
    default = config.garden.profiles.recreational.enable;
  };
  
  # Media profiles
  media.creation.enable = mkEnableOption "media creation profile";
  media.consumption.enable = mkEnableOption "media consumption profile";
  media.streaming.enable = mkEnableOption "media streaming profile";
};
```

## Phase 4: System-Specific Configurations

### nebulanix (Work + Personal)

```nix
# systems/nebulanix/default.nix
garden.profiles = {
  # Hardware
  laptop.enable = true;
  graphical.enable = true;
  workstation.enable = true;
  
  # Application profiles
  coding.enable = true;              # Always
  recreational.enable = true;        # Personal time
  social.enable = true;              # Slack for work
  
  # Media (both for work projects)
  media.creation.enable = true;      # OBS for recordings
  media.consumption.enable = true;   # Spotify, videos
  media.streaming.enable = false;    # No streaming on work machine
};
```

### spacehound (Gaming Focused)

```nix
# systems/spacehound/default.nix  
garden.profiles = {
  # Hardware
  laptop.enable = true;
  graphical.enable = true;
  workstation.enable = true;
  
  # Application profiles
  coding.enable = true;              # Still dev work
  recreational.enable = true;        # Heavy gaming focus
  social.enable = true;              # Discord, etc.
  
  # Media
  media.creation.enable = true;      # You said both!
  media.consumption.enable = true;   # Entertainment
  media.streaming.enable = true;     # Maybe streaming here?
};
```

## Phase 5: Per-System Homebrew Apps

Currently gaming apps are defined in `systems/*/apps.nix`. Keep this separation:

- **nebulanix/apps.nix**: Work + light personal (loom, modrinth, obs, vlc, spotify)
- **spacehound/apps.nix**: Gaming focused (modrinth, steam, bluestacks, obs, vlc)

## Phase 6: Archive Unexplored Tools

Move these to `home/gabz/.archived/unexplored/`:
- `home/gabz/cli/atuin.nix` - Shell history sync
- `home/gabz/cli/jj.nix` - Jujutsu version control

Create `docs/future/EXPLORE_LATER.md` with references to revisit.

## Implementation Order

### Session 1: Archive Linux Files
1. Create `home/gabz/.archived/linux-only/`
2. Move hyprland.nix, quickshell.nix
3. Move quickshell/ and vicinae/ directories
4. Move rnnoise.nix, gtk.nix, qt.nix
5. Remove imports from default.nix files
6. Test: `just check`

### Session 2: Create New Structure
1. Create new directories (core/, dev/, recreational/, media/, terminals/)
2. Move existing files to appropriate locations
3. Create new default.nix files with profile guards
4. Update root `home/gabz/default.nix`
5. Test: `just check && just test`

### Session 3: Update System Configs
1. Add profile settings to nebulanix/default.nix
2. Add profile settings to spacehound/default.nix
3. Test: `just switch`

### Session 4: Archive Unexplored
1. Move atuin.nix, jj.nix to .archived/unexplored/
2. Create explore later reference doc
3. Final test

## File Mapping

| Current Location | New Location | Profile | Notes |
|-----------------|--------------|---------|-------|
| `cli/shell/` | `core/shell/` | Always | Keep as-is |
| `cli/git.nix` | `core/git.nix` | Always | Keep as-is |
| `cli/bat.nix` | `dev/tools.nix` | coding | Merge with other tools |
| `cli/direnv.nix` | `dev/tools.nix` | coding | |
| `cli/eza.nix` | `dev/tools.nix` | coding | |
| `cli/fd.nix` | `dev/tools.nix` | coding | |
| `cli/fzf.nix` | `dev/tools.nix` | coding | |
| `cli/gh.nix` | `dev/tools.nix` | coding | |
| `cli/ripgrep.nix` | `dev/tools.nix` | coding | |
| `cli/starship.nix` | `core/shell/` | Always | |
| `cli/zoxide.nix` | `dev/tools.nix` | coding | |
| `cli/nix-your-shell.nix` | `core/shell/` | Always | |
| `cli/atuin.nix` | `.archived/unexplored/` | N/A | Revisit later |
| `cli/jj.nix` | `.archived/unexplored/` | N/A | Revisit later |
| `tui/lazygit.nix` | `dev/tui.nix` | coding | |
| `tui/navi.nix` | `dev/tui.nix` | coding | |
| `tui/zellij.nix` | `dev/tui.nix` | coding | |
| `tui/izrss.nix` | `dev/tui.nix` | coding | Or delete if unused |
| `tui/neovim.nix` | `.archived/` | N/A | Using mise instead |
| `gui/chromium.nix` | `terminals/` or keep | Always | It's a browser |
| `gui/ghostty.nix` | `terminals/ghostty.nix` | Always | |
| `gui/wezterm.nix` | `terminals/wezterm.nix` | Always | Controlled via programs.wezterm.enable |
| `gui/discord.nix` | `recreational/entertainment.nix` | recreational | |
| `gui/notes.nix` | Review | ? | Do you use it? |
| `gui/media/*` | `media/` | mediaCreation/mediaConsumption | Split/reorganize |
| `gui/hyprland.nix` | `.archived/linux-only/` | N/A | Linux-only |
| `gui/quickshell.nix` | `.archived/linux-only/` | N/A | Linux-only |
| `gui/quickshell/` | `.archived/linux-only/` | N/A | Linux-only |
| `gui/vicinae/` | `.archived/linux-only/` | N/A | Linux-only |
| `services/rnnoise.nix` | `.archived/linux-only/` | N/A | Linux-only |
| `services/tray.nix` | Review | ? | macOS has native tray |
| `themes/*` | `themes/` | Always | Remove gtk.nix, qt.nix |
| `system/*` | `core/system/` | Always | Keep as-is |
| `packages.nix` | `core/packages.nix` | Always | Keep as-is |

## Validation Checklist

After each phase:
- [ ] `just check` passes
- [ ] `just test` builds successfully
- [ ] `just switch` applies without error
- [ ] Core functionality works (shell, git, terminal)
- [ ] Profile-gated features toggle correctly

## Rollback Plan

Before starting:
```bash
git checkout -b gabz-v2-backup-cleanup
git checkout gabz-v2
```

If issues arise:
```bash
git checkout gabz-v2-backup-cleanup
# Or hard reset if needed
git checkout gabz-v2
git reset --hard gabz-v2-backup-cleanup
```

## Notes

- Keep `home/isabel/` untouched - it's your reference/upstream tracking
- `home/gabz/` becomes YOUR personalized config
- The `.archived/` directory is in `.gitignore` or just not imported
- All plans stored in `docs/future/` for opencode to reference

---

*Next: See EXPLORATION_PLANS.md for atuin, jj, and LazyVim ideas*

---

## Phase 7: Hybrid Profile System & Keyboard Config (Updated Design)

### Overview

This extends the profile system to support both system-level and user-level profiles, with particular attention to per-user keyboard preferences.

### Profile Hierarchy

```
System Level (config.garden.profiles.*)
├── workstation/laptop/graphical/hardware profiles (existing)
├── work.focus - Machine primarily for work
├── recreational.focus - Machine primarily for gaming/play
└── media.*.enable - Machine capabilities

User Level (home-manager.users.<name>.garden.profiles.*)
├── coding.enable - User wants dev tools
│   └── keyboard.remapCapsLock - Per-user keyboard preference
├── recreational.enable - User wants gaming/entertainment
├── social.enable - User wants communication apps
└── media.*.enable - User wants media apps
```

### Decision Log

**Keyboard Remapping (Phase 3E):**
- **Primary mapping**: Caps Lock → Escape (vim-style)
- **Implementation**: nix-darwin system setting (simple, built-in)
- **Per-user**: Yes, based on `coding.keyboard.remapCapsLock` setting
- **Default**: "none" (no remapping unless explicitly enabled)
- **Future**: Karabiner module prepped for complex mappings (escape on tap, hyper on hold)

**Hybrid Profile System:**
- **System profiles**: Define machine's primary purpose (work.focus vs recreational.focus)
- **User profiles**: Define individual preferences (coding, recreational, social)
- **Homebrew**: Checks BOTH system and user profiles
  - System-level casks: Work apps if work.focus, base apps always
  - User-level casks: Gaming if any user has recreational.enable

### Implementation Details

**1. Extend modules/generic/profiles.nix:**
```nix
options.garden.profiles = {
  # Existing profiles remain
  
  # New: Machine "personality"
  work.focus = mkEnableOption "work-focused machine";
  recreational.focus = mkEnableOption "recreational-focused machine";
  
  # Media profiles already exist, keeping them
};
```

**2. Extend modules/home/profiles.nix:**
```nix
options.garden.profiles = {
  # Existing: media.* profiles
  
  # New: User application profiles
  coding = {
    enable = mkEnableOption "coding profile";
    keyboard.remapCapsLock = mkOption {
      type = types.enum [ "none" "escape" "control" ];
      default = "none";
      description = "Caps lock remapping preference";
    };
  };
  
  recreational.enable = mkEnableOption "recreational profile";
  social.enable = mkEnableOption "social profile";
};
```

**3. Update modules/darwin/hardware/keyboard.nix:**
```nix
{ config, lib, ... }:
let
  mainUser = config.garden.system.mainUser;
  userCfg = config.home-manager.users.${mainUser};
  remapStyle = userCfg.garden.profiles.coding.keyboard.remapCapsLock or "none";
in
{
  config = lib.mkMerge [
    (lib.mkIf (remapStyle == "escape") {
      system.keyboard.remapCapsLockToEscape = true;
    })
    (lib.mkIf (remapStyle == "control") {
      system.keyboard.remapCapsLockToControl = true;
    })
  ];
}
```

**4. Prepare home/gabz/core/karabiner.nix (Future):**
```nix
# Placeholder for future Karabiner configuration
# Will enable complex mappings: escape on tap, hyper on hold
# For now, use simple nix-darwin mapping above
{ config, lib, ... }: {
  # Future: Install karabiner-elements and configure
  # homebrew.casks = lib.optionals (complexMappingNeeded) [ "karabiner-elements" ];
}
```

**5. Update modules/darwin/brew/default.nix:**
```nix
# Hybrid logic for cask installation
homebrew.casks = lib.mkMerge [
  # Base casks (always)
  [ "raycast" "arc" "ghostty" ]
  
  # System-level: Work-focused machine
  (lib.optionals config.garden.profiles.work.focus [
    "slack" "zoom" "1password"
  ])
  
  # User-level: Any user wants recreational
  (lib.optionals (anyUser "recreational.enable") [
    "steam" "modrinth" "bluestacks"
  ])
  
  # User-level: Media creation
  (lib.optionals (anyUser "media.creation.enable") [
    "obs"
  ])
];
```

### Multi-User Considerations

**Current Users:**
- gabz (mainUser): Full access to all profiles
- rodz: Can have different profile preferences
- grcee: Can have different profile preferences (spacehound only)

**Profile Inheritance:**
- Each user gets their own `home-manager.users.<name>.garden.profiles`
- Default for new users: all profiles disabled (opt-in)
- Main user (gabz) has full configuration

**Example Configuration:**
```nix
# systems/nebulanix/users.nix
{
  home-manager.users.gabz.garden.profiles = {
    coding = {
      enable = true;
      keyboard.remapCapsLock = "escape";
    };
    recreational.enable = true;
    social.enable = true;
    media.creation.enable = true;
    media.consumption.enable = true;
  };
  
  home-manager.users.rodz.garden.profiles = {
    coding.enable = false;
    recreational.enable = true;
    social.enable = true;
  };
}
```

### Raycast Hyper Key Note

Raycast has a built-in "Hyper Key" feature that can map Caps Lock to hyper (Cmd+Opt+Ctrl+Shift). However:
- **Conflict**: Cannot use with nix-darwin remapping or Karabiner simultaneously
- **Limitation**: Only provides hyper, not "escape on tap, hyper on hold"
- **Decision**: Stick with nix-darwin for now (escape only)
- **Future**: If hyper key needed, either:
  1. Use Raycast's hyper key (disable nix-darwin mapping)
  2. Upgrade to Karabiner (escape on tap, hyper on hold)

### Migration Path to Karabiner

When ready for complex mappings:

1. Create `home/gabz/core/karabiner.nix` with full configuration
2. Import in `home/gabz/core/default.nix`
3. Disable nix-darwin keyboard remapping
4. Add karabiner-elements to homebrew casks
5. Configure per-user via home-manager

### Validation

After Phase 3 implementation:
- [ ] `just check` passes
- [ ] Caps lock remaps to escape for gabz on nebulanix
- [ ] Caps lock stays normal for rodz
- [ ] Homebrew installs appropriate casks based on profiles
- [ ] Switching users changes keyboard behavior
- [ ] Media apps install based on profile settings

