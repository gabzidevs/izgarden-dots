# Ollama Management Scripts

Complete toolkit for managing Ollama LLM server on nebulanix (48GB M4 Pro) with spacehound (18GB M3) client support.

## Quick Reference

| Script | Purpose | System | Usage |
|--------|---------|--------|-------|
| `ollamactl` | Start/stop/restart ollama server | nebulanix | `ollamactl start` |
| `ollama-optimize` | Performance tuning wizard | nebulanix | `ollama-optimize` (interactive) |
| `ollama-model` | Model manager with storage tracking | nebulanix | `ollama-model` (interactive) |
| `ollama-sysopt` | System optimizations (VRAM, services) | nebulanix | `ollama-sysopt --apply` |
| `connect-ollama` | Connect to Ollama, switch models | any | `connect-ollama qwen3:8b` |
| `crush-setup` | Configure Crush AI assistant | spacehound | `crush-setup` (interactive) |

## Nebulanix Scripts (Server)

### ollamactl

Control the Ollama server with automatic optimization loading.

**Usage:**
```bash
ollamactl {start|stop|restart|status|list|health|logs}
```

**Commands:**
- `start` - Start server with optimizations loaded from `~/.config/ollama-optimize/current.env`
- `stop` - Stop server gracefully
- `restart` - Restart server
- `status` - Show process, API, and memory status
- `list` - List available models
- `health` - Detailed health check with model validation
- `logs` - Show last 50 lines of server logs

**Examples:**
```bash
# Start with optimizations
ollamactl start

# Check status
ollamactl status

# View logs
ollamactl logs
```

**Troubleshooting:**
- If "API not responding": Check `~/.ollama/server.log` for errors
- If "binary not found": Ensure ollama is in PATH via `just provision nebulanix`
- Thermal warnings: Server will start but warns if CPU >85°C

**Configuration:**
- Automatically loads: `~/.config/ollama-optimize/current.env`
- Default optimizations if no config:
  - Context: 64000
  - KV Cache: q8_0
  - Flash Attention: enabled
  - Host: 0.0.0.0:11434

---

### ollama-optimize

Interactive performance tuner with presets and per-model configurations.

**Usage:**
```bash
ollama-optimize [OPTIONS]
ollama-optimize --preset <name>
ollama-optimize --model <model-name>
```

**Options:**
- `--preset <name>` - Apply preset: speed, balanced, power, research
- `--model <model>` - Load per-model config (qwen3:8b, qwen3-coder:30b, deepseek-r1:8b, etc.)
- `--context <num>` - Context length (4096, 16384, 32000, 64000, 128000)
- `--kv-cache <type>` - KV cache: f16, q8_0, q4_0
- `--flash <0|1>` - Enable/disable flash attention
- `--parallel <num>` - Number of parallel requests (1-8)
- `--show` - Show current configuration
- `--help` - Show help

**Presets:**
- **speed** - 4k context, q4_0, max parallel (8)
- **balanced** - 16k context, q8_0, moderate parallel (4) ⭐ Recommended
- **power** - 32k context, q8_0, low parallel (2)
- **research** - 64k context, f16, single model (1)

**Interactive Mode:**
```bash
# Launch interactive wizard
ollama-optimize

# Select preset from menu
# Configure custom settings
# Save to ~/.config/ollama-optimize/current.env
```

**Examples:**
```bash
# Apply balanced preset
ollama-optimize --preset balanced

# Configure for specific model
ollama-optimize --model qwen3:8b

# Custom configuration
ollama-optimize --context 32000 --kv-cache q8_0 --flash 1
```

**Configuration File:**
```bash
# ~/.config/ollama-optimize/current.env
OLLAMA_CONTEXT_LENGTH=64000
OLLAMA_KV_CACHE_TYPE=q8_0
OLLAMA_FLASH_ATTENTION=1
OLLAMA_HOST=0.0.0.0:11434
OLLAMA_NUM_PARALLEL=4
OLLAMA_MAX_LOADED_MODELS=2
```

**Troubleshooting:**
- Config not loading: Check file exists at `~/.config/ollama-optimize/current.env`
- Gum not found: Install via `brew install gum` or `nix-env -iA nixpkgs.gum`
- Permission denied: Ensure script is executable: `chmod +x ollama-optimize`

---

### ollama-model

Interactive model manager with storage monitoring and smart recommendations.

**Usage:**
```bash
ollama-model [COMMAND]
ollama-model list                    # List all models
ollama-model pull <model>            # Pull with confirmation
ollama-model rm <model>              # Remove with confirmation
ollama-model purge [options]         # Remove unused models
ollama-model storage                 # Show storage breakdown
ollama-model recommend               # Get recommendations
ollama-model interactive             # Interactive browser (default)
```

**Purge Options:**
- `--older-than <days>` - Remove models unused for N days
- `--keep-essential` - Keep only essential set
- `--dry-run` - Preview without removing

**Model Categories:**

**Essential Set** (Recommended for 48GB, ~32.7GB total):
- `qwen3:8b` (~5.2GB) - Best balanced general purpose
- `qwen3-coder:30b` (~19GB) - Latest agentic coding model with 256K context
- `deepseek-r1:8b` (~5.2GB) - Reasoning + code distilled
- `gemma3:4b` (~3.3GB) - Fast + vision support

**Spacehound Fallback** (18GB constraint):
- `llama3.2:3b` (~2GB) - Fast fallback
- `gemma3:1b` (~1GB) - Ultra-fast
- `llama3.2:1b` (~1GB) - Lightweight
- `qwen3:0.6b` (~0.5GB) - Tiny but capable

**Extended Library:**
- `qwen3:30b` (~19GB) - Strong all-rounder
- `qwen3:14b` (~9GB) - Mid-range general
- `deepseek-r1:14b` (~9GB) - Reasoning specialist
- `devstral:24b` (~14GB) - Agentic coding champion (#1 SWE-Bench)
- `gpt-oss:20b` (~14GB) - OpenAI open weights
- `deepseek-coder-v2:16b` (~9GB) - MoE coding model
- `qwen2.5-coder:14b` (~9GB) - Proven coding performance

**Interactive Mode:**
```bash
# Launch interactive browser
ollama-model

# Browse by category
# View storage usage bar
# Pull with size/time estimates
# Purge unused models
```

**Storage Thresholds:**
- Warning at: 50GB used
- Suggest purge at: 100GB used
- Max recommended: 100GB (leaves 74GB for system)

**Examples:**
```bash
# Pull a model (with confirmation)
ollama-model pull qwen3:8b

# Check storage
ollama-model storage

# Purge old models (dry run first)
ollama-model purge --older-than 30 --dry-run
ollama-model purge --older-than 30

# Keep only essential
ollama-model purge --keep-essential
```

**Troubleshooting:**
- "No models found": Ollama not running, start with `ollamactl start`
- Low storage warning: Run `ollama-model purge --keep-essential`
- Download fails: Check network, retry with `ollama-model pull <model>`

---

### ollama-sysopt

System-level optimizations for nebulanix to maximize LLM performance.

**Usage:**
```bash
ollama-sysopt               # Show current status
ollama-sysopt --apply       # Apply all optimizations
ollama-sysopt --revert      # Revert to defaults
ollama-sysopt --status      # Detailed status
ollama-sysopt --vram-only   # Apply only VRAM override
ollama-sysopt --services    # Disable services only
ollama-sysopt --thermal     # Show thermal status
```

**Optimizations Applied:**

1. **VRAM Override** (requires sudo)
   - Bypasses macOS 75% unified memory limit
   - Sets: `iogpu.wired_limit_mb=45000` (~45GB of 48GB)
   - Persistent across reboots

2. **Service Cleanup** (requires sudo)
   - Disable Spotlight indexing: `sudo mdutil -a -i off`
   - Disable Dashboard: `defaults write com.apple.dashboard mcx-disabled -boolean YES`
   - Reduce Dock animations
   - Disable Time Machine local snapshots

3. **Thermal Monitoring**
   - Shows CPU/GPU temperatures via smctemp
   - Warning at: 80°C
   - Critical at: 90°C (throttling likely)

**Status Display:**
```bash
$ ollama-sysopt
══════════════════════════════════════════════════
  Ollama System Optimization Status
══════════════════════════════════════════════════

VRAM Limit:
  Current: 45000MB (optimized) ✅
  
Services:
  Spotlight: Disabled ✅
  Time Machine: No local snapshots ✅

Thermal Status:
  CPU: 72.5°C
  GPU: 68.2°C

Memory:
  Total: 48GB
  Available for ollama: ~45GB (with optimization)
```

**Examples:**
```bash
# Check current status
ollama-sysopt

# Apply all optimizations
ollama-sysopt --apply

# Check thermal status only
ollama-sysopt --thermal

# Revert all changes
ollama-sysopt --revert
```

**Troubleshooting:**
- "Permission denied": Run without sudo, script will prompt when needed
- VRAM not persisting: Check `/etc/sysctl.conf` exists and contains `iogpu.wired_limit_mb`
- smctemp not found: Run `just provision nebulanix` to install
- Services re-enabled after update: Re-run `ollama-sysopt --apply`

---

## Spacehound Scripts (Client)

### connect-ollama

Unified Ollama connection wrapper with machine awareness and smart fallback.

**Usage:**
```bash
connect-ollama                    # Auto-connect with TUI fallback
connect-ollama qwen3:8b          # Use specific model (positional arg)
connect-ollama --local            # Force local mode
connect-ollama --remote           # Force remote (nebulanix)
connect-ollama --host 192.168.1.10:11434  # Custom server
connect-ollama --check            # Check connectivity
connect-ollama --status           # Show connection status
connect-ollama --switch           # Interactive model switch
connect-ollama --start-remote     # SSH to nebulanix and start ollama
```

**Configuration:**
- Writes to: `~/.local/share/opencode/runtime.json`
- Env file: `~/.local/share/opencode/runtime.json.env` (auto-sourced by fish)
- State: `~/.local/share/opencode/state.json` (connection history)

**Environment variables set:**
- `CURRENT_MACHINE` - "nebulanix" | "spacehound" | "unknown"
- `OLLAMA_HOST` - Current server endpoint
- `OPENCODE_MODEL` - Active model name (e.g., "ollama/qwen3:8b")

**Examples:**
```bash
# Interactive selection (recommended)
connect-ollama

# Direct model switch
connect-ollama qwen3-coder:30b

# Check connectivity
connect-ollama --check

# Force local mode
connect-ollama --local

# Show status
connect-ollama --status
```

**Troubleshooting:**
- Model not found: Run `ollama list` to see installed models
- Connection refused: Run `ollamactl start` on the target machine
- Config not updating: Check `~/.local/share/opencode/runtime.json`

---

### crush-setup

Configure Crush AI assistant (by Charmbracelet) for project-based workflows.

**Usage:**
```bash
crush-setup                    # Run setup wizard
crush-setup --reconfigure      # Re-run configuration
crush-setup --show-config      # Display current config
```

**What is Crush?**
- AI coding agent by Charmbracelet (makers of Gum, Bubbles)
- LSP integration for codebase understanding
- Project-based sessions with context
- Multi-model support via OpenAI-compatible API

**Configuration Options:**
- Server URL: `http://192.168.1.10:11434/v1`
- Default model: Select from available ollama models
- LSP integration: Enable for better code understanding
- Project context: Maintain context across sessions

**Configuration File:**
```toml
# ~/.config/crush/config.toml
[server]
url = "http://192.168.1.10:11434/v1"
api_key = ""
timeout = 300

[models]
default = "qwen3:8b"
fast = "gemma3:4b"
code = "qwen3-coder:30b"
reasoning = "deepseek-r1:8b"

[features]
lsp_enabled = true
project_context = true
multi_model = true
auto_switch_on_error = true
```

**Examples:**
```bash
# First time setup
crush-setup

# Reconfigure
crush-setup --reconfigure

# View config
crush-setup --show-config
```

**Troubleshooting:**
- "Crush not found": Install via `mise use -g crush@latest`
- "Neublanix not reachable": Will configure for local use instead
- Config not loading: Check file at `~/.config/crush/config.toml`

---

### nix-daemon-workaround.sh

Temporary switch to upstream Nix daemon to work around Lix daemon bugs.

**Usage:**
```bash
nix-daemon-workaround.sh <command> [args...]
```

**Purpose:**
- Workaround for "writev broken pipe" errors
- Large build environments on macOS
- Automatically restores Lix daemon on exit

**Example:**
```bash
# Run nix command with upstream daemon
nix-daemon-workaround.sh nix build .#nebulanix

# Run just command
nix-daemon-workaround.sh just provision nebulanix
```

**How it works:**
1. Backs up current LaunchDaemon plist
2. Creates temporary plist with upstream Nix
3. Reloads LaunchDaemon
4. Runs your command
5. Restores original plist on exit (via trap)

**Troubleshooting:**
- "Could not find upstream nix-daemon": Ensure Nix is installed
- "Permission denied": Script requires sudo for LaunchDaemon changes
- Daemon not switching: Check console logs with `log show --predicate 'process == "launchctl"'`

---

## Common Troubleshooting

### Ollama won't start

1. Check if already running:
   ```bash
   ollamactl status
   ```

2. Check logs:
   ```bash
   ollamactl logs
   # or
   tail -f ~/.ollama/server.log
   ```

3. Common issues:
   - Port 11434 already in use: `lsof -i :11434` then `kill <pid>`
   - Permission denied: Check `~/.ollama` ownership
   - Out of memory: Reduce context length in ollama-optimize

### Can't connect from spacehound

1. Check nebulanix is reachable:
   ```bash
   ping 192.168.1.10
   curl http://192.168.1.10:11434/api/tags
   ```

2. On nebulanix, verify ollama is listening:
   ```bash
   sudo lsof -i :11434 | grep LISTEN
   # Should show 0.0.0.0:11434 (not 127.0.0.1:11434)
   ```

3. Check firewall:
   ```bash
   # On nebulanix
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --list
   ```

### Models not showing up

1. Pull models first:
   ```bash
   ollama-model pull qwen3:8b
   ```

2. Check models directory:
   ```bash
   ls -la ~/.ollama/models/
   ```

3. Verify model files are valid:
   ```bash
   ollama list
   ```

### Performance issues

1. Check current optimizations:
   ```bash
   ollama-optimize --show
   ```

2. Apply balanced preset:
   ```bash
   ollama-optimize --preset balanced
   ```

3. Check system resources:
   ```bash
   ollama-sysopt --status
   ollama-sysopt --thermal
   ```

4. Monitor memory usage:
   ```bash
   # While ollama is running
   ps aux | grep ollama
   ```

### Storage full

1. Check usage:
   ```bash
   ollama-model storage
   ```

2. Purge unused:
   ```bash
   # Dry run first
   ollama-model purge --older-than 30 --dry-run
   
   # Actually purge
   ollama-model purge --older-than 30
   ```

3. Keep only essential:
   ```bash
   ollama-model purge --keep-essential
   ```

---

## Environment Variables

All scripts respect these environment variables:

```bash
# Core ollama settings
OLLAMA_HOST=0.0.0.0:11434              # Listen address
OLLAMA_CONTEXT_LENGTH=64000            # Context window size
OLLAMA_KV_CACHE_TYPE=q8_0              # KV cache quantization
OLLAMA_FLASH_ATTENTION=1               # Enable flash attention
OLLAMA_NUM_PARALLEL=4                  # Parallel requests
OLLAMA_MAX_LOADED_MODELS=2             # Max loaded models

# Paths
OLLAMA_DIR=~/.ollama                   # Models directory
OPENCODE_CONFIG=~/.config/opencode/opencode.json
CRUSH_CONFIG=~/.config/crush/config.toml

# Network
NEBULANIX_HOST=192.168.1.10
NEBULANIX_PORT=11434
```

---

## Getting Help

- Check script help: `<script> --help`
- Read plan document: `docs/future/OLLAMA_OPTIMIZATION.md`
- Check this README: `scripts/README.md`
- View logs: `ollamactl logs`
- Check system status: `ollama-sysopt --status`

---

## Maintenance

**Regular tasks:**
- Weekly: `ollama-model storage` - Check storage usage
- Monthly: `ollama-model purge --older-than 30` - Clean old models
- As needed: `ollama-sysopt --thermal` - Monitor temperatures

**Updates:**
```bash
# Update ollama models
ollama-model pull qwen3:8b  # Re-pull to get updates

# Update scripts via git
git pull origin gabz-v2
just provision nebulanix
```
