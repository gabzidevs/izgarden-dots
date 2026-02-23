---
name: memory-delegate
description: Handover context to subagents using working-memory plugin for seamless delegation
compatibility: opencode
---

# Skill: memory-delegate

## What I Do

Package current context (goal, progress, constraints, files) for delegation to subagents. Ensures subagents have all context needed without re-explaining.

## When to Use Me

Use this skill when:
- Delegating to a subagent (finn, jake, simon, fern, etc.)
- Creating a handover package for another agent
- Passing work to a human with full context
- Saving state for later resumption

## Commands

### Create Delegation Package
```bash
memory-delegate pack <agent> <task_summary>
```
Example:
```bash
memory-delegate pack gleeman "Implement user authentication"
```

### Add Constraints
```bash
memory-delegate constrain <constraint>
```
Example:
```bash
memory-delegate constrain "must preserve API compatibility"
memory-delegate constrain "use existing test framework"
```

### Add Files
```bash
memory-delegate files <file1> [file2] ...
```
Example:
```bash
memory-delegate files module/auth.nix tests/auth.test.ts
```

### Show Package
```bash
memory-delegate show
```

### Clear Package
```bash
memory-delegate clear
```

### Quick Pack + Hand Off
```bash
memory-delegate handover <agent> <task_summary>
```
Combines pack + constraints + show in one command.

## Usage Pattern

```bash
# Parent agent preparing to delegate:
memory-delegate pack gleeman "Implement OAuth2 flow"
memory-delegate constrain "maintain backward compatibility"
memory-delegate constrain "follow existing error handling patterns"
memory-delegate files module/auth/oauth2.nix module/auth/providers/

# Show the complete package
memory-delegate show

# Now invoke the subagent with instructions to read memory
# Subagent starts by reading:
# Use core_memory_read to understand the task
```

## Handover Schema

```
working_memory_add: {
  content: "delegate_to:<agent> - <task>",
  category: "delegate",
  metadata: {
    task: "<task_summary>",
    constraints: ["<c1>", "<c2>"],
    files: ["<f1>", "<f2>"],
    from: "<parent_agent>",
    created: "timestamp"
  }
}
```

## Subagent Start

When receiving a delegation, always run:

```bash
# First, understand the task
Use core_memory_read to understand the current task

# Then check for delegation specifics  
Use core_memory_read to find any constraints
```

The delegation package is stored in working memory, surviving compaction.

---
Signed: 2026-02-22
Author: @gabz
Version: 1.0.0
Verified: true
Maintainer: prismo
