---
name: memory-threads
description: Track multiple conversation threads in parallel using working-memory plugin
compatibility: opencode
---

# Skill: memory-threads

## What I Do

Manage multiple active conversation threads (investigations, tasks, parallel workstreams) in a single session. Each thread has status, priority, and summary.

## When to Use Me

Use this skill when:
- Handling multiple user requests in parallel
- Investigating multiple issues simultaneously
- Switching between different work contexts
- Keeping track of where you left off in each thread

## Commands

### Start/Update Thread
```bash
memory-threads start <thread_id> <summary> [priority]
```
Example:
```bash
memory-threads start ollama-investigation "Memory leak in Ollama server" high
memory-threads start auth-refactor "Refactoring auth module" medium
```

### Switch Active Thread
```bash
memory-threads switch <thread_id>
```

### List Threads
```bash
memory-threads list
```

### Show Current Thread
```bash
memory-threads current
```

### Update Thread Status
```bash
memory-threads status <thread_id> <status>
# status: active, paused, resolved, blocked
```

### Add Note to Thread
```bash
memory-threads note <thread_id> <note>
```

### Archive Thread
```bash
memory-threads archive <thread_id>
```

## Usage Pattern

```bash
# User asks about two things
memory-threads start ollama-investigation "Memory leak in Ollama"
memory-threads start auth-refactor "Refactor auth module"

# Switch to work on one
memory-threads switch ollama-investigation
# → Updates core memory goal to focus on this thread

# After some work, note findings
memory-threads note ollama-investigation "Found high memory in model loading"

# Pause and switch to other
memory-threads switch auth-refactor
# → Core memory now shows auth as active

# List all threads to see what's pending
memory-threads list
```

## Thread Schema

```
working_memory_add: {
  content: "thread_<id> - <summary>",
  category: "thread",
  metadata: {
    status: "active|paused|resolved|blocked|archived",
    priority: "high|medium|low",
    notes: [],
    created: "timestamp",
    updated: "timestamp"
  }
}
```

## Thread Priority Display

- 🔴 high - Do first, urgent
- 🟡 medium - Standard priority  
- 🟢 low - When time permits

---
Signed: 2026-02-22
Author: @gabz
Version: 1.0.0
Verified: true
Maintainer: prismo
