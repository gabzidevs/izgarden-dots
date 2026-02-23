# Decisions Log

> Record of architectural decisions for izgarden-dots

## Date: 2026-02-16

### 1. Profile-Based Home Organization

**Decision**: Reorganize home/gabz/ into profile-based structure

**Structure**:
- `core/` - Always enabled (shell, git, packages, system, chromium)
- `dev/` - Coding profile (CLI tools, TUI tools)
- `recreational/` - Recreational profile (Discord, gaming)
- `media/` - Media profiles (creation, consumption, streaming)
- `terminals/` - Always enabled (Ghostty, WezTerm)
- `themes/` - Always enabled (Catppuccin, fonts)
- `.archived/` - Linux-only and unexplored tools

**Rationale**: 
- Clean separation of concerns
- Easy to enable/disable categories
- Removes Linux-only cruft from active config

**Status**: Phases 1 & 2 complete

---

### 2. Hybrid Profile System

**Decision**: Support both system-level and user-level profiles

**System Profiles** (Machine context):
- `work.focus` - Machine primarily for work
- `recreational.focus` - Machine primarily for gaming/play
- `media.*.enable` - Machine capabilities

**User Profiles** (Personal preferences):
- `coding.enable` - Dev tools
- `coding.keyboard.remapCapsLock` - Per-user keyboard preference
- `recreational.enable` - Gaming/entertainment
- `social.enable` - Communication apps
- `media.*.enable` - Media apps

**Homebrew Logic**:
- System-level casks based on machine focus
- User-level casks based on any user's profile
- Example: Steam installed if any user has recreational.enable

**Rationale**:
- Multi-user support (gabz, rodz, grcee)
- Machine personality (nebulanix=work, spacehound=gaming)
- User preferences can override/extend

**Status**: Phase 3 in planning

---

### 3. Caps Lock Remapping

**Decision**: Use nix-darwin system setting with per-user preference

**Configuration**:
```nix
coding.keyboard.remapCapsLock = "escape" | "control" | "none";
```

**Implementation**:
- Set in user's home-manager config
- Applied system-wide based on mainUser preference
- Default: "none" (no remapping)

**Current Mapping**: Escape (vim-style)

**Future Options**:
- Keep nix-darwin for simple mappings
- Upgrade to Karabiner for complex (escape on tap, hyper on hold)
- Raycast hyper key (conflicts with other methods)

**Rationale**:
- Simple, built-in solution
- Per-user configurable
- Can upgrade to Karabiner later without breaking changes

**Status**: Ready for implementation (Phase 3E)

---

### 4. Archive Strategy

**Decision**: Move unused files to `.archived/` rather than deleting

**Categories**:
- `.archived/linux-only/` - Linux-specific configs (hyprland, quickshell, etc.)
- `.archived/unexplored/` - Tools to revisit later (atuin, jj, neovim, notes)

**Rationale**:
- Preserves reference material
- Easy to restore if needed
- Keeps active config clean
- Not imported, so no impact on build

**Status**: Phase 1 complete

---

### 5. Media Profiles

**Decision**: Separate media into creation and consumption

**Profiles**:
- `media.creation.enable` - OBS, inkscape, gimp
- `media.consumption.enable` - Spotify, mpv, vlc
- `media.streaming.enable` - chatterino7

**Usage**:
- Both nebulanix and spacehound have creation enabled
- Spacehound additionally has streaming enabled
- Consumption enabled on both

**Rationale**:
- Creation used for both work and personal projects
- Consumption universal
- Streaming only on gaming machine

**Status**: To be implemented in Phase 3

---

### 6. Brew Cask Management

**Decision**: Move from system-specific `apps.nix` files to profile-conditional in brew module

**Current**: `systems/nebulanix/apps.nix` and `systems/spacehound/apps.nix`

**Target**: Profile-conditional casks in `modules/darwin/brew/default.nix`

**Migration**:
- Base casks always installed
- Work casks if work.focus
- Gaming casks if any user has recreational.enable
- Keep taps in system files if needed

**Rationale**:
- Centralized logic
- Profile-driven
- Easier to maintain

**Status**: Phase 3D

---

### 7. Karabiner Preparation

**Decision**: Prep HM module for future Karabiner use, but start with nix-darwin

**Current**: nix-darwin simple mapping (escape only)

**Future**: Karabiner module in `home/gabz/core/karabiner.nix`
  - Complex mappings
  - Escape on tap, hyper on hold
  - Per-app configurations

**Trigger for Migration**:
- Need hyper key functionality
- Want per-app key mappings
- Current solution insufficient

**Rationale**:
- Start simple, upgrade when needed
- No breaking changes
- Clear migration path documented

**Status**: Documented, ready when needed

---

### 8. Multi-User Design

**Decision**: Design for 2-3 users from the start

**Current Users**:
- gabz (mainUser) - Full profile access
- rodz - Limited profiles (gaming, social)
- grcee (spacehound only) - Optional

**Default Behavior**:
- New users: all profiles disabled (opt-in)
- Each user has independent profile config
- Keyboard remapping per-user via coding profile

**Rationale**:
- Already have rodz configured (commented out)
- Easy to add users later
- Profile isolation prevents conflicts

**Status**: Supported in design, needs implementation

---

### 9. Tool Exploration Backlog

**Decision**: Archive unexplored tools for later review

**Tools Archived**:
- `atuin` - Shell history sync (low priority)
- `jj` - Jujutsu VCS (learning git first)
- `neovim` (izvim) - Using mise instead
- `notes` - Undecided on workflow

**Review Criteria**:
- Need arises
- Current workflow insufficient
- Time to learn

**Rationale**:
- Avoid premature optimization
- Keep config focused
- Document for future self

**Status**: Archived in `.archived/unexplored/`

---

## Open Questions

1. **Should we migrate to Karabiner now or later?**
   - Decision: Later, when hyper key needed

2. **Should media.creation be enabled on both systems?**
   - Decision: Yes, used for both work and personal

3. **Should we use Raycast hyper key?**
   - Decision: No, conflicts with remapping

4. **What should rodz's default profiles be?**
   - Pending: Implement and test

---

## Next Actions

1. ✅ Phase 1: Archive Linux files (complete)
2. ✅ Phase 2: Create profile structure (complete)
3. 🔄 Phase 3: Implement profiles and update systems (in progress)
   - 3A: Extend profile modules
   - 3B: Update system configs
   - 3C: Update brew module
   - 3D: Migrate cask lists
   - 3E: Implement keyboard remapping

---

*Document all significant decisions here for future reference*
