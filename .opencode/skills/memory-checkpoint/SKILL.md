---
name: memory-checkpoint
description: Create and manage save-points before risky operations using working-memory plugin
compatibility: opencode
---

# Skill: memory-checkpoint

## What I Do

Create named save-points that agents can reference after compaction or context loss. Used before risky operations (refactoring, migrations, destructive edits) to ensure safe rollback.

## When to Use Me

Use this skill when:
- About to perform a risky refactor
- Starting a migration operation
- Making multiple file changes in parallel
- Any operation where you might need to rollback

## Commands

### Create Save-Point
```bash
memory-checkpoint save <name> [description]
```
Example:
```bash
memory-checkpoint save auth-refactor "Starting auth module refactor"
```

### List Checkpoints
```bash
memory-checkpoint list
```

### Restore Info
```bash
memory-checkpoint info <name>
```

### Delete Checkpoint
```bash
memory-checkpoint delete <name>
```

### Verify After Compaction
```bash
memory-checkpoint verify
```

## Usage Pattern

```bash
# Before risky work
memory-checkpoint save pre-auth-refactor "Files: module/auth.nix, tests/auth.test.ts"

# Do the work...
# (compaction happens)

# After compaction - verify what we were doing
memory-checkpoint verify
# → Shows goal, progress, and checkpoint info

# If needed, check what files were involved
memory-checkpoint info pre-auth-refactor
```

## Internals

- Uses `working_memory_add` with category: "checkpoint"
- Stores: description, timestamp, associated files
- Core memory stores the current goal/progress
- Checkpoint survives compaction in working memory

---
Signed: 2026-02-22
Author: @gabz
Version: 1.0.0
Verified: true
Maintainer: prismo
