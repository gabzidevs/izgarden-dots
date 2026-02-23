# Ollama Operations: Managing Local LLM Servers

> Managing local Ollama server for OpenCode integration

## Goals

1. **Manage** ollama via Nix package with service management on `nebulanix`
2. **Maintain** existing qwen model for local LLM operations
3. **Run** ollama server with opencode integration
4. **Enable** remote access via SSH with `OLLAMA_HOST`
5. **Support** both nix-managed service and Raycast triggers
6. **Use** mise-provided opencode (primary) with nix fallback
7. **Create** home-manager module for opencode

---

## Current State

- **Location**: `systems/nebulanix/apps.nix` - ollama via nix package
- **Model**: qwen available locally (in `~/.ollama/models/`)
- **Systems**: nebulanix (server), spacehound (client)

---

## Implementation Plan

### Phase 1: Setup Nix Package

- Add `ollama` to user packages via home-manager
- Remove `"ollama"` from `homebrew.brews` in `apps.nix`

### Phase 2: Model Management

The qwen model lives at `~/.ollama/models/` - persists on the server.

### Phase 3: Raycast Script

- Create `scripts/ollamactl` for start/stop/restart/status

### Phase 4: Opencode Configuration

**IMPORTANT**: Only **Qwen3 models** support full tool calling!

Create `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen3:8b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "http://localhost:11434/v1" },
      "models": { "qwen3:8b": { "tools": true } }
    }
  }
}
```

### Phase 5: SSH Remote Access

On nebulanix: set `OLLAMA_HOST=0.0.0.0:11434`
On remote: set `OLLAMA_HOST=<nebulanix-ip>:11434`

### Phase 6: Spacehound Connect Script (with Gum)

Create `scripts/ollama-connect` using gum for interactive prompts.

### Phase 7: Add OpenCode & Gum to Mise

Update `home/gabz/core/system/mise.nix`:
```nix
tools = {
  opencode = "latest";
  gum = "latest";
};
```

### Phase 8: Home-Manager Module

Create `modules/home/programs/opencode.nix` for OLLAMA_HOST env var.

---

## File Changes Summary

| File | Action |
|------|--------|
| `systems/nebulanix/apps.nix` | ✅ Removed `ollama` from brews |
| `home/gabz/core/packages.nix` | ✅ Added `ollama` to packages |
| `scripts/ollamactl` | ✅ Created control script |
| `scripts/ollama-connect` | 📋 Create |
| `home/gabz/core/system/mise.nix` | 📋 Add tools |
| `modules/home/programs/opencode.nix` | 📋 Create |
| `docs/future/OLLAMA_MIGRATION.md` | ✅ Plan |

---

## Commands

```bash
# Rebuild
sudo darwin-rebuild switch --flake .#nebulanix

# Test
ollama list
ollama serve &
opencode
```

---

## Known Issues

### Raycast Commands Not Auto-Created

The `home.activation` scripts in `home/gabz/core/system/secrets.nix` are not being executed by home-manager during activation. This is a known issue with the nix-darwin + home-manager integration.

**Current workaround**: Raycast commands are created manually or persist from previous runs.

**To manually create**:
```bash
mkdir -p ~/.local/share/flake/scripts ~/.local/share/raycast/commands
ln -sf ~/.config/flake/scripts/toggle-capslock.sh ~/.local/share/flake/scripts/
ln -sf ~/.config/flake/scripts/ollamactl ~/.local/share/flake/scripts/
ln -sf ~/.config/flake/scripts/ollama-connect ~/.local/share/flake/scripts/

# Create Raycast scripts...
```

**Potential fixes to investigate**:
1. The `lib.hm.dag.entryAfter` might need different import paths when used with nix-darwin
2. May need to use `home-manager switch` directly instead of `darwin-rebuild`
3. Could try using simpler activation without DAG ordering
4. Check if nix-darwin's home-manager integration has specific requirements

---

## Session Summary (2026-02-16)

### Discoveries

1. **Brew ollama removal issue**: Required manual `sudo rm -rf /opt/homebrew/Cellar/ollama` because brew won't run as root but Cellar is owned by root.

2. **Mise visibility issue**: The `just provision` command wasn't showing mise install output because `set -e` was exiting early due to nix-darwin returning exit code 1. Fixed by adding `|| true` to prevent early exit.

3. **home.activation not running**: The Raycast command creation via home-manager's `lib.hm.dag.entryAfter` is not being executed during activation. This is a known issue with nix-darwin + home-manager integration. The working pattern uses `inherit (lib.hm.dag) entryAfter;` instead of `lib.hm.dag.entryAfter`.

4. **Default use-nix-daemon**: Changed default from `true` to `false` since Lix is now fixed.

### Accomplished

- Removed ollama from homebrew.brews in `systems/nebulanix/apps.nix`
- Added ollama to nix packages in `home/gabz/core/packages.nix`
- Added opencode and gum to mise tools in `home/gabz/core/system/mise.nix`
- Created home-manager module for opencode config generation (`modules/home/programs/defaults.nix`)
- Created `scripts/ollamactl` (start/stop/restart/status)
- Created `scripts/ollama-connect` (interactive gum-powered remote connect)
- Auto-generated `~/.config/opencode/opencode.json` via home-manager
- Added `just provision` improvements: mise install runs, better error handling, optional lix cleanup
- Raycast commands manually created (workaround for activation issue)

### Files Modified

| File | Change |
|------|--------|
| `systems/nebulanix/apps.nix` | Removed ollama from brews |
| `systems/nebulanix/users.nix` | Enabled opencode module |
| `home/gabz/core/packages.nix` | Added ollama package |
| `home/gabz/core/system/mise.nix` | Added opencode & gum tools |
| `modules/home/programs/defaults.nix` | Added opencode options & config generation |
| `justfile` | Added mise install, error handling, default use-nix-daemon=false |
| `docs/future/OLLAMA_MIGRATION.md` | Updated with known issues |

---

*Created: 2026-02-16*
*Status: Partial - nix package works, Raycast auto-creation needs debugging*
