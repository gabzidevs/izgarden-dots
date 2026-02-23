---
name: provision
description: Self-healing host-aware provision script for nix-darwin
subtask: true
category: system
---

1. Detect hostname using: `hostname` (lowercase)
2. Map hostname to system: nebulanix → nebulanix, spacehound → spacehound
3. Execute: `~/.config/flake/scripts/just-provision <system> --heal`
4. Wait for provision to complete
5. Report success/failure

## AI-Powered Healing (--heal=ai)

The `--heal=ai` option provides intelligent error recovery for nix-darwin provisioning:

### Healing Flow

1. **Pre-flight diagnostics**: Runs `heal_common_issues` for fast automated fixes
2. **AI escalation**: If diagnostics fail, escalates to AI with 90s timeout
3. **Error classification**: Detects error type (flake, permission, network, machine)
4. **Retry logic**: Applies fixes and retries provision once

### Model Selection

Models are selected in priority order:

1. `--heal-model` flag override
2. Local Ollama (localhost:11434)
3. Remote Ollama (nebulanix.local:11434)
4. SSH delegation to nebulanix

**Recommended models:**
- `qwen3-tooled-small` (5.2GB) - Fast, general fixes
- `qwen3-coder-tooled` (18GB) - Complex flake errors

### Git Handling

If uncommitted changes are detected, `handle_pending_changes()` offers:

1. **Auto-commit (grouped)**: Creates conventional commits by file type
2. **Single commit**: All changes in one commit
3. **Stash**: Save changes for later
4. **Abort**: Cancel provision

### Usage Examples

```bash
# Use AI healing with default model
just-provision spacehound --heal=ai

# Override AI model
just-provision nebulanix --heal=ai --heal-model qwen3-coder-tooled

# Dry-run with healing
just-provision --heal=ai --dry-run nebulanix
```

### SSH Delegation

When AI is unavailable locally (e.g., on spacehound), healing automatically delegates to nebulanix:

1. SSH to nebulanix.local
2. Run AI healing there
3. Auto-commit and push changes
4. Pull changes back to local machine

### Error Types

- **Flake errors**: AI-fixable (syntax, missing attrs, broken imports)
- **Permission errors**: Manual fix required
- **Network errors**: Auto-retry after 5s delay
- **Machine errors**: System-level fixes required (nix store verify)

### Timeouts

- AI healing: 90s timeout per attempt
- SSH connection: 5s timeout
- Provision retry: 2 attempts max
