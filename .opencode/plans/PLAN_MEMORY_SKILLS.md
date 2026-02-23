# Plan: Memory Skills Proposals

**Author:** Jake  
**Status:** Draft  
**Target:** Prismo for approval  
**Date:** 2026-02-22

---

## Overview

Four memory skill proposals need specification before implementation. This document specifies each proposal's scope, CLI interface, data structures, and integration points.

---

## Proposal 1: `memory-export`

### Purpose

Batch export threads to time-room for long-term archival and cross-session reference.

### What Exactly It Does

- Reads all active/completed threads from working memory
- Exports to JSON or Markdown format
- Writes to time-room directory structure
- Generates index files for easy lookup

### CLI Commands

```bash
# Export all threads to time-room (auto-format detection)
memory export

# Export specific thread to JSON
memory export thread <thread_id> --json

# Export to markdown with full context
memory export thread <thread_id> --markdown

# Export all threads since a date
memory export --since 2026-02-15

# Export with custom destination
memory export thread <thread_id> --output /path/to/time-room/exports/

# Dry-run (show what would be exported)
memory export --dry-run
```

### Data Sources & Outputs

| Source | Output |
|--------|--------|
| `core_memory_read` (all items) | `.opencode/time-room/enchiridion/exports/<date>/<thread_id>.md` |
| Thread metadata | `.opencode/time-room/enchiridion/exports/<date>/index.json` |

### Export Format

**Markdown (default):**
```markdown
---
exported: 2026-02-22T10:30:00Z
thread_id: ollama-investigation
status: active
---

# Thread: ollama-investigation

**Summary:** Memory leak investigation
**Priority:** high
**Created:** 2026-02-20
**Updated:** 2026-02-22

## Notes
- Found high memory in model loading
- Need to check Ollama server logs
```

**JSON:**
```json
{
  "exported": "2026-02-22T10:30:00Z",
  "thread": {
    "id": "ollama-investigation",
    "summary": "Memory leak investigation",
    "priority": "high",
    "status": "active",
    "notes": ["Found high memory in model loading"],
    "created": "2026-02-20T..."
  }
}
```

### Integration Points

- **Depends on:** `memory-threads` for thread data
- **Uses:** `core_memory_read` tool
- **Writes to:** `.opencode/time-room/enchiridion/exports/`

### Decision Points

1. **Format:** JSON or Markdown? → Recommend Markdown (human-readable, fits time-room)
2. **Location:** `enchiridion/exports/` or `docs/exports/`? → `enchiridion/exports/` (archive-style)
3. **Auto-naming:** Use thread_id or generate UUID? → thread_id (user-friendly)

### Risks

- Large threads could create huge files → Add size limit (warn > 100KB)
- Duplicate exports → Add `--force` flag to overwrite

---

## Proposal 2: `memory-link`

### Purpose

Connect related threads with cross-references, tags, and relationships.

### What Exactly It Does

- Creates bidirectional links between threads
- Supports tagging for grouping
- Enables querying by relationship/tag
- Stores links in working memory metadata

### CLI Commands

```bash
# Link two threads together
memory link add <thread_a> <thread_b> [relationship]
# relationship: relates-to, blocks, depends-on, duplicate-of

# Add tags to a thread
memory link tag <thread_id> <tag1> [tag2] ...
# Example: memory link tag ollama-investigation ollama performance bug

# List threads with a specific tag
memory link find --tag <tag_name>

# Find related threads
memory link related <thread_id>

# Remove a link
memory link rm <thread_a> <thread_b>

# Remove tag from thread
memory link untag <thread_id> <tag>

# Show all links for a thread
memory link show <thread_id>
```

### Data Sources & Outputs

| Input | Storage |
|-------|---------|
| Thread relationships | Working memory metadata: `links: [{thread_id, relationship}]` |
| Tags | Working memory metadata: `tags: ["tag1", "tag2"]` |

### Schema Extension

```json
{
  "category": "thread",
  "content": "thread_ollama-investigation - Memory leak investigation",
  "metadata": {
    "status": "active",
    "priority": "high",
    "tags": ["ollama", "performance", "bug"],
    "links": [
      {"thread_id": "ollama-refactor", "relationship": "depends-on"},
      {"thread_id": "model-loading", "relationship": "relates-to"}
    ]
  }
}
```

### Integration Points

- **Depends on:** `memory-threads` (operates on existing threads)
- **Uses:** `core_memory_update` tool
- **No new files:** All data stays in working memory

### Decision Points

1. **Relationship types:** Predefined set or extensible? → Predefined + freeform allowed
2. **Circular links:** Allow? → Yes, but warn on `find --tag` if circular detected

### Risks

- Tag explosion (too many tags) → Add `memory link stats` for overview
- Orphan links (deleted thread still referenced) → Validate on read

---

## Proposal 3: `memory-auto`

### Purpose

Auto-checkpoint on file changes during editing sessions.

### What Exactly It Does

- Watches specified directories for file changes
- Creates automatic checkpoints before significant changes
- Debounces rapid changes to avoid storage bloat
- Enforces size limits and cleanup policies

### CLI Commands

```bash
# Enable auto-checkpoint for current session
memory auto enable [path1] [path2]
# Defaults to project root if no paths specified

# Disable auto-checkpoint
memory auto disable

# Check status
memory auto status

# Show auto-created checkpoints
memory auto list

# Restore from auto-checkpoint
memory auto restore <checkpoint_id>

# Set debounce interval (seconds)
memory auto config --debounce 30

# Set max checkpoints (oldest deleted when exceeded)
memory auto config --max 10

# Set max checkpoint size (KB)
memory auto config --max-size 500
```

### How It Works

```
[File Change Detected]
        ↓
   [Debounce Timer] ←── (default 30s)
        ↓
[Create Checkpoint]
        ↓
[Check Size Limit] ──→ [Delete Oldest if > max]
        ↓
[Store in Memory]
```

### Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| debounce | 30s | Wait between checkpoints |
| max | 10 | Maximum auto-checkpoints to keep |
| max-size | 500KB | Warn if checkpoint exceeds this |

### Data Sources & Outputs

| Source | Output |
|--------|--------|
| File system (fswatch/inotify) | Working memory: category "auto-checkpoint" |
| Config | `.opencode/config/memory-auto.json` |

### Integration Points

- **Depends on:** `memory-checkpoint` (uses checkpoint infrastructure)
- **Uses:** `fswatch` or `watchman` (external tool)
- **Writes config:** `.opencode/config/memory-auto.json`

### Prismo's Concerns Addressed

| Concern | Mitigation |
|---------|------------|
| Storage bloat | `--max` limit (default 10), oldest deleted |
| Rapid changes | `--debounce` defaults to 30s |
| Large checkpoints | `--max-size` warning at 500KB |
| Noise | Only checkpoints on significant changes (not temp files) |

### Decision Points

1. **Watch tool:** `fswatch` (macOS/Linux) or `watchman`? → `fswatch` (simpler, available via brew)
2. **Significant changes:** What qualifies? → `.gitignore` patterns + explicit extensions
3. **Restore behavior:** Replace files or show diff? → Show diff + confirm

### Risks

- Watch tool not installed → Show error with install instructions
- Checkpoint during merge conflict → Skip if `.git/MERGE_HEAD` exists
- Disk full → Graceful degradation, log warning

---

## Proposal 4: `memory-oll`

### Purpose

Integration between memory system and Ollama (LLM operations).

### What Exactly It Does

- Switch models based on memory context
- Show Ollama status relevant to current thread
- Run prompts with context from memory
- Auto-select model based on task type

### CLI Commands

```bash
# Show Ollama status relevant to current context
memory oll status

# Suggest model for current thread
memory oll suggest

# Switch model based on thread priority
memory oll connect [model]

# Run prompt with memory context injected
memory oll ask "<prompt>" [--include-thread] [--include-goal]

# Auto-select model and run
memory oll run "<prompt>"

# Show recent prompts from memory
memory oll history

# Configure auto-model rules
memory oll config --rule "high priority → qwen2.oder"
```

### Auto5-c-Model Rules

```json
{
  "rules": [
    {"priority": "high", "model": "qwen2.5-coder:14b"},
    {"priority": "medium", "model": "llama3.3:70b"},
    {"priority": "low", "model": "llama3.2:3b"},
    {"tags": ["code", "debug"], "model": "qwen2.5-coder:14b"},
    {"tags": ["write", "docs"], "model": "llama3.3:70b"}
  ]
}
```

### Data Sources & Outputs

| Source | Output |
|--------|--------|
| Current thread priority/tags | Model suggestion |
| `oll status` | Parsed and filtered status |
| Config | `.opencode/config/memory-oll.json` |

### Context Injection

When running `memory oll ask`:

```
=== Current Context ===
Thread: ollama-investigation
Goal: Find memory leak source
Progress: Found high memory in model loading
Tags: ollama, performance
=========================

User prompt: <prompt>
```

### Integration Points

- **Depends on:** `memory-threads` (reads priority/tags)
- **Uses:** `oll` commands (existing script), `core_memory_read`
- **Writes config:** `.opencode/config/memory-oll.json`

### Decision Points

1. **Default behavior:** Auto-connect or manual? → Manual (`memory oll connect`), but `suggest` is auto
2. **Model availability:** What if suggested model not installed? → Fall back to default, warn user

### Risks

- Ollama not running → Show helpful error with `oll server start` suggestion
- Model not available → Fallback chain: suggested → default → ask user

---

## Implementation Order

### Phase 1: Foundation (Week 1)

1. **`memory-export`** - Simplest, no dependencies on new features
   - Exports existing data, immediate utility
   - Tests the waters, validates approach

2. **`memory-link`** - Extends existing threads, no new tools
   - Depends on `memory-threads` being stable
   - Low risk, high value for organization

### Phase 2: Automation (Week 2)

3. **`memory-auto`** - Requires external tool (fswatch)
   - Higher complexity, debounce logic
   - Addresses Prismo's storage concerns directly

4. **`memory-oll`** - Integration with existing system
   - Depends on `oll` being stable
   - Cross-system concern, last to avoid blocking

---

## File Structure Summary

```
.opencode/
├── skills/
│   ├── memory-export/
│   │   ├── SKILL.md
│   │   └── memory-export.sh
│   ├── memory-link/
│   │   ├── SKILL.md
│   │   └── memory-link.sh
│   ├── memory-auto/
│   │   ├── SKILL.md
│   │   └── memory-auto.sh
│   └── memory-oll/
│       ├── SKILL.md
│       └── memory-oll.sh
└── config/
    ├── memory-auto.json    # debounce, max, max-size
    └── memory-oll.json     # auto-model rules
```

---

## Open Questions for Prismo

1. **memory-export:** Markdown index or separate JSON index file?
2. **memory-link:** Allow custom relationship types beyond predefined set?
3. **memory-auto:** Should we use `fswatch` or `watchman`? (fswatch simpler)
4. **memory-oll:** Should `memory oll connect` auto-run after switch?

---

*Ready for review! 🎸*
