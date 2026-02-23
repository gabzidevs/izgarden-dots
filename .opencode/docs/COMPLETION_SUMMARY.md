# Home/gabz Cleanup - COMPLETE ✅

> Full reorganization and profile system implementation

## Summary

Successfully transformed a shallow copy of isabel's config into a focused, profile-based macOS+coding setup with persistent keyboard toggling.

## Timeline

**Started:** 2026-02-16  
**Completed:** 2026-02-16  
**Total Commits:** 17 granular commits  
**Systems Updated:** nebulanix, spacehound

## Phase 1: Archive Linux-Only Files ✅

**Archived to `home/gabz/.archived/linux-only/`:**
- `gui/hyprland.nix` - Wayland window manager
- `gui/quickshell.nix` + `quickshell/` - Wayland status bar
- `gui/vicinae/` - Wayland launcher
- `services/rnnoise.nix` - PipeWire noise suppression
- `themes/gtk.nix` - GTK theming
- `themes/qt.nix` - Qt theming

**Status:** Removed from imports, build unaffected

## Phase 2: Create Profile-Based Structure ✅

**New Directory Layout:**
```
home/gabz/
├── core/              # Always enabled
│   ├── chromium.nix
│   ├── git.nix
│   ├── nix-your-shell.nix
│   ├── packages.nix
│   ├── shell/         # Fish, zsh, bash configs
│   ├── starship.nix
│   └── system/        # Docs, mise, secrets, SSH
├── dev/               # coding profile
│   ├── bat.nix, direnv.nix, eza.nix, fd.nix, fzf.nix
│   ├── gh.nix, ripgrep.nix, zoxide.nix
│   └── izrss.nix, lazygit.nix, navi.nix, zellij.nix
├── recreational/      # recreational profile
│   └── discord.nix
├── media/             # media profiles
│   ├── creation.nix
│   ├── listening.nix
│   ├── streaming.nix
│   └── watching.nix
├── terminals/         # Always enabled
│   ├── ghostty.nix
│   ├── wezterm.nix
│   └── wezterm/       # Lua configs
├── themes/            # Always enabled
│   ├── catppuccin.nix
│   ├── fonts.nix
│   └── global.nix
└── .archived/
    ├── linux-only/    # (see Phase 1)
    └── unexplored/    # atuin.nix, jj.nix, neovim.nix, notes.nix
```

**Removed:** `cli/`, `tui/`, `gui/` directories

## Phase 3: Implement Hybrid Profile System ✅

### System-Level Profiles (Machine Personality)

**nebulanix** (Work-focused):
```nix
work.focus = true
recreational.focus = false
```

**spacehound** (Gaming-focused):
```nix
work.focus = false
recreational.focus = true
```

### User-Level Profiles (Individual Preferences)

**gabz on both systems:**
```nix
coding = {
  enable = true;
  keyboard.remapCapsLock = "escape";  # Vim-style
}
recreational.enable = true
social.enable = true
media = {
  creation.enable = true
  consumption.enable = true
  streaming.enable = true  # spacehound only
}
```

### Profile Inheritance

**System profiles** → Define infrastructure (work apps, hardware)  
**User profiles** → Define personal apps (coding tools, games, media)

## Phase 4: Keyboard Toggle Mechanism ✅

### Implementation

**Script:** `scripts/toggle-capslock.sh`
- Two-state toggle: escape ↔ capslock
- Persists to `~/.local/share/izgarden/capslock-state`
- Native macOS notifications (Tahoe compatible)
- Raycast/VIA integration ready

**Module:** `modules/darwin/hardware/keyboard.nix`
- Reads state file during build
- Falls back to profile setting
- Maintains preference across rebuilds

### Current Configuration

**Default:** Escape (vim mode) for gabz  
**Toggle:** Available via Raycast or script  
**Persistence:** State survives nix rebuilds  

### Usage

```bash
# Toggle via terminal
./scripts/toggle-capslock.sh

# Or setup Raycast quicklink
# Or bind to VIA macro key (future)
```

## Documentation Created

**`docs/future/`:**
- `README.md` - Index of all plans
- `FORK_INDEX.md` - Repository structure map
- `HOME_CLEANUP.md` - Cleanup strategy + implementation
- `UPSTREAM_SYNC.md` - Upstream sync workflow
- `EXPLORATION_PLANS.md` - Future tool explorations
- `DECISIONS.md` - Architectural decision log
- `KEYBOARD_TOGGLE.md` - Toggle mechanism guide

## Testing Status

✅ **Build:** All configurations build successfully  
✅ **Deploy:** `just switch` completes without errors  
✅ **Toggle:** Script works, state persists, notifications show  
✅ **Profiles:** Hybrid system correctly configures both systems  
✅ **Multi-user:** Designed for gabz, rodz, grcee (mainUser toggle only)

## Git Statistics

```
17 commits total
├─ 5 commits: Phase 1 (Linux file archival)
├─ 3 commits: Phase 2 (Structure reorganization)
├─ 4 commits: Phase 3 (Profile system)
├─ 2 commits: Phase 4 (Keyboard toggle)
└─ 3 commits: Documentation

Files changed: 60+
Lines added: ~2,000
Lines removed: ~500
```

## Current State

**Active Systems:**
- **nebulanix:** Work-focused, coding + recreational profiles, caps → escape
- **spacehound:** Gaming-focused, full profiles, streaming enabled

**Features Active:**
- Profile-based organization
- Per-user keyboard remapping with toggle
- Persistent state across rebuilds
- Ready for multi-user (rodz, grcee)

## Phase 5: Homebrew Conditional ✅

### Implementation

**Profile-based app installation in `modules/darwin/brew/default.nix`:**
- Work apps installed when: `work.focus = true` (system) OR `work.enable = true` (user)
- Gaming apps installed when: `recreational.focus = true` (system) OR `recreational.enable = true` (user)
- Media apps installed when: `media.streaming.enable = true` (user)

**App categorization:**

| Category | Apps | Condition |
|----------|------|-----------|
| Work | gather, slack, tuple, loom, linear-linear, mongodb-compass, warp, 1password, beekeeper-studio | `work.focus` or `work.enable` |
| Gaming | steam, bluestacks, transmission, modrinth | `recreational.focus` or `recreational.enable` |
| Media | vlc | `media.streaming.enable` |
| Universal | raycast, orbstack, ghostty, arc, jordanbaird-ice, homerow, localsend, lunar, mac-mouse-fix, protonvpn, utm | Always |

**Files changed:**
- `modules/darwin/brew/default.nix` - Added profile-conditional app lists
- `systems/nebulanix/apps.nix` - Removed casks (kept taps only)
- `systems/spacehound/apps.nix` - Removed casks (kept taps only)

## Phase 6: Karabiner Prep ✅

### Implementation

**New profile options in `modules/home/profiles.nix`:**
```nix
keyboard.tapHold = {
  enable = mkEnableOption "tap/hold key behavior (requires Karabiner)";
  tapKey = "escape" | "control" | "none";
  holdKey = "escape" | "control" | "hyper" | "none";
  apps = {
    "com.apple.Terminal" = { tapKey = "escape"; holdKey = "none"; };
    "com.googlecode.iterm2" = { tapKey = "escape"; holdKey = "control"; };
    "com.microsoft.VSCode" = { tapKey = "escape"; holdKey = "escape"; };
  };
};
```

**New module: `modules/home/karabiner.nix`:**
- Generates Karabiner Elements complex_modifications JSON
- Supports global tap/hold settings
- Supports per-app overrides
- Uses xdg.configFile to write config to `~/.config/karabiner/assets/complex_modifications/izgarden.json`

### Usage

To enable tap/hold behavior:
```nix
garden.profiles.coding.keyboard.tapHold.enable = true;
garden.profiles.coding.keyboard.tapHold.tapKey = "escape";
garden.profiles.coding.keyboard.tapHold.holdKey = "hyper";

# Optional per-app overrides
garden.profiles.coding.keyboard.tapHold.apps = {
  "com.microsoft.VSCode" = { tapKey = "escape"; holdKey = "escape"; };
  "com.googlecode.iterm2" = { tapKey = "escape"; holdKey = "control"; };
};
```

---

## Next Steps (Optional)

**VIA Integration:**
- Bind toggle script to VIA macro key
- Test with external keyboard layers

## Rollback

If needed:
```bash
git checkout gabz-v2-backup-pre-cleanup
```

Backup branch maintained.

---

**Status: COMPLETE** ✅  
**All systems operational** ✅  
**Ready for daily use** ✅
