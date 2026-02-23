# Working Memory Plugin Usage

## Overview

`opencode-working-memory` is a four-tier memory architecture plugin for OpenCode that prevents context loss during compaction. It provides persistent memory across sessions, smart extraction of important information, and automatic storage governance.

## How It Works

### Four-Tier Architecture

1. **Core Memory** - Persistent blocks that survive compaction:
   - `goal` (1000 chars) - Current task/objective
   - `progress` (2000 chars) - What's done, in-progress, next steps
   - `context` (1500 chars) - Key file paths, conventions, patterns

2. **Working Memory** - Auto-extracted slots with guaranteed visibility:
   - Errors (stderr intercepts)
   - Decisions (tech choices, architecture)
   - Todos (pending tasks)
   - Dependencies
   - File paths (ranked by relevance with exponential decay)

3. **Memory Pressure Monitoring** - Real-time token tracking:
   - Moderate (75%) → warning
   - High (90%) → proactive intervention
   - Pressure-aware smart pruning

4. **Storage Governance** - Prevents disk bloat:
   - Max 300 files/session
   - 7-day TTL
   - Auto-cleanup on session deletion

## Setup

### Installation

Add to `~/.config/opencode/opencode.json`:

```json
{
  "plugin": ["opencode-working-memory"]
}
```

Restart OpenCode. Plugin auto-installs via Bun.

---

## Detection Mechanisms

### 1. Plugin Installation Check

```bash
ls ~/.bun/install/global/node_modules/ | grep working-memory
```

Expected output: `opencode-working-memory`

### 2. OpenCode Tool Verification

```bash
opencode --list-tools 2>/dev/null | grep -E "core_memory|working_memory"
```

Expected tools:
- `core_memory_update`
- `core_memory_read`
- `working_memory_add`
- `working_memory_clear`
- `working_memory_remove`

### 3. Runtime Detection via Natural Language

Use in conversation:
```
Check what memory tools are loaded
Show me your memory capabilities
```

The plugin responds to:
- "remember this" → triggers working_memory_add
- "save this" → triggers working_memory_add
- "what do you remember" → triggers core_memory_read
- "update my goal" → triggers core_memory_update

### 4. Session Database Check

```bash
ls ~/.local/share/opencode/working-memory/ 2>/dev/null || echo "No working-memory data yet"
```

---

## Health Check Tests

### Basic Health Check Script

```bash
#!/usr/bin/env bash
# health-check-working-memory.sh

echo "=== Working Memory Plugin Health Check ==="

echo -n "1. Plugin installed: "
if ls ~/.bun/install/global/node_modules/ 2>/dev/null | grep -q "opencode-working-memory"; then
    echo "✓ PASS"
else
    echo "✗ FAIL - run: ocx add npm:opencode-working-memory"
    exit 1
fi

echo -n "2. Tool registration: "
if opencode --list-tools 2>/dev/null | grep -q "core_memory_update"; then
    echo "✓ PASS"
else
    echo "✗ FAIL - restart OpenCode"
    exit 1
fi

echo -n "3. Write test (core_memory_update): "
TEST_GOAL="health-check-test-$(date +%s)"
if opencode --tool core_memory_update "{\"goal\":\"$TEST_GOAL\",\"progress\":\"\",\"context\":\"\"}" 2>/dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    exit 1
fi

echo -n "4. Read test (core_memory_read): "
if opencode --tool core_memory_read 2>/dev/null | grep -q "$TEST_GOAL"; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    exit 1
fi

echo -n "5. Working memory add test: "
TEST_ITEM="health-check-item-$(date +%s)"
if opencode --tool working_memory_add "{\"content\":\"$TEST_ITEM\",\"category\":\"test\"}" 2>/dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    exit 1
fi

echo -n "6. Cleanup test: "
if opencode --tool working_memory_clear 2>/dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    exit 1
fi

echo ""
echo "=== All Health Checks Passed ==="
```

### Quick Health Check Commands

```bash
# Single-line health verification
opencode --tool core_memory_update '{"goal":"health-check","progress":"","context":""}' \
  && opencode --tool core_memory_read | grep -q health-check \
  && echo "✓ Plugin operational" || echo "✗ Plugin failed"
```

---

## Agent Usage Patterns

### 1. Save-Points (Checkpointing)

Agents can create named save-points to resume complex tasks after compaction:

```
Use core_memory_update to set goal: Implement user authentication flow
Use working_memory_add to remember: checkpoint_auth_start - Started at module/user-auth.nix:45
```

**Save-point Schema:**
```
working_memory_add: {
  content: "checkpoint_<name> - <description>",
  category: "checkpoint",
  metadata: {
    file: "path/to/file",
    line: 123,
    timestamp: "2026-02-22T10:30:00Z"
  }
}
```

**Recovery Pattern:**
```
Use core_memory_read to see what checkpoints exist
Use working_memory_add to remember: resuming from checkpoint_auth_start
```

### 2. Conversation Thread Tracking

Track multi-turn investigations or parallel workstreams:

```
Use core_memory_update to set goal: Investigate memory leak in production
Use working_memory_add to remember: thread_ollama - oll doctor showed high memory
Use working_memory_add to remember: thread_migration - user wants to switch providers
Use working_memory_add to remember: thread_context - compaction happening frequently
```

**Thread Schema:**
```
working_memory_add: {
  content: "thread_<id> - <summary>",
  category: "thread",
  metadata: {
    participants: ["user", "agent"],
    status: "active|paused|resolved",
    priority: "high|medium|low"
  }
}
```

### 3. Referencing Memories

**Read all active threads:**
```
Use core_memory_read to show me the current goal and progress
```

**Search working memory:**
```
Use core_memory_read to find all items about ollama
```

**Selective reference in prompts:**
- "Based on our thread about ollama..." - references working memory
- "My current goal is..." - references core memory goal
- "What's the progress on..." - references core memory progress

### 4. Agent Delegation Pattern

When delegating to subagents, use memory as the handover mechanism:

```
# Parent agent before delegation:
Use core_memory_update to set goal: Complete refactoring of auth module
Use working_memory_add to remember: delegating to gleeman for implementation
Use working_memory_add to remember: constraints: must preserve API compatibility
Use working_memory_add to remember: files: module/auth.nix, tests/auth.test.ts

# Subagent starts with:
Use core_memory_read to understand the current task
Use working_memory_add to remember: constraints from parent: preserve API compatibility
```

### 5. Compaction Safety Protocol

Before triggering potentially destructive operations:

```
# Create safety checkpoint
Use working_memory_add to remember: safety_checkpoint_before_refactor - all tests passing
Use working_memory_add to remember: can_rollback_to: git commit abc123
```

After compaction, verify state:
```
Use core_memory_read to confirm goal survived compaction
```

### 6. Long-Running Task Progress

Track multi-step tasks in core memory:

```
# At start:
Use core_memory_update to set goal: Migrate Ollama from nebulanix to local
Use core_memory_update to set progress: [ ] 1. Stop server on nebulanix [ ] 2. Export models [ ] 3. Import to local [ ] 4. Test

# After each step:
Use core_memory_update to set progress: [x] 1. Stop server on nebulanix [ ] 2. Export models [ ] 3. Import to local [ ] 4. Test
```

---

## Usage Patterns

### Available Tools

| Tool | Parameters | Purpose |
|------|-------------|---------|
| `core_memory_update` | `goal`, `progress`, `context` | Update persistent blocks |
| `core_memory_read` | (none) | Show current memory state |
| `working_memory_add` | `content`, `category?`, `metadata?` | Add item to working memory |
| `working_memory_clear` | (none) | Clear all working memory |
| `working_memory_remove` | `id` | Remove specific item |

### Example Commands

```
Use core_memory_update to set my current goal
Use core_memory_read to show me what you remember
Use working_memory_add to remember this file path
```

### Manual Triggers

The plugin also intercepts natural language triggers:
- "remember this"
- "save this"

---

## Team Knowledge Sharing

### Current Limitations

**The plugin is per-user, per-machine:**
- Memories stored in local session database
- Not shared across team members
- Not synced to central storage
- Each user sees only their own memory

### For Team Knowledge (Townhall, Decisions)

**Not recommended for shared team memories.** The plugin solves a different problem (individual session continuity).

**Recommended alternatives:**
1. **Enchiridion appendices** - This repo's existing knowledge base
2. **Supermemory** (opencode-supermemory) - Cloud-synced, supports team spaces (Pro plan)
3. **opencode-mem** - Local vector DB, could share SQLite files manually

---

## Recommendations

### For Individual Session Continuity

Use `opencode-working-memory` - it excels at:
- Preventing context loss during compaction
- Remembering active files across resets
- Tracking goals/progress persistently

### For Shared Team Archive

Use **enchiridion appendices** instead:
- Version controlled
- Team-accessible
- Searchable
- Permanent

### Hybrid Approach

1. Use working-memory for session-level continuity
2. Use enchiridion for permanent team knowledge
3. Periodically migrate important memories to enchiridion

---

## Additional Resources

- GitHub: https://github.com/sdwolf4103/opencode-working-memory
- Requires: OpenCode >= 1.0.0, Node.js >= 18
