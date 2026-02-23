---
name: spawn-dashboard
description: Spawn the Time Room Dashboard with multiple layout options - floating, split tab, or compact pane
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: monitoring
---

## What I Do

Spawn Prismo's Time Room Dashboard with multiple rendering options for live system monitoring.

## When to Use Me

Use this skill when you need to:
- Display the Time Room Dashboard for monitoring
- Show live Ollama/system status
- Choose between floating, split, or compact views

## Layout Options

### Mode 1: Floating Dashboard (Default)
Maximized floating pane with all components.
```bash
spawn-dashboard
# or
spawn-dashboard --floating
```

### Mode 2: Split View (Recommended)
Split tab layout with agents on left, Ollama + system on right.
```bash
spawn-dashboard --split
```

### Mode 3: Compact
Quick status in current pane/tab.
```bash
spawn-dashboard --compact
```

## How to Invoke

### Option 1: Script (Recommended)
```bash
spawn-dashboard [mode] [refresh]
```

### Option 2: Zellij Layout
```bash
zellij action new-tab --layout time-room
```

### Option 3: Direct Zellij
```bash
zellij run --floating --width 100% --height 100% --name "time-room" -- time-room-dashboard
```

## Arguments

| Argument | Short | Description | Default |
|----------|-------|-------------|---------|
| `--floating` | `-f` | Floating maximized pane | ✓ |
| `--split` | `-s` | Split tab layout | - |
| `--compact` | `-c` | Compact in current pane | - |
| `--refresh` | `-r` | Refresh rate in seconds | 5 |

## Zellij Keybind

If configured (Ctrl+d):
```bash
Ctrl+d  # Launch Time Room layout
```

## Layout Structure

### Split View
```
┌─────────────────────────────────────────┐
│ [Status Bar]                             │
├─────────────┬───────────────────────────┤
│ AGENTS      │  OLLAMA STATUS            │
│ (40%)      │  (60%)                   │
│             ├───────────────────────────┤
│ agent-tasks │  SYSTEM INFO              │
│ dashboard   │  (thermal)               │
└─────────────┴───────────────────────────┘
```

## Components

| Component | Command | Refresh |
|-----------|---------|---------|
| Agent Tasks | `agent-tasks-dashboard` | Manual |
| Ollama Status | `ollamactl status` | 5s |
| System Info | `ollama-sysopt --thermal` | 5s |

## Notes

- Requires `zellij` to be running
- Requires `time-room-dashboard` and `agent-tasks-dashboard` scripts in PATH
- Split mode requires the `time-room.kdl` layout file
- Default refresh rate is 5 seconds
