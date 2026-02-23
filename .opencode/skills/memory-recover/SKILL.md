---
name: memory-recover
description: Recover context and verify state after compaction using working-memory plugin
compatibility: opencode
---

# Skill: memory-recover

## What I Do

Verify what context survived compaction, identify lost context, and help rebuild state. Critical for maintaining continuity after OpenCode compaction events.

## When to Use Me

Use this skill when:
- Compaction just happened (indicated by notification)
- Context feels lighter than before
- Need to verify what was lost/saved
- Starting a new session and need to resume previous work

## Commands

### Full Recovery Check
```bash
memory-recover check
```

### Show What Survived
```bash
memory-recover survived
```

### Identify Gaps
```bash
memory-recover gaps
```

### Rebuild Context
```bash
memory-recover rebuild <description>
```

### Emergency Save (Before Compaction)
```bash
memory-recover save
```

## Compaction Recovery Workflow

```bash
# After compaction notification:
memory-recover check

# This shows:
# - Current goal (should be preserved in core memory)
# - Progress (should be preserved)
# - Active threads from working memory
# - Checkpoints if any

# If something is missing:
memory-recover gaps

# Rebuild what was lost:
memory-recover rebuild "lost: previous progress was..."
```

## What Survives Compaction

| Layer | Survives? | Details |
|-------|------------|---------|
| Core Memory | ✅ Yes | goal, progress, context always preserved |
| Working Memory | ✅ Yes | Items persist unless manually cleared |
| Pressure Monitoring | ✅ Yes | Continues tracking |
| Storage Governance | ✅ Yes | Auto-cleanup continues |

## Emergency Save Protocol

Before triggering known compaction events (long context, many files):

```bash
# Create emergency checkpoint
memory-recover save
# → Saves: current goal, progress, active threads, key files
```

Then proceed with the operation. After compaction:
```bash
memory-recover check
```

## Gap Analysis

The skill identifies:
- Threads that were active but not in working memory
- Files that were being edited (not in context)
- Goals that may have been partially completed

## Recovery Message Template

After recovery, inform the user:

```
🔄 Compaction Recovery Complete

Goal: <current goal from core memory>
Progress: <progress from core memory>
Active threads: <count from working memory>
Checkpoints: <count from working memory>

[If gaps found:]
⚠️ Potential gaps detected:
- <gap 1>
- <gap 2>

Should I rebuild context for any of these?
```

---
Signed: 2026-02-22
Author: @gabz
Version: 1.0.0
Verified: true
Maintainer: prismo
