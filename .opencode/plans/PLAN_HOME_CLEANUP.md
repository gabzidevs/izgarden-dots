# Plan: Home/gabz Cleanup for macOS Focus

> Trimming down to essentials: macOS + coding workflow

---

## Current State Analysis

Your `home/gabz/` currently has many disabled/commented modules that add clutter:

### What's Currently Enabled

```
cli/        - bat, direnv, eza, fd, fzf, gh, git, nix-your-shell, ripgrep, shell/, starship, zoxide
gui/        - chromium, ghostty  
tui/        - lazygit, navi, zellij
services/   - rnnoise (guarded), tray
system/     - docs, mise, secrets, ssh
themes/     - catppuccin, fonts, global, gtk (guarded), qt
```

### What's Disabled (Commented Out or Not Imported)

```
cli/        - atuin, jj
gui/        - discord, hyprland, media/, notes, quickshell, vicinae, wezterm
tui/        - izrss, neovim
services/   - (none, minimal)
```

---

## Cleanup Strategy

### Phase 1: Remove Linux-Only Components (High Impact)

These can be completely removed since they're macOS-incompatible:

| Item | Location | Reason | Action |
|------|----------|--------|--------|
| Hyprland WM | `gui/hyprland.nix` | Wayland/Linux only | Delete |
| Quickshell | `gui/quickshell.nix` + `gui/quickshell/` | Wayland status bar | Delete |
| Media apps | `gui/media/` directory | Mostly Linux-specific | Review then delete |
| Vicinae | `gui/vicinae/` | Wayland launcher | Delete |

### Phase 2: Consolidate GUI Directory (Medium Impact)

Current structure:
```
gui/
├── default.nix         # Mostly comments
├── chromium.nix        # Keep
├── ghostty.nix         # Keep
├── wezterm.nix         # Keep for spacehound
├── wezterm/            # Keep for spacehound
├── discord.nix         # Can delete or keep
├── hyprland.nix        # DELETE
├── notes.nix           # Review
├── quickshell.nix      # DELETE
├── quickshell/         # DELETE
└── media/              # DELETE (or keep selectively)
    ├── creation.nix
    ├── listening.nix
    ├── streaming.nix
    └── watching.nix
```

Proposed structure:
```
gui/
├── default.nix         # Import what you actually use
├── browsers.nix        # Combine chromium + any others
├── terminals.nix       # ghostty, wezterm configs
└── wezterm/            # Lua configs (only used by spacehound)
```

### Phase 3: Streamline TUI (Low-Medium Impact)

Current:
```
tui/
├── default.nix         # Comments out neovim, izrss
├── lazygit.nix         # Keep
├── navi.nix            # Keep
├── zellij.nix          # Keep
├── izrss.nix           # Review - RSS reader
└── neovim.nix          # Disabled - imports izvim
```

Decision needed on Neovim - do you want it enabled?

### Phase 4: Review Services (Low Impact)

Current:
```
services/
├── default.nix
├── rnnoise.nix         # PipeWire - Linux only (guarded)
└── tray.nix            # System tray
```

The rnnoise.nix has proper guards (`isLinux`) so it won't break, but it's dead code on macOS.

### Phase 5: Review CLI Tools (Low Impact)

Disabled items:
- `atuin.nix` - Shell history sync (cloud-based)
- `jj.nix` - Jujutsu version control (alternative to git)

Decision: Enable if you want them, or delete if not.

---

## Proposed New Structure

```
home/gabz/
├── default.nix            # Entry point
├── packages.nix           # Your packages
│
├── cli/                   # Command line (mostly keep as-is)
│   ├── default.nix
│   ├── shell/
│   ├── git.nix
│   ├── starship.nix
│   └── [active tools...]
│
├── dev/                   # NEW: Development-specific
│   ├── default.nix
│   ├── editors.nix        # Neovim, etc. if enabled
│   └── tools.nix          # Dev tools (mise, etc.)
│
├── gui/                   # Simplified
│   ├── default.nix        # Just browsers, terminals
│   ├── browsers.nix       # Chromium, etc.
│   └── terminals.nix      # Ghostty, WezTerm
│
├── macos/                 # NEW: macOS-specific configs
│   ├── default.nix        # Conditional import (darwin only)
│   ├── defaults.nix       # macOS defaults/defaults write
│   └── dock.nix           # Dock configuration
│
├── shared/                # NEW: Cross-platform shared
│   ├── default.nix
│   └── ...
│
└── themes/                # Keep, remove gtk/qt or guard better
    ├── default.nix
    ├── catppuccin.nix
    ├── fonts.nix
    └── global.nix
```

Alternative: Keep flat structure but delete unused files.

---

## Quick Cleanup Checklist

### Immediate Deletes (No Longer Needed)

- [ ] `home/gabz/gui/hyprland.nix`
- [ ] `home/gabz/gui/quickshell.nix`
- [ ] `home/gabz/gui/quickshell/` (whole directory)
- [ ] `home/gabz/gui/vicinae/` (whole directory)
- [ ] `home/gabz/gui/media/` (whole directory, or review first)
- [ ] `home/gabz/services/rnnoise.nix` (guarded but unused)
- [ ] `home/gabz/services/tray.nix` (if unused)
- [ ] `home/gabz/themes/gtk.nix` (guarded but could move to linux-specific)
- [ ] `home/gabz/themes/qt.nix` (review usage)

### Files to Review

- [ ] `home/gabz/gui/notes.nix` - Do you use it?
- [ ] `home/gabz/gui/wezterm/` - Only spacehound uses wezterm, keep conditionally
- [ ] `home/gabz/tui/neovim.nix` - Enable or delete
- [ ] `home/gabz/tui/izrss.nix` - Do you use RSS?
- [ ] `home/gabz/cli/atuin.nix` - Enable or delete
- [ ] `home/gabz/cli/jj.nix` - Enable or delete
- [ ] `home/gabz/services/` - Keep minimal or delete entirely

### Files to Keep (Core)

- [x] `home/gabz/cli/` - All active tools
- [x] `home/gabz/cli/shell/` - Fish, zsh configs
- [x] `home/gabz/cli/git.nix` - Your git config
- [x] `home/gabz/gui/ghostty.nix` - Primary terminal
- [x] `home/gabz/gui/chromium.nix` - Browser
- [x] `home/gabz/tui/lazygit.nix` - Git TUI
- [x] `home/gabz/tui/zellij.nix` - Multiplexer
- [x] `home/gabz/system/` - Mise, secrets, SSH
- [x] `home/gabz/themes/catppuccin.nix` - Theming
- [x] `home/gabz/themes/fonts.nix` - Fonts

---

## Questions for You

1. **Neovim**: Do you want it enabled? (Currently disabled via izvim)
2. **WezTerm**: Only spacehound uses it - keep the Lua configs there?
3. **RSS**: Do you use izrss? (TUI RSS reader)
4. **Jujutsu**: Want to try `jj` as git alternative?
5. **Atuin**: Want shell history sync across machines?
6. **Discord**: Use it? (Currently disabled)
7. **Media apps**: Any media creation/consumption tools you want from the media/ directory?

---

## Implementation Order

### Session 1: Safe Deletions
Delete obviously unused Linux-only files:
- hyprland.nix + directory
- quickshell.nix + directory
- vicinae/ directory

### Session 2: Review Disabled Items
Decide on:
- neovim.nix
- izrss.nix
- atuin.nix
- jj.nix
- notes.nix
- discord.nix

### Session 3: Reorganize (Optional)
If you want to restructure:
- Move macOS-specific things to `darwin/` subdirectory
- Flatten or reorganize gui/ directory
- Consider merging some small files

### Session 4: Clean Up Services
- Remove rnnoise.nix (Linux-only)
- Decide on tray.nix
- Consider if services/ directory is even needed

---

## Validation Steps

After each cleanup phase:

```bash
# 1. Check syntax
just check

# 2. Test build (dry-run)
just test

# 3. If confident, switch
just switch

# 4. Test your workflow
# - Open terminal
# - Test shell
# - Check git
# - Test GUI apps
```

---

## Backup Strategy

Before major deletions:

```bash
# Create backup branch
git checkout -b gabz-v2-backup-$(date +%Y%m%d) gabz-v2

# Or tag
git tag backup-$(date +%Y%m%d) gabz-v2

# Now cleanup on gabz-v2
```

---

## Benefits of Cleanup

1. **Faster evaluation** - Less dead code to parse
2. **Easier upstream sync** - Fewer conflicts in unused files
3. **Clearer ownership** - You know every file is actively used
4. **Simpler mental model** - Easier to navigate
5. **Better documentation** - Current state reflects actual usage

---

*See also: FORK_INDEX.md for full structure*  
*See also: PLAN_UPSTREAM_SYNC.md for sync workflow*
