# OpenCode Plugin Integration Plan

> Comprehensive plan for integrating OpenCode plugins with the flake setup

---

## Session Summary

This plan documents the research findings from session 2026-02-20 on plugin verification, compatibility analysis, and OCX integration.

### What Was Accomplished
- Tested Phase 1 plugins one-by-one (opencode-toolbox ✅, opencode-working-memory ✅)
- Discovered `opencode-worktree` was the wrong package (standalone CLI, not OpenCode plugin)
- Researched official ecosystem sources to verify all plugins
- Researched memory plugin alternatives (non-cloud)
- Analyzed DCP + memory compatibility (conflict found)
- Designed OCX module for flake integration
- Decided on priority: Option A (test working-memory features) → Option B (OCX integration)

---

## Verified Plugin Inventory

### Category: Core (Memory, MCP, Worktree)

| Our Name | Correct NPM Package | GitHub Repo | Verified | Install Method |
|----------|-------------------|-------------|----------|----------------|
| `opencode-toolbox` | `opencode-toolbox` | Community | ✅ NPM exists | npm (auto-installed) |
| `opencode-working-memory` | `opencode-working-memory` | sdwolf4103/opencode-working-memory | ✅ Verified | npm (auto-installed) |
| `opencode-worktree` | **N/A** | kdcokenny/opencode-worktree | ✅ Listed | **OCX only** (`ocx add kdco/worktree`) |

### Category: Foundation (Auth, Quota, Notifications)

| Our Name | Correct NPM Package | GitHub Repo | Verified | Install Method |
|----------|-------------------|-------------|----------|----------------|
| `opencode-antigravity-multi-auth` | `opencode-antigravity-auth` | NoeFabris/opencode-antigravity-auth | ✅ Listed | npm |
| `opencode-quota` | `@slkiser/opencode-quota` | slkiser/opencode-quota | ✅ NPM exists | npm |
| `@mohak34/opencode-notifier` | `opencode-notifier` | mohak34/opencode-notifier | ✅ Listed | npm |

### Category: Efficiency (DX Tools)

| Our Name | Correct NPM Package | GitHub Repo | Verified | Install Method |
|----------|-------------------|-------------|----------|----------------|
| `@nick-vi/opencode-type-inject` | `opencode-type-inject` | nick-vi/opencode-type-inject | ✅ Listed | npm |
| `opencode-snippets` | `opencode-snippets` | JosXa/opencode-snippets | ✅ Listed | npm |
| `@franlol/opencode-md-table-formatter` | `opencode-md-table-formatter` | franlol/opencode-md-table-formatter | ✅ Listed | npm |

---

## OCX Plugins (from kdco registry)

### Individual OCX Plugins (NOT from bundle)

| Plugin | NPM Package | Install | Test How |
|--------|------------|---------|----------|
| `opencode-worktree` | OCX | `ocx add kdco/worktree` | `"Create a worktree for feature-x"` |
| `opencode-notify` | OCX | `ocx add kdco/notify` | Desktop notifications |
| `opencode-background-agents` | OCX | `ocx add kdco/background-agents` | `@agent` delegation |

### ⚠️ Bundle (NOT Individual)

| Plugin | Contains | Install |
|--------|----------|---------|
| `opencode-workspace` | 16 components (bundle) | `ocx profile add ws --from kit/ws` |

---

## Memory Plugin Alternatives (Non-Cloud)

Researched non-cloud memory options for Option B compatibility:

| Plugin | Author | Stars | Type | Local? |
|--------|--------|-------|------|--------|
| `opencode-working-memory` | sdwolf4103 | 28 | Four-tier (Core/Working/Pressure/Pruning) | ✅ |
| `@csuwl/opencode-memory-plugin` | csuwl | 2 | OpenClaw-style + vector | ✅ |
| `@happycastle/opencode-openmemory` | happycastle | - | OpenMemory-based | ✅ (self-hosted) |
| `opencode-mem` | tickernelz | 95 | Local vector DB (SQLite) | ✅ |
| `opencode-personal-knowledge` | - | - | MCP + vector | ✅ |

**Chosen**: `opencode-working-memory` (Option A)
- Four-tier architecture: Core + Working + Pressure + Pruning
- Built-in pruning (no need for DCP)
- Zero configuration

---

## Compatibility Analysis

### DCP + Memory Conflict ⚠️

**Finding**: Using DCP (`@tarquinen/opencode-dcp`) with memory plugins is problematic:

1. **Token ADD + Token REMOVE = Conflict**
   - Memory plugins ADD tokens to context (injects memory blocks)
   - DCP REMOVES/compacts tokens from context
   - Creates competing operations

2. **DCP may prune what memory captures**
   - DCP removes tool outputs after processing
   - Memory plugins may want to capture those outputs
   - Could break memory capture pipeline

3. **Token Cost Impact**
   - From DCP docs: ~80% cache hit rate with DCP vs ~85% without
   - Memory injection further reduces cache efficiency
   - Trade-off: memory accuracy vs context optimization

4. **working-memory has built-in pruning**
   - Already handles pressure monitoring and smart pruning
   - Adding DCP is redundant

**Recommendation**: Skip DCP if using any memory plugin.

---

## One-by-One Testing Order

### Already Tested ✅
1. `opencode-toolbox` - ✅ Works
2. `opencode-working-memory` - ✅ Works

### Remaining Tests (Category order)

#### Category: Core
3. `opencode-worktree` - OCX only (handle separately)

#### Category: Foundation
4. `opencode-antigravity-auth` - Test one-by-one
5. `@slkiser/opencode-quota` - Test one-by-one
6. `opencode-notifier` - Test one-by-one

#### Category: Efficiency
7. `opencode-type-inject` - Test one-by-one
8. `opencode-snippets` - Test one-by-one
9. `opencode-md-table-formatter` - Test one-by-one

---

## OCX Integration Plan

### Approach: Full OCX (Option A from decision)

All plugins migrated to OCX while preserving categories.

### Integration Steps

#### Step 1: Add OCX to Mise

Add to `home/gabz/core/system/mise.nix`:

```nix
globalConfig = {
  tools = {
    # ... existing tools ...
    ocx = "latest";
  };
};
```

#### Step 2: Create OCX Module

Create file: `modules/home/programs/opencode/ocx.nix`

```nix
{ lib, config, ... }:

let
  ocxCfg = config.garden.programs.opencode.ocx;
in
{
  options.garden.programs.opencode.ocx = {
    enable = lib.mkEnableOption "OCX (OpenCode eXtensions) plugin manager";
    
    registries = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://registry.kdco.dev"
        "https://ocx-kit.kdco.dev"
      ];
      description = "OCX registries to add";
    };
    
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "kdco/worktree" "kdco/notify" ];
      description = "OCX plugins to install";
    };
    
    profiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "kit/ws" ];
      description = "OCX profiles to install";
    };
  };
  
  config = lib.mkIf ocxCfg.enable {
    # Setup registries on first run
    home.activationScript = ''
      ${lib.concatMapStrings (r: "ocx registry add ${r} --global\n") ocxCfg.registries}
    '';
    
    # Install plugins
    home.activationScript = lib.mkIf (ocxCfg.plugins != [ ]) ''
      ${lib.concatMapStrings (p: "ocx add ${p}\n") ocxCfg.plugins}
    '';
    
    # Install profiles
    home.activationScript = lib.mkIf (ocxCfg.profiles != [ ]) ''
      ${lib.concatMapStrings (p: "ocx profile add ${p}\n") ocxCfg.profiles}
    '';
  };
}
```

#### Step 3: One-time Registry Setup
```bash
ocx registry add https://registry.kdco.dev --name kdco --global
ocx registry add https://ocx-kit.kdco.dev --name kit --global
```

#### Step 4: Install OCX Plugins
```bash
# Core
ocx add kdco/worktree
```

---

## Detailed Test Commands for Each Plugin

### NPM Plugins (auto-installed via home-manager)

| Plugin | Test Command/Action |
|--------|-------------------|
| **working-memory** | `"Use core_memory_update to set goal: test"` → `"Use core_memory_read"` |
| **working-memory** | `"Use working_memory_add to remember: test item"` |
| **working-memory** | Work in long session, trigger compaction, verify memory survives |
| **toolbox** | Configure MCP server, ask: "Search for file search tools" |
| **antigravity-auth** | Set model to `gemini-3-pro`, use normally |
| **quota** | Type `/quota` or `/tokens_daily` in chat |
| **notifier** | Run command requiring permission, see toast notification |
| **type-inject** | Read a TypeScript file, check if types injected in context |
| **snippets** | Type `#your-snippet` in message |
| **md-table-formatter** | Create a markdown table |

### OCX Plugins (installed via ocx add)

| Plugin | Test Command/Action |
|--------|-------------------|
| **worktree** | `"Create a worktree for feature-x"` → should spawn terminal |
| **notify** | Same as notifier, but native OS notifications |
| **background-agents** | `"Use @agent to research X in background"` |

---

## Complete Plugin Categories (NPM + OCX)

### Category: Core (Memory, MCP, Worktree)

| # | Plugin | Type | Install | Test How | Status |
|---|--------|------|---------|----------|--------|
| 1 | `opencode-working-memory` | NPM | auto | `core_memory_update` tool | ✅ Tested |
| 2 | `opencode-toolbox` | NPM | auto | MCP tool search | ✅ Tested |
| 3 | `opencode-worktree` | **OCX** | `ocx add kdco/worktree` | Create worktree | 🔲 |

### Category: Foundation (Auth, Quota, Notifications)

| # | Plugin | Type | Install | Test How | Status |
|---|--------|------|---------|----------|--------|
| 4 | `opencode-antigravity-auth` | NPM | auto | Use `gemini-3-pro` model | 🔲 |
| 5 | `@slkiser/opencode-quota` | NPM | auto | `/quota` command | 🔲 |
| 6 | `opencode-notifier` | NPM | auto | Permission toast | 🔲 |
| 7 | `opencode-notify` | **OCX** | `ocx add kdco/notify` | Desktop notification | 🔲 |
| 8 | `opencode-background-agents` | **OCX** | `ocx add kdco/background-agents` | `@agent` delegation | 🔲 |

### Category: Efficiency (DX Tools)

| # | Plugin | Type | Install | Test How | Status |
|---|--------|------|---------|----------|--------|
| 9 | `opencode-type-inject` | NPM | auto | Read .ts file | 🔲 |
| 10 | `opencode-snippets` | NPM | auto | `#snippet` expansion | 🔲 |
| 11 | `opencode-md-table-formatter` | NPM | auto | Markdown table | 🔲 |

### Category: Advanced (Bundle - NOT Individual) ⚠️

| Plugin | Type | Contains | Install |
|--------|------|----------|---------|
| `opencode-workspace` | **OCX Bundle** | 16 components | `ocx profile add ws --from kit/ws` |

---

## Updated Plugin Categories (For Nix Config)

Based on verification, here are the corrected categories:

### Core
```nix
core = [
  "opencode-toolbox"              # ✅ Verified NPM
  "opencode-working-memory"       # ✅ Verified (chosen memory)
  # "opencode-worktree" - OCX only, handled separately
];
```

### Foundation
```nix
foundation = [
  "opencode-antigravity-auth"    # ✅ Corrected name
  "@slkiser/opencode-quota"      # ✅ Corrected name
  "opencode-notifier"            # ✅ Corrected name (removed @mohak34/)
];
```

### Efficiency
```nix
efficiency = [
  "opencode-type-inject"         # ✅ Corrected name (removed @nick-vi/)
  "opencode-snippets"            # ✅ Verified
  "opencode-md-table-formatter"  # ✅ Corrected name (removed @franlol/)
];
```

---

## Action Items (When Resuming)

### Priority: Option A (Test Working-Memory Features First)

1. **Test working-memory features in detail**
   - Use test commands: `core_memory_update`, `core_memory_read`, `working_memory_add`
   - Verify memory survives compaction

2. **Add OCX to mise.nix**
   - Add `ocx = "latest"` to `home/gabz/core/system/mise.nix`

3. **Create ocx.nix module**
   - Create `modules/home/programs/opencode/ocx.nix`

4. **Test OCX plugin** (Option B)
   - Add `opencode-worktree` via OCX
   - Test worktree creation

5. **Continue testing remaining npm plugins**
   - opencode-antigravity-auth
   - @slkiser/opencode-quota
   - opencode-notifier
   - opencode-type-inject
   - opencode-snippets
   - opencode-md-table-formatter

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `.opencode/plans/PLAN_PLUGIN_TESTING.md` | This plan |
| `modules/home/programs/opencode/` | OpenCode module directory |
| `modules/home/programs/opencode/default.nix` | Main module |
| `modules/home/programs/opencode/plugins.nix` | NPM plugin definitions |
| `modules/home/programs/opencode/ocx.nix` | NEW: OCX module (create) |
| `home/gabz/core/system/mise.nix` | Mise config (add ocx) |
| `systems/nebulanix/users.nix` | Nebulanix user config |

---

## References

- Official Ecosystem: https://opencode.ai/docs/ecosystem/
- Awesome OpenCode: https://github.com/awesome-opencode/awesome-opencode
- OCX GitHub: https://github.com/kdcokenny/ocx
- KDCO Registry: https://registry.kdco.dev
- Memory Plugin: https://github.com/sdwolf4103/opencode-working-memory

---

## Current Working State (Nebulanix)

```nix
plugins = [
  "opencode-toolbox"
  "opencode-working-memory"
];
```

Tested and working as of 2026-02-20.

---

## Session Restart Notes

### Quick Handoff

**Status**: Testing plugins one-by-one, working-memory features confirmed working

**Next**:
1. Test working-memory features in detail (Option A)
2. Add OCX to mise → Create ocx.nix module
3. Add opencode-worktree via OCX
4. Continue with remaining npm plugins

**Key Findings**:
- opencode-worktree = OCX-only (wrong npm package removed)
- Skip DCP if using memory plugins (conflict)
- Use npm for most plugins, OCX for worktree/notify/background-agents
- workspace bundle is 16 components (use individual first)

**Test Commands Ready**:
```bash
# Working-memory features
"Use core_memory_update to set goal: testing"
"Use core_memory_read to show memory"
"Use working_memory_add to remember: test item"
```

---

## Session Handoff: Phase 1 OCX Integration (2026-02-20)

### Current Status
**Phase:** Implementation complete, awaiting deployment and testing

### What Was Accomplished
- Fixed duplicate option definitions in `default.nix` (removed triplicates)
- Updated `users.nix` to use OCX for Phase 1 plugins
- Created `PLUGIN_CATEGORIZATION.md` documentation
- All three Phase 1 plugins now configured via OCX:
  - `kdco/worktree` (OCX native)
  - `npm:opencode-toolbox@0.10.4` (NPM via OCX)
  - `npm:opencode-working-memory` (NPM via OCX)

### Files Modified
| File | Change |
|------|--------|
| `modules/home/programs/opencode/default.nix` | Removed duplicate options |
| `systems/nebulanix/users.nix` | Updated Phase 1 to OCX |
| `.opencode/docs/PLUGIN_CATEGORIZATION.md` | Created |

### Next Steps
1. Deploy: `just provision nebulanix`
2. Test all three Phase 1 plugins together:
   ```bash
   ocx list
   # Test worktree
   "Create a worktree for feature/test-ocx"
   # Test toolbox
   toolbox_status({})
   # Test working-memory
   core_memory_read({})
   ```

### If Interrupted
- Plugin comparison complete: working-memory and toolbox superior to OCX alternatives
- Worktree is OCX-only (no npm)
- Hybrid approach for Phase 2+ (some OCX, some NPM)
