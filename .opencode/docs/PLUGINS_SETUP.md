# OpenCode Plugin Ecosystem Setup

> Documenting the plugin configuration for izgarden-dots — a copy, but different

---

## Overview

This document captures the OpenCode plugin ecosystem we've built. It's organized into phases based on priority, with each phase serving specific needs for our AI-assisted development workflow.

The plugin system is designed with flexibility in mind — allowing toggles between our custom setup and OMO-slim for those who prefer that path.

---

## Plugin Stack

### Phase 1: Priority (Core Functionality)

These plugins form the foundation — memory, parallelism, and MCP tool discovery. They're essential for effective AI assistance.

| Plugin | Purpose | Configuration |
|--------|---------|---------------|
| `opencode-mcp-tool-search` | Lazy-loads MCP tools on demand | `.opencode/plugins/mcp-tool-search.json` |
| `opencode-working-memory` | Four-tier memory: core + working + pressure monitoring + pruning | Auto-configured |
| `@csuwl/opencode-memory-plugin` | OpenClaw-style persistent memory | Different paradigm |
| `opencode-mem` | Fast memory access layer | Lightweight memory |
| `pocket-universe` | Lightweight parallelism for tasks | Task distribution |
| `opencode-worktree` | Git worktree integration | Worktree management |

**Why Phase 1 First?** Memory and parallelism are the biggest quality-of-life improvements. Without them, each session starts fresh and tasks run sequentially.

> **Note:** `opencode-working-memory` replaced `opencode-agent-memory` because it provides all the same Letta-style memory features PLUS pressure monitoring, storage governance, and smart pruning.

---

### Phase 2: Foundation (Free AI & Monitoring)

These plugins enable free AI access, token tracking, and notifications — the infrastructure layer.

| Plugin | Purpose | Configuration |
|--------|---------|---------------|
| `opencode-antigravity-multi-auth` | Multiple AI provider authentication | Auth providers |
| `opencode-quota` | Token usage tracking and quotas | Quota limits |
| `opencode-notify` | System notifications for events | Notification rules |

**Phase 2 Rationale:** Free AI access through multiple providers reduces costs. Token tracking ensures we stay within limits. Notifications keep us informed without constant monitoring.

---

### Phase 3: Efficiency (Developer Experience)

These plugins optimize the developer experience — TypeScript support, snippets, token savings, and formatting.

| Plugin | Purpose | Configuration |
|--------|---------|---------------|
| `opencode-type-inject` | TypeScript type injection | Type config |
| `opencode-snippets` | Reusable code snippets | Snippet library |
| `opencode-dynamic-context-pruning` | Reduces context bloat | Pruning rules |
| `opencode-md-table-formatter` | Markdown table formatting | Format presets |

**Phase 3 Rationale:** These are nice-to-haves that compound over time. TypeScript support improves code quality. Snippets speed up common patterns. Context pruning saves tokens on long conversations.

---

## OMO-Slim Compatibility Matrix

OMO-slim is an alternative framework that provides similar functionality through a different architecture. This matrix shows feature parity and trade-offs.

| Feature | OMO-Slim OFF (Current) | OMO-Slim ON |
|---------|------------------------|-------------|
| **Parallelism** | `pocket-universe` — lightweight task distribution | Omo-slim background agents — native async |
| **Memory** | `opencode-working-memory`, `@csuwl/opencode-memory-plugin`, `opencode-mem` | Omo-slim memory — unified memory system |
| **MCP Tools** | `opencode-mcp-tool-search` — lazy-load on demand | Omo-slim MCPs — native MCP integration |
| **Free AI** | `opencode-antigravity-multi-auth` | Omo-slim auth |
| **Notifications** | `opencode-notify` | Omo-slim notifications |
| **Agent Architecture** | Your AT agents stay as primary | Skills merge into AT agents |

### When to Use Each

**OMO-Slim OFF (Current Setup):**
- You want granular control over each component
- You prefer the AT agent character system
- You need specific plugins not available in OMO-slim

**OMO-Slim ON:**
- You want a unified, cohesive system
- You prefer less configuration overhead
- You're starting fresh without existing agent setup

---

## Configuration

### Toggling OMO-Slim

OMO-slim is controlled via environment variable or config flag:

```bash
# Enable OMO-slim
export OMO_SLIM_ENABLED=true

# Disable (default)
export OMO_SLIM_ENABLED=false
```

Or in your OpenCode config:

```json
{
  "omoSlim": {
    "enabled": false
  }
}
```

### Enabling/Disabling Phases

Phases can be toggled individually in the plugin configuration:

```json
{
  "plugins": {
    "phase1": {
      "enabled": true,
      "autoLoad": true
    },
    "phase2": {
      "enabled": true,
      "autoLoad": false
    },
    "phase3": {
      "enabled": false,
      "autoLoad": false
    }
  }
}
```

### System-Specific Settings

Different machines may have different requirements:

**Nebulanix** (192.168.1.10 — 48GB M4 Pro):
- Full Phase 1 + 2 enabled
- Phase 3 enabled for heavy coding sessions
- Higher parallelism allowed

**Spacehound** (18GB M3):
- Phase 1 enabled (memory critical)
- Phase 2 enabled (notifications useful)
- Phase 3 disabled to conserve resources

Configuration location: `.opencode/config/systems/{hostname}.json`

---

## Key Decisions

### 1. opencode-notify over Alternatives

**Chosen:** `opencode-notify`  
**Alternatives considered:** Native notifications, Slack integration, custom scripts

**Rationale:**
- Unified notification API across providers
- Built-in rate limiting and grouping
- Minimal configuration overhead
- Works with our existing notification preferences

---

### 2. opencode-quota over opencode-mystatus

**Chosen:** `opencode-quota`  
**Alternatives considered:** `opencode-mystatus`

**Rationale:**
- Proactive tracking vs reactive status
- Supports multiple AI providers
- Configurable alerts before limits hit
- Better for multi-provider setups

---

### 3. opencode-type-inject + opencode-dynamic-context-pruning instead of morph-fast-apply

**Chosen:** `opencode-type-inject` + `opencode-dynamic-context-pruning`  
**Alternatives considered:** `morph-fast-apply`

**Rationale:**
- Separation of concerns: types vs context
- `opencode-type-inject` provides type accuracy
- `opencode-dynamic-context-pruning` reduces token usage
- `morph-fast-apply` was too monolithic
- Better debuggability when issues arise

---

### 4. pocket-universe for Lightweight Parallelism

**Chosen:** `pocket-universe`  
**Alternatives considered:** Built-in task parallelism, custom implementation

**Rationale:**
- Minimal overhead
- Task queue with retry logic
- Works well for our use case (4-8 concurrent tasks)
- Easier to debug than custom solutions
- Active maintenance

---

### 5. Phase 1 Priority for Memory + Parallelism

**Chosen:** Phase 1 as the foundation  
**Rationale:**

Memory plugins provide the biggest immediate quality-of-life improvement:
- Sessions no longer start from scratch
- Context carries across conversations
- Agent-specific memory prevents interference

Parallelism enables:
- Running multiple verification steps
- Concurrent file operations
- Faster overall workflow

These two areas compound — memory stores results from parallel tasks, parallelism speeds up memory population.

---

## Configuration Files Reference

| File | Purpose |
|------|---------|
| `.opencode/config/default.json` | Default plugin configuration |
| `.opencode/config/systems/nebulanix.json` | Nebulanix-specific settings |
| `.opencode/config/systems/spacehound.json` | Spacehound-specific settings |
| `.opencode/plugins/mcp-tool-search.json` | MCP tool discovery config |
| `.opencode/plugins/memory.json` | Memory plugin settings |
| `.opencode/plugins/quota.json` | Token tracking limits |

---

## Maintenance

### Updating Plugins

```bash
# Check for updates
opencode plugin list --outdated

# Update specific plugin
opencode plugin update opencode-mem

# Update all
opencode plugin update --all
```

### Adding New Plugins

1. Install: `opencode plugin install <plugin-name>`
2. Configure: Add to appropriate phase in config
3. Test: Verify it loads correctly
4. Document: Update this file

### Removing Plugins

1. Disable: Remove from config or set `enabled: false`
2. Uninstall: `opencode plugin remove <plugin-name>`
3. Clean: Remove related config files

---

## Troubleshooting

### Plugin Not Loading

1. Check config syntax: `opencode config validate`
2. Check dependencies: `opencode plugin doctor`
3. Check logs: `opencode logs --plugin <name>`

### Memory Conflicts

If multiple memory plugins conflict:
```json
{
  "plugins": {
    "memory": {
      "backend": "opencode-mem",
      "fallback": "@csuwl/opencode-memory-plugin"
    }
  }
}
```

### Parallelism Issues

If tasks hang:
```json
{
  "plugins": {
    "pocket-universe": {
      "maxConcurrent": 4,
      "timeout": 30000
    }
  }
}
```

---

## Future Considerations

- **OMO-slim Migration Path:** Documented but not urgent
- **New Plugin Evaluation:** Use decision template from DECISIONS.md
- **Phase 4 Explorations:** AI model optimization, advanced context management

---

*Documenting the journey — each plugin a copy of something, but made different for our needs.*

---

**Last Updated:** 2026-02-20  
**Maintained By:** Fern (dotfiles specialist)
