---
name: memory-snapshot
description: Traverse conversation threads and create snapshots of specific sections for future reference
compatibility: opencode
---

# Skill: memory-snapshot

## What I Do

Traverse and snapshot specific sections of conversation threads. Create named snapshots of any point in a thread that can be referenced later, even across sessions.

## When to Use Me

Use this skill when:
- Want to mark an important moment in conversation
- Need to save a decision or conclusion
- Want to reference a specific state later
- Creating a breadcrumb trail through complex investigation

## Commands

### Create Snapshot
```bash
memory-snapshot create <thread_id> <label> [description]
```
Example:
```bash
memory-snapshot create ollama-investigation "found-high-memory" "Memory spikes at 2GB during model load"
```

### List Snapshots
```bash
memory-snapshot list [thread_id]
```

### Show Snapshot
```bash
memory-snapshot show <snapshot_id>
```

### Compare Two Snapshots
```bash
memory-snapshot diff <snap1> <snap2>
```

### Delete Snapshot
```bash
memory-snapshot delete <snapshot_id>
```

### Export Snapshot
```bash
memory-snapshot export <snapshot_id> [--markdown]
```

## Usage Patterns

### Marking Investigation Milestones

```bash
# During investigation...
memory-snapshot create auth-refactor "started" "Beginning refactor of auth module"

# ... do some work ...
memory-snapshot create auth-refactor "api-changed" "Updated all API endpoints to v2"

# ... more work ...
memory-snapshot create auth-refactor "tests-passing" "All 47 tests passing"

# Later - view the journey
memory-snapshot list auth-refactor
# → Shows: started → api-changed → tests-passing
```

### Decision Recording

```bash
memory-snapshot create project-decision "choose-ollama" "Chose Ollama over Claude for local inference"
# Includes: reasoning, alternatives considered, trade-offs
```

### Export for Documentation

```bash
# Export a snapshot to markdown for enchiridion
memory-snapshot export project-decision --markdown > ~/config/flake/enchiridion/decisions/ollama-choice.md
```

## Snapshot Schema

```
working_memory_add: {
  content: "snapshot:<thread_id>:<label> - <description>",
  category: "snapshot",
  metadata: {
    thread_id: "<thread>",
    label: "<label>",
    description: "<description>",
    created: "timestamp",
    expires: "timestamp+7d"
  }
}
```

## Traversal Patterns

### Chronological View
```bash
memory-snapshot list <thread_id> | chronologically
```

### Latest First
```bash
memory-snapshot list <thread_id> | reverse
```

### Search Across All
```bash
memory-snapshot list | grep <keyword>
```

---
Signed: 2026-02-22
Author: @gabz
Version: 1.0.0
Verified: true
Maintainer: prismo
