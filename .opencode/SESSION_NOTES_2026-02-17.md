# Session Notes: 2026-02-17

**Prismo says:** *"Time is an illusion, but good notes are forever!"* 🎩✨

---

## Fixes Applied

### 1. Ollama Model Names
**Issue:** Scripts used invalid model names like `qwen3:8b-q5_K_M` that don't exist in Ollama registry  
**Fix:** Updated to correct names:
- `qwen3:8b-q5_K_M` → `qwen3:8b`
- `qwen3:32b-q5_K_M` → `qwen3-coder:30b`
- `deepseek-r1:8b-q5_K_M` → `deepseek-r1:8b`
- `deepseek-r1:32b-q5_K_M` → `deepseek-r1:32b`

**Files:** `scripts/ollama-model`, `scripts/ollama-optimize`

### 2. SSH Key Loading
**Issue:** OpenCode couldn't do git operations because SSH keys weren't automatically loaded  
**Fix:** Added `addKeysToAgent = "yes"` in `home/gabz/core/system/ssh.nix`

### 3. Sops Secrets
**Issue:** Empty `sops.secrets` override was blocking SSH keys  
**Fix:** Removed the empty override

---

## Features Created

### 1. The Enchiridion
**Location:** `enchiridion/` (at root level)  
**Purpose:** Adventure Time themed documentation/book system  
**Key Files:**
- `BORROWERS_LOG.md` - Writer assignments and chapter tracking
- Part directories with `.notes.md` templates for hidden knowledge
- Chapters 1-2 written, Model Selection Guide written

### 2. Prismo's Time Room
**Location:** `.opencode/time-room/`  
**Purpose:** Agent personas for different domains  
**Agents:**
- **Finn** - Git operations ("Mathematical!")
- **Simon** - Nix/NixOS expert ("In my time...")
- **Fern** - Dotfiles/Undergarden ("I'm a copy...")
- **Marceline** - Music/entertainment
- **Prismo** - Orchestrator/wish master

**Docs:**
- `PORTABILITY.md` - How to use agents in other projects
- `AGENTS.md` - Main agent index

### 3. Undergarden Planning
**Location:** `.opencode/docs/systems/UNDERGARDEN.md`  
**Concept:** Hide personal modifications from upstream using "Garden + Underground" architecture

---

## Key Architectural Decisions

### Undergarden: Garden + Underground Model (Option C)

**Vision:**
- **Surface (Garden):** isabelroses/dotfiles - untouched, pure upstream
- **Underground:** Your modifications - hidden in plain sight

**Structure:**
```
your fork
├── flake.nix                    # YOUR entry point
├── upstream/                    # Flake input (her repo as base)
├── systems/
│   ├── nebulanix/              # Your systems
│   └── modules/
│       └── undergarden/        # Secret vault
│           ├── hidden/         # "Upside-down rocks"
│           │   └── caverns/
│           │       └── personal/
│           │           ├── secrets.nix
│           │           └── private-config.nix
│           └── overlays/       # "Enhancements" to upstream
├── home/gabz/                  # Your home config
└── .opencode/time-room/        # Agents (already underground)
```

**How It Avoids Conflicts:**
1. **Separate directories** - Your stuff in `undergarden/`, hers elsewhere
2. **Additive only** - You only ADD modules, never MODIFY hers
3. **Deep nesting** - Hidden in `caverns/` directories
4. **Innocuous naming** - `local-*.nix`, `personal-*.nix`, `extras.nix`

**Key Pattern:**
```nix
# modules/base/extras.nix - "Just some extra base config"
{ lib, ... }:
let
  personal = lib.optional ./undergarden/personal.nix;
  secrets = lib.optional ./undergarden/secrets.nix;
in {
  imports = personal ++ secrets;
}
```

---

## Sync Strategy

**Frequency:** Bi-weekly  
**Method:** Rebase workflow (Option A from PLAN_UPSTREAM_SYNC.md)

**Files You Keep:**
- `systems/nebulanix/` - Your primary system
- `systems/spacehound/` - Your secondary system  
- `home/gabz/` - Your user config
- `flake.nix` (inputs) - Review carefully

**Files You Accept Upstream:**
- All of isabel's systems (`amaterasu`, `aphrodite`, etc.)
- `modules/nixos/` - You don't use NixOS
- `modules/wsl/` - You don't use WSL
- `home/isabel/` - Her user config

---

## Open Questions

### For Next Session with Simon:
1. **Best way to import her flake as base?** Flake inputs vs git submodules?
2. **How to override specific home-manager settings** without touching her files?
3. **What's shareable?** Which modules could benefit the wider Nix community?
4. **Performance impact?** Does importing her entire flake slow things down?

### Implementation Questions:
1. Create `systems/modules/undergarden/` structure?
2. Refactor flake.nix to use upstream as input?
3. Move personal configs to `undergarden/hidden/`?

### Sharing Back:
- Not decided yet - need better Nix-fu first
- Maybe scripts, generic modules, documentation?

---

## Next Steps (Priority Order)

1. **Continue Undergarden Implementation**
   - Create directory structure
   - Set up flake input for upstream
   - Test that it works

2. **Consult Simon**
   - Ask the 4 questions above
   - Get Nix module architecture advice
   - Understand what can be shared

3. **First Bi-Weekly Sync**
   - Try the rebase workflow
   - Use the sync script from PLAN_UPSTREAM_SYNC.md
   - Document any issues

4. **Enchiridion Chapters**
   - Delegate more chapters to Time Room agents
   - Update BORROWERS_LOG.md with assignments
   - Review written chapters

---

## Quick Reference

**Start new session:**
- Reference this file: `.opencode/SESSION_NOTES_2026-02-17.md`
- Or use latest: `.opencode/SESSION_SUMMARY.md`

**Key Directories:**
- `.opencode/time-room/agents/` - Agent personas
- `.opencode/docs/systems/` - System planning
- `.opencode/plans/` - Active plans
- `enchiridion/` - The Book

**Useful Commands:**
```bash
# Check upstream status
git log gabz-v2..upstream/main --oneline

# Run flake checks
just check

# Switch configuration
just switch
```

---

*"Everything stays, right where you left it... but we can always go deeper!"* 🌿🎸

**Prismo, signing off.** See you in the next session! 
