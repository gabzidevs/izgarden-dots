# OpenCode Plugin Categorization & Ecosystem Compatibility

> Comprehensive documentation of plugin categories, install methods, and ecosystem rationales
> Last Updated: 2026-02-20

---

## Installation Methods

| Method | Format | Use Case |
|--------|--------|----------|
| **OCX Native** | `kdco/worktree` | Plugins only available via OCX registry |
| **NPM via OCX** | `npm:package@version` | NPM plugins with superior features, managed via OCX |
| **NPM Direct** | `package-name` | Standard NPM plugins in opencode.json |

---

## Phase 1: Priority (Core Functionality)

### opencode-toolbox

| Attribute | Value |
|-----------|-------|
| **Install Method** | NPM via OCX |
| **OCX Command** | `ocx add npm:opencode-toolbox@0.10.4` |
| **Category** | MCP Tool Management |
| **Stars** | 10 |
| **Author** | assagman |

**Features:**
- "Tool search tool" pattern
- BM25 natural language search
- Regex pattern matching
- Reduces context by ~67k tokens

**OCX Equivalent:** None exists
**Rationale:** Unique architecture, no alternative

---

### opencode-working-memory

| Attribute | Value |
|-----------|-------|
| **Install Method** | NPM via OCX |
| **OCX Command** | `ocx add npm:opencode-working-memory` |
| **Category** | Memory Management |
| **Stars** | 28 |
| **Author** | sdwolf4103 |

**Features:**
- Four-tier architecture (Core → Working → Pruning → Pressure)
- Slot-based working memory (errors, decisions, todos, dependencies)
- Exponential decay pool (γ=0.85)
- Pressure monitoring (75% moderate → 90% high)
- Proactive interventions via promptAsync()
- Storage governance (300 file max, 7-day TTL)
- Sub-agent detection

**OCX Equivalents:**
- `oc-solomemory` - Basic persistence only
- `opencode-mem` - Vector DB (different approach)

**Rationale:** Superior four-tier architecture, no OCX equivalent matches features

---

### opencode-worktree

| Attribute | Value |
|-----------|-------|
| **Install Method** | OCX Native |
| **OCX Command** | `ocx add kdco/worktree` |
| **Category** | Worktree Management |
| **Stars** | 186 |
| **Author** | kdcokenny |

**Features:**
- Zero-friction git worktrees
- Auto-spawns terminals with OpenCode
- File synchronization (copyFiles, symlinkDirs)
- Lifecycle hooks (postCreate, preDelete)
- Cross-platform terminal detection (tmux priority!)
- Auto-commit and cleanup on delete

**NPM Equivalent:** None exists
**Rationale:** OCX-only plugin, canonical source

---

## Decision Matrix

| Plugin | NPM | OCX Native | Chosen | Why |
|--------|-----|------------|--------|-----|
| opencode-toolbox | ✅ | ❌ | npm: | Unique, no alternative |
| opencode-working-memory | ✅ | ❌ | npm: | Superior architecture |
| opencode-worktree | ❌ | ✅ | OCX | Only option |

---

## Phase 2+: Current Status

| Phase | Plugins | Install Method |
|-------|---------|----------------|
| Phase 2 | antigravity-auth, quota, notifier | NPM Direct |
| Phase 3 | snippets, type-inject, md-table-formatter | NPM Direct |
| Phase 4-6 | (disabled) | N/A |

---

## Testing Commands

### All Three Together
```bash
# Install all Phase 1 plugins via OCX
ocx add kdco/worktree
ocx add npm:opencode-toolbox@0.10.4
ocx add npm:opencode-working-memory

# Verify installation
ocx list
```

### Individual Testing
```bash
# Test worktree
"Create a worktree for feature/test-branch"
"Delete the current worktree"

# Test toolbox
toolbox_status({})
toolbox_search_bm25({ text: "file operations" })

# Test working-memory
core_memory_read({})
core_memory_update({ block: "goal", operation: "replace", content: "Testing" })
working_memory_add({ content: "Test item", type: "other" })
```

---

## Future Considerations

- Evaluate Phase 2 plugins for OCX migration (`kdco/notify`, `kdco/background-agents`)
- Consider `kit/ws` profile as alternative to individual plugins
- Monitor OCX ecosystem for memory plugin equivalents
