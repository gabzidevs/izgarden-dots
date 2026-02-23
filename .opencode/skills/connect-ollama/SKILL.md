---
name: connect-ollama
description: Unified Ollama connection wrapper with machine awareness and smart fallback
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: ollama-connection
  script: ~/.config/flake/scripts/oll
---

## What I Do

Manage Ollama connections across machines (nebulanix ↔ spacehound) with:
- Automatic machine detection
- Smart fallback when server unreachable
- SSH session awareness
- Connection history tracking

## When to Use Me

Use this skill when:
- Connecting to Ollama server
- Switching models
- Checking connection status
- Troubleshooting connectivity
- Starting remote Ollama via SSH

## Commands

All Ollama operations are now consolidated under `oll`:

### Connection (oll connect)
```bash
oll connect                       # Auto-connect with TUI fallback (alias: oll c)
oll connect qwen3:8b              # Use specific model
oll connect --local               # Force local mode
oll connect --remote              # Force nebulanix
oll connect --host <url>          # Custom server
```

### Server Management (oll server)
```bash
oll server start                  # Start Ollama server (alias: oll s start)
oll server stop                   # Stop Ollama server
oll server status                 # Check server status
oll server health                 # Health check
oll server logs                   # View server logs
```

### Model Management (oll model)
```bash
oll model list                    # List available models (alias: oll m list)
oll model pull <name>             # Pull a model
oll model rm <name>               # Remove a model
oll model storage                 # Check storage usage
oll model recommend               # Get model recommendations
```

### Performance Tuning (oll tune)
```bash
oll tune speed                    # Optimize for speed (alias: oll t speed)
oll tune balanced                 # Balanced settings
oll tune power                    # Max performance
oll tune research                 # For long context work
```

### Status & Profiles
```bash
oll status                        # Quick status overview
oll profile show                  # Show current OCX profile
oll profile list                  # List available profiles
oll profile set <name>            # Set profile
oll doctor                        # Run diagnostics
```

## Environment Variables Set

| Variable | Description |
| -------- | ----------- |
| `CURRENT_MACHINE` | "nebulanix" \| "spacehound" \| "unknown" |
| `OLLAMA_HOST` | Current server endpoint |
| `OPENCODE_MODEL` | Active model name |
| `OCX_PROFILE` | Active OCX profile (omo, omo-slim-plus, etc.) |

## State Files

| File | Purpose |
| ---- | ------- |
| `~/.local/share/opencode/runtime.json` | Active provider config |
| `~/.local/share/opencode/state.json` | Connection history |

## Machine Behavior

| Machine | Default Host | Default Profile | Fallback Model |
| ------- | ------------ | --------------- | -------------- |
| nebulanix | localhost:11434 | omo | llama3.2:1b |
| spacehound | nebulanix.local:11434 | omo-slim-plus | llama3.2:1b |

## SSH Sessions

When SSH'd into another machine:
- Auto-detects target from `SSH_CONNECTION`
- Shows warning with override options
- Use `--local`, `--remote`, or `--host` to override

## Example Agent Usage

```
System: You are running on {CURRENT_MACHINE}.
Use oll to manage Ollama connections.
Available models: qwen3:8b, deepseek-r1:8b, llama3.2:1b

To switch models:
  oll connect qwen3:8b

To check status:
  oll status

To start server:
  oll server start
```

## Related Commands

| Command | Description |
| ------- | ----------- |
| `oll` | Main Ollama operations CLI |
| `opz` | OpenCode wrapper with auto-detected profile |
| `doll` | Status dashboard |

## Integration with OpenCode

After running `oll connect`, the fish shell wrapper:
1. Sources `~/.local/share/opencode/runtime.json.env`
2. Sets `OPENCODE_MODEL`, `OLLAMA_HOST`, `CURRENT_MACHINE`
3. Launches `opencode` with correct provider

Use `opz` for a streamlined OpenCode launch with auto-detected profile.

## Troubleshooting

| Issue | Solution |
| ----- | -------- |
| Can't reach nebulanix | Run `oll connect --local` for local fallback |
| Wrong model | Run `oll connect <model-name>` to switch |
| SSH session issues | Use `--host` to specify exact server |
| Permission denied | Check SSH key auth for remote start |
| Server won't start | Run `oll doctor` for diagnostics |
