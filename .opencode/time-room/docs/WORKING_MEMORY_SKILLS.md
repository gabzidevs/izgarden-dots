# Working Memory Skills - Time Room Reference

This document exports the working-memory plugin skills for Time Room agents.

## Overview

The working-memory plugin provides persistent memory across OpenCode sessions. These skills wrap the plugin for common workflows: checkpoints, threads, delegation, recovery, and snapshots.

## Skills Summary

| Skill | Purpose | File |
|-------|---------|------|
| `memory-checkpoint` | Save-points before risky operations | `.opencode/skills/memory-checkpoint/` |
| `memory-threads` | Track multiple parallel conversations | `.opencode/skills/memory-threads/` |
| `memory-delegate` | Handover context to subagents | `.opencode/skills/memory-delegate/` |
| `memory-recover` | Recover after compaction | `.opencode/skills/memory-recover/` |
| `memory-snapshot` | Traverse and snapshot threads | `.opencode/skills/memory-snapshot/` |

---

## Quick Reference

### Core Tools (available directly)

```bash
# Update persistent goal/progress/context
opencode --tool core_memory_update '{"goal":"...","progress":"...","context":"..."}'

# Read current memory
opencode --tool core_memory_read

# Add working memory item
opencode --tool working_memory_add '{"content":"...","category":"..."}'

# Clear working memory
opencode --tool working_memory_clear

# Remove specific item
opencode --tool working_memory_remove '{"id":"..."}'
```

---

## Usage Patterns for Agents

### 1. Before Risky Operations (memory-checkpoint)

```bash
# Create safety checkpoint
memory-checkpoint save pre-refactor "Starting auth module changes"
# → Saves to working memory with category: checkpoint

# After operation, verify
memory-checkpoint verify
```

### 2. Parallel Conversations (memory-threads)

```bash
# Track multiple user requests
memory-threads start issue-123 "Fix memory leak" high
memory-threads start feature-456 "Add dark mode" medium

# Switch focus
memory-threads switch issue-123
# → Updates core memory goal

# List all
memory-threads list
```

### 3. Delegating to Subagents (memory-delegate)

```bash
# Parent prepares handover
memory-delegate pack gleeman "Implement OAuth2"
memory-delegate constrain "maintain backward compatibility"
memory-delegate files module/auth/oauth2.ts

# Show complete package
memory-delegate show

# Subagent reads:
# Use core_memory_read to understand the task
```

### 4. After Compaction (memory-recover)

```bash
# Check what survived
memory-recover check

# Identify gaps
memory-recover gaps

# Rebuild lost context
memory-recover rebuild "user wanted to switch from Claude to Ollama"
```

### 5. Snapshot Thread Milestones (memory-snapshot)

```bash
# Mark important points
memory-snapshot create auth-refactor "api-changed" "Updated to v2 API"
memory-snapshot create auth-refactor "tests-passing" "All tests passing"

# View journey
memory-snapshot list auth-refactor
# → Shows: started → api-changed → tests-passing

# Export for documentation
memory-snapshot export auth-refactor --markdown
```

---

## Category Schema

Working memory items use these categories:

| Category | Use For |
|----------|---------|
| `checkpoint` | Save-points before risky ops |
| `thread` | Conversation threads |
| `delegate` | Delegation packages |
| `delegate_constraint` | Delegation constraints |
| `delegate_files` | Delegation file lists |
| `snapshot` | Thread snapshots |
| `recovery` | Gap rebuilding |
| `test` | Health checks |

---

## What Survives Compaction

| Layer | Survives? |
|-------|------------|
| Core Memory (goal/progress/context) | ✅ Always |
| Working Memory (all categories) | ✅ Always |
| Memory Pressure Monitoring | ✅ Continues |
| Storage Governance | ✅ Auto-cleanup |

---

## File Locations

- Skills: `.opencode/skills/memory-*/`
- Usage Guide: `enchiridion/appendices/WORKING_MEMORY_USAGE.md`
- Agent Quick Ref: `.opencode/docs/WORKING_MEMORY_AGENT_REF.md`

---

## Related

- [WORKING_MEMORY_USAGE.md](../../../enchiridion/appendices/WORKING_MEMORY_USAGE.md)
- [PLUGIN_ANNOUNCEMENT.md](../PLUGIN_ANNOUNCEMENT.md)
