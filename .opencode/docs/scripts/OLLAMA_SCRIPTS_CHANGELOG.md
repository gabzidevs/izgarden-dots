# Ollama Scripts Changelog

This document tracks improvements and enhancements to the Ollama management scripts.

## Scripts Overview

| Script | Purpose | Current Lines |
|--------|---------|---------------|
| `ollamactl` | Server control (start/stop/restart/status/health/list/logs) | 268 |
| `ollama-model` | Model management (pull/rm/list/purge/recommend) | 453 |

---

## ollamactl Improvements

### Feature Status

| Feature | Description | Status | Notes |
|---------|-------------|--------|-------|
| VRAM Override | Bypass 75% unified memory limit | **Pending** | Requires setting `OLLAMA_MAX_LOADED_MODELS` and memory estimation |
| Auto-restart on Crash | Restart on crash with exponential backoff | **Pending** | Need to implement crash detection + backoff logic |
| Gum Interactivity | Menus, spinners, confirmations | **In-Progress** | Partial - basic gum usage exists, needs full TUI |
| Watch Command | Monitor server metrics in real-time | **Pending** | New command to add |
| Tune Command | Adjust runtime parameters | **Pending** | New command to add |
| Models Command | Quick model listing with stats | **Pending** | New command to add |

### Current Commands
```
start, stop, restart, status, health, list, logs
```

### Planned Commands
```
watch, tune, models
```

### Implementation Notes

#### VRAM Override
```bash
# Environment variables to use:
OLLAMA_MAX_LOADED_MODELS=3
OLLAMA_NUM_PARALLEL=4
# Custom memory calculation needed
```

#### Auto-restart with Exponential Backoff
```bash
# Algorithm:
# 1. Monitor process health (check pid + API)
# 2. On crash: restart immediately
# 3. On subsequent crash: wait 2^n seconds (max 5 attempts)
# 4. After 5 failures: alert user and stop auto-restart
# 5. Reset counter after successful run > 5 minutes
```

#### Gum Interactivity
- Replace `echo` statements with `gum style`
- Add spinners for async operations (`gum spin`)
- Use `gum confirm` for destructive actions
- Add `gum choose` menus for sub-commands

---

## ollama-model Improvements

### Feature Status

| Feature | Description | Status | Notes |
|---------|-------------|--------|-------|
| Download Progress Bar | Gum-based progress for `ollama pull` | **In-Progress** | Need custom progress parsing |
| Better Hints System | Context-aware model suggestions | **Pending** | Based on available RAM, use case |
| Model Details View | Show model metadata, size, params | **Pending** | New view command |

### Current Commands
```
list, pull, rm, purge, storage, recommend, interactive
```

### Planned Commands
```
details <model>, info <model>
```

### Implementation Notes

#### Download Progress Bar
```bash
# Gum spin with custom progress:
# ollama pull model | while read line; do
#   parse progress from line
#   gum spin --title "Downloading..." -- ...
# done

# Alternative: use gum progress if available
gum progress --title "Downloading $model"
```

#### Better Hints System
- Detect available RAM at runtime
- Ask user for primary use case (coding, reasoning, vision)
- Cross-reference with MODELS array
- Show compatible models first

#### Model Details View
```bash
# Display:
# - Model name and size
# - Quantization
# - Parameters (if available via ollama)
# - Last used date
# - File size on disk
# - Recommended use cases
```

---

## Current Script State Summary

### ollamactl (as of 2026-02-16)
- ✅ Basic start/stop/restart
- ✅ Status with process info
- ✅ Health check with API validation
- ✅ Model listing
- ✅ Log viewing
- ✅ Optimization ✅ Temperature monitoring
 config loading
-- ⚠️ Basic echo output (needs gum TUI)

### ollama-model (as of 2026-02-16)
- ✅ Interactive mode with gum
- ✅ Model library with metadata
- ✅ Pull/rm with confirmations
- ✅ Storage tracking with warnings
- ✅ Recommendations based on RAM
- ⚠️ Basic progress for downloads (needs improvement)
- ⚠️ Hints system is basic (static recommendations)

---

## Migration Checklist

- [ ] Add VRAM override to `cmd_start()` in ollamactl
- [ ] Create `cmd_watch()` for real-time monitoring
- [ ] Create `cmd_tune()` for runtime adjustments
- [ ] Create `cmd_models()` for quick listing
- [ ] Add exponential backoff wrapper in ollamactl
- [ ] Convert ollamactl output to gum TUI
- [ ] Add download progress to ollama-model
- [ ] Implement `cmd_details()` in ollama-model
- [ ] Improve hints system with runtime detection

---

## Related Files

- `scripts/ollama-optimize` - Performance optimization config
- `scripts/ollama-connect` - Remote connection helper (deprecated, use connect-ollama)
- `scripts/ollama-sysopt` - System optimization
- `scripts/connect-ollama` - **NEW** Unified connection wrapper (2026-02-21)

---

## connect-ollama (NEW - 2026-02-21)

Unified Ollama connection wrapper with machine awareness and smart fallback.

### Features
- Machine detection (`CURRENT_MACHINE` env var)
- Automatic fallback when server unreachable
- TUI with gum (when available)
- SSH remote start capability
- State persistence for connection history

### Commands
```
connect-ollama                  # Auto-connect with TUI fallback
connect-ollama qwen3:8b        # Use specific model
connect-ollama --local         # Force local mode
connect-ollama --remote        # Force remote (nebulanix)
connect-ollama --check         # Check connectivity
connect-ollama --status        # Show connection status
connect-ollama --switch        # Interactive model switch
connect-ollama --start-remote  # SSH to nebulanix and start ollama
```

### Environment Variables Set
- `CURRENT_MACHINE` - "nebulanix" | "spacehound" | "unknown"
- `OLLAMA_HOST` - Current server endpoint
- `OPENCODE_MODEL` - Active model name

### State Files
- `~/.local/share/opencode/runtime.json` - Active provider config
- `~/.local/share/opencode/state.json` - Connection history

---

*Last updated: 2026-02-21*
