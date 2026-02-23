---
name: migration-status
description: Check or update local LLM server status during activation workflow
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: ollama-local-switch
  status-file: ~/.local/state/ollama-server-status
---

## What I Do

Check and display the current local LLM server activation status, or update it during the activation phases.

## When to Use Me

Use this skill when you need to:
- Check if an activation is in progress
- Display current activation phase and progress
- Update status during phase transitions
- Track the "migration" (restart) phase specifically

## Status File Location

`~/.local/state/ollama-server-status`

## Status File Format

```
PHASE=<phase_name>
PROGRESS=<percentage>
MESSAGE=<current action>
HOST=<hostname>
MODEL=<selected_model>
STARTED=<ISO timestamp>
UPDATED=<ISO timestamp>
```

## How to Invoke

### Check Status (read-only)
```bash
server-status
server-status status
server-status check
```

### Update Status
```bash
server-status set --phase standby --progress 10 --message "Reviewing commits..."
server-status set --phase resources --progress 20 --message "Checking RAM/disk..."
server-status set --phase model --progress 30 --message "Selected qwen3:8b"
server-status set --phase server --progress 50 --message "Server activated"
server-status set --phase verify --progress 70 --message "Connection verified"
server-status set --phase reconnect --progress 90 --message "Restarting opencode..."
server-status set --phase complete --progress 100 --message "Activation complete"
server-status set --phase failed --progress 0 --message "Error: connection timeout"
```

### Clear Status
```bash
server-status clear
```

## Phases

| Phase | Progress | Description |
|-------|----------|-------------|
| `standby` | 10% | Phase 1 - Standby & review |
| `resources` | 20% | Phase 2 - Resource assessment |
| `model` | 30% | Phase 3 - Model selection |
| `server` | 50% | Phase 4 - Server activation |
| `verify` | 70% | Phase 5 - Connection verification |
| `reconnect` | 90% | Phase 6 - OpenCode restart (migration) |
| `complete` | 100% | Activation completed |
| `failed` | 0% | Activation failed |

## Integration

On OpenCode startup, check for status file:
```bash
if [ -f ~/.local/state/ollama-server-status ]; then
  server-status status
fi
```

## Example Output

```
🔄 Local LLM Server Status
==========================
Phase: verify
Progress: [███████░░░] 70%
Message: Connection verified - 12ms latency
Host: nebulanix
Model: qwen3:8b
Started: 2026-02-17T15:30:00
Updated: 2026-02-17T15:45:00

⏳ Activation in progress...
```

## Post-Restart Usage

After Phase 6 restart (the "migration"), the new OpenCode session should:
1. Check for status file existence
2. If `PHASE=reconnect`, continue to Phase 7
3. Report status to user
