---
name: provision
description: Self-healing host-aware provision script for nix-darwin
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: system-provision
  script: ~/.config/flake/scripts/just-provision
---

## What I Do

Run nix-darwin provision with:
- Self-healing capabilities
- Host awareness (local vs SSH)
- Automatic system detection

## When to Use Me

Use this skill when:
- Provisioning a new system
- Running system updates
- Fixing broken nix-darwin setup
- Agent needs to ensure system is in correct state

## Commands

### Basic Provision
```
provision nebulanix
provision spacehound
```

### Self-Healing
```
provision <system> --heal
```

### Check Prerequisites
```
provision --check
```

## Environment

| Variable | Description |
| -------- | ----------- |
| `FLAKE_PATH` | Path to flake (default: /Users/gabz/.config/flake) |
| `FLAKE` | Flake reference (default: .) |

## Self-Healing Checks

The script automatically performs these checks:

1. **SSH Key Agent** - Ensures SSH key is loaded
2. **Nix Daemon** - Checks/starts nix-daemon if needed
3. **PATH Fixes** - Adds mise shims to PATH
4. **Permission Fixes** - Fixes common permission issues
5. **Lock File Check** - Reports stale lock files

## Host Awareness

| Scenario | Behavior |
| -------- | -------- |
| Local on nebulanix | Runs provision locally |
| Local on spacehound | Runs provision locally |
| SSH nebulanix → spacehound | SSH to spacehound, provision remotely |
| SSH spacehound → nebulanix | SSH to nebulanix, provision remotely |

## Integration

The script is exposed as:
- CLI: `just-provision` or `~/.config/flake/scripts/just-provision`
- Raycast: "Provision System" command
- OpenCode: `/provision` command

## Agent Usage

When an agent needs to ensure proper system state:

```
Use /provision <current-system> --heal to ensure system is properly configured.
```

## Exit Codes

| Code | Description |
| ---- | ----------- |
| 0 | Success |
| 1 | Failed |
| 2 | System unknown |

## AI-Powered Healing (--heal=ai)

### Healing Functions

| Function | Purpose |
| -------- | ------- |
| `detect_heal_model()` | Detects available AI model (local → remote → SSH) |
| `heal_ai()` | Runs AI-guided self-healing with 90s timeout |
| `escalate_to_ai()` | Classifies errors and routes to appropriate fix |
| `ssh_ai_escalation()` | Delegates AI healing to nebulanix via SSH |

### Model Detection Priority

1. **User override**: `--heal-model` flag
2. **Local Ollama**: localhost:11434
3. **Remote Ollama**: nebulanix.local:11434
4. **SSH delegation**: Run AI on nebulanix, sync changes back

### Error Classification

| Type | Detection | Handling |
| ---- | --------- | -------- |
| **Flake** | syntax error, parse error, attribute not found | AI fix via opencode |
| **Permission** | permission denied, read-only | Manual intervention required |
| **Network** | connection, timeout, dns | Auto-retry after 5s delay |
| **Machine** | nix-daemon, store corrupt, hash mismatch | System-level fixes |

### Git Change Handling

The `handle_pending_changes()` function provides interactive TUI (via gum):

1. **Auto-commit grouped** - Creates conventional commits by file type:
   - `chore(nix):` - Nix config files
   - `chore(scripts):` - Shell scripts
   - `docs:` - Documentation
   - `feat(ollama):` - Ollama templates
   - `chore(systems):` - System configs
   - `chore(modules):` - Nix modules
2. **Single commit** - All changes in one commit
3. **Stash** - Save changes for later
4. **Abort** - Cancel provision

### Retry Logic

Provision attempts are limited to 2 tries:
- **Attempt 1**: Standard provision
- **Attempt 2**: After AI healing (if `--heal=ai` enabled)

### Usage Examples

```bash
# Standard healing (automated fixes only)
just-provision spacehound --heal

# AI-powered healing
just-provision spacehound --heal=ai

# AI healing with specific model
just-provision nebulanix --heal=ai --heal-model qwen3-coder-tooled

# Dry-run with AI healing
just-provision --heal=ai --dry-run nebulanix
```

### SSH Delegation Flow

When local AI unavailable (e.g., on spacehound):

1. Verify SSH access to nebulanix.local
2. Fetch and checkout current branch on remote
3. Run AI healing on nebulanix
4. Commit and push changes
5. Pull changes back to local machine
