# Time Room Dashboard V2 - Comprehensive Plan

> *"Welcome to the Time Room, friend! Everything's cosmic in here."* ✨

## Overview

This plan outlines improvements to the Time Room Dashboard using Charmbracelet tools for a smoother, more charming experience. The goal is a "cosmic but cozy" feel that matches the Adventure Time aesthetic.

---

## Problem Analysis

### Current Issues

| Issue | Impact | Priority |
|-------|--------|----------|
| **Zellij escape sequence sync** | Visual artifacts in floating panes | 🔴 High |
| **Only agent COUNT shown** | No individual agent status | 🔴 High |
| **Basic ASCII boxes** | Lacks charm/character | 🟡 Medium |
| **No user action highlights** | Phases 6-7 not clearly marked | 🟡 Medium |

---

## Solution Architecture

### 1. Zellij Sync Fix

**Root cause**: The `\033[2J\033[H` clear screen doesn't sync with zellij's rendering buffer.

**Solution**: Use synchronized update mode (DECSC mode):

```bash
# Zellij-safe clear and sync
zellij_safe_clear() {
    # Enter synchronized update mode (CSI ?2027h)
    printf '\033[?2027h'
    # Clear screen and home cursor
    tput clear 2>/dev/null || printf '\033[2J\033[H'
    # Optionally exit sync mode after render (uncomment if needed)
    # printf '\033[?2027l'
}

# Alternative: Use tput with reset
clear_screen() {
    tput reset 2>/dev/null || {
        printf '\033[?2027h'  # Enter sync mode
        printf '\033[2J\033[H'
    }
}
```

**CSI Escape Sequence Reference**:

| Sequence | Action | Notes |
|----------|--------|-------|
| `\033[?2027h` | Enter synchronized update | Prevents zellij artifacts |
| `\033[?2027l` | Exit synchronized update | Use after render |
| `\033[2J\033[H` | Clear + home | Fallback if tput fails |
| `\033[?1049h` | Alternate screen buffer | For full-screen apps |

---

### 2. Gum Integration Strategy

#### Available Gum Commands

```bash
# Install (if needed)
mise install gum        # via mise
brew install gum        # via homebrew

# Core commands we'll use:
gum style               # Styling text with borders, colors
gum spin                # Loading spinner
gum confirm             # Interactive confirmation
gum choose              # Interactive selection
gum input               # Interactive input
gum pager               # Scrollable content
gum table               # Table display
```

#### Gum Style Examples

```bash
# Basic styled box
gum style --border normal --border-foreground 212 "Hello, Time Room!"

# With padding and title
gum style \
  --border double \
  --border-foreground 99 \
  --padding "1 2" \
  --width 60 \
  "OLLAMA STATUS"

# Colored text
gum style --foreground 212 --bold "✨ Cosmic Text ✨"

# Multiple lines
gum style --border rounded --border-foreground 75 --padding "1 2" <<'EOF'
Status: Running
Model: qwen3:8b
Uptime: 42 minutes
EOF
```

#### Charmbracelet Color Palette

```bash
# Recommended colors (matching Charm style):
# 212  - Hot pink (primary accent)
# 99   - Purple
# 75   - Blue
# 228  - Yellow
# 40   - Green
# 196  - Red
# 254  - Light gray
# 240  - Dark gray
```

---

### 3. Agent Status Display

#### Agent Structure

Agents are stored in `$TIME_ROOM/agents/*.md`:

```
.time-room/
└── agents/
    ├── prismo.md      # Prismo - orchestrator
    ├── finn.md        # Finn - git
    ├── marceline.md   # Marceline - fundamentals
    ├── fern.md        # Fern - dotfiles
    ├── simon.md       # Simon - nix
    └── ...
```

#### Agent Status Extraction

```bash
get_agent_status() {
    local agent_file="$1"
    local name status last_active
    
    name=$(basename "$agent_file" .md)
    
    # Check for status markers in agent file
    if grep -q "STATUS.*ACTIVE" "$agent_file" 2>/dev/null; then
        status="active"
    elif grep -q "STATUS.*RESTING" "$agent_file" 2>/dev/null; then
        status="resting"
    elif grep -q "STATUS.*AWAY" "$agent_file" 2>/dev/null; then
        status="away"
    else
        status="idle"
    fi
    
    # Get last active (modified time as proxy)
    last_active=$(stat -f %Sm "$agent_file" 2>/dev/null | cut -d' ' -f1-4)
    
    echo "$name:$status:$last_active"
}

# Get all agents
get_all_agents() {
    local agents_dir="$TIME_ROOM/agents"
    [ -d "$agents_dir" ] || return
    
    for agent in "$agents_dir"/*.md; do
        [ -f "$agent" ] || continue
        get_agent_status "$agent"
    done
}
```

#### Agent Display Format

```bash
render_agent_card() {
    local name="$1"
    local status="$2"
    local last_active="$3"
    
    # Status icons and colors
    local icon color
    case "$status" in
        active)    icon="●" ; color="40" ;;  # Green
        resting)   icon="◐" ; color="228" ;; # Yellow
        away)      icon="○" ; color="196" ;; # Red
        idle)      icon="○" ; color="240" ;;  # Gray
    esac
    
    # Render with gum
    gum style \
        --border normal \
        --border-foreground "$color" \
        --padding "0 1" \
        --width 25 \
        "$icon $name" "$status" "Last: $last_active"
}

# Full agent panel
render_agents_panel() {
    local agents
    agents=$(get_all_agents)
    [ -z "$agents" ] && return
    
    echo "╭────────── AGENTS ──────────╮"
    while IFS=: read -r name status last_active; do
        local icon
        case "$status" in
            active)    icon="●" ;;
            resting)   icon="◐" ;;
            away)      icon="○" ;;
            idle)      icon="○" ;;
        esac
        printf "│ %s %-12s %-8s │\n" "$icon" "$name" "$status"
    done <<< "$agents"
    echo "╰────────────────────────────╯"
}
```

---

### 4. "Homier" Feel - Charmbracelet Aesthetic

#### Theme: Cosmic but Cozy

```bash
# Color scheme (Adventure Time inspired)
THEME_BG="clear"
THEME_PRIMARY="212"      # Hot pink - Prismo's realm
THEME_SECONDARY="99"     # Purple - the Nightosphere
THEME_ACCENT="228"       # Yellow - Finn's hat
THEME_SUCCESS="40"       # Green - Treehouse
THEME_WARNING="228"      # Yellow - caution
THEME_ERROR="196"        # Red - Fire Kingdom
THEME_DIM="240"          # Gray - Ice King

# Emojis for the Time Room
EMOJI_PRISMO="🔮"
EMOJI_FIRE="🔥"
EMOJI_STAR="⭐"
EMOJI_MOON="🌙"
EMOJI_DOG="🐕"
EMOJI_GUITAR="🎸"
EMOJI_SWORD="🗡️"
EMOJI_HEART="❤️"
EMOJI_SPARKLE="✨"
EMOJI_CLOUD="☁️"
```

#### Header with Charm Style

```bash
render_header() {
    clear
    printf '\033[?2027h'  # Enter sync mode
    
    gum style \
        --foreground 212 \
        --bold \
        --align center \
        --width 60 \
        "✨ PRISMO'S TIME ROOM ✨
        
The Cosmic Dashboard
        
Press Ctrl+C to exit | Auto-refresh: ${REFRESH_RATE}s"
    
    echo ""
}
```

#### Styled Status Display

```bash
render_ollama_status() {
    local status="$1"
    local model="$2"
    
    # Status color
    local status_color
    case "$status" in
        *RUNNING*) status_color="40" ;;  # Green
        *STARTING*) status_color="228" ;; # Yellow
        *STOPPED*) status_color="196" ;;  # Red
        *) status_color="240" ;;
    esac
    
    gum style \
        --border double \
        --border-foreground 99 \
        --padding "1 2" \
        --width 58 \
        "📺 THE TV - Ollama Status" \
        "" \
        "Status: $(gum style --foreground $status_color "$status")" \
        "Model: $model"
}
```

#### Loading Animation

```bash
# Use gum spin for loading states
gum spin --title "Summoning Prismo..." -- sleep 2

# Or with custom spinner
gum spin --title "Checking remote..." -- curl -s "$REMOTE_HOST/api/tags" > /dev/null
```

---

### 5. Phases 6-7 Highlights

Phases 6-7 are the user interaction points in the activation workflow (Phase 6 is the "migration" - restart). These need **clear visual emphasis**.

#### Phase Status Reference

```
Phase 1: Pull model to Nebulanix
Phase 2: Verify model integrity  
Phase 3: Stop Ollama on Nebulanix
Phase 4: Copy model to Spacehound
Phase 5: Start Ollama on Spacehound
Phase 6: Switch to local model      ← USER ACTION REQUIRED
Phase 7: Verify local functionality  ← USER ACTION REQUIRED
```

#### Highlighted Phase Display

```bash
render_phase_highlight() {
    local phase="$1"
    local name="$2"
    local status="$3"
    
    local border_fg="212"  # Default pink
    
    # Highlight phases 6-7
    if [[ "$phase" == "6" || "$phase" == "7" ]]; then
        border_fg="228"  # Yellow for action items
        
        gum style \
            --border thick \
            --border-foreground "$border_fg" \
            --padding "1 2" \
            --width 56 \
            "⚡ ACTION REQUIRED - Phase $phase ⚡" \
            "" \
            "$name" \
            "" \
            "Status: $status" \
            "" \
            "$(gum style --foreground 228 --bold '>>> Your attention needed! <<<')"
    else
        gum style \
            --border normal \
            --border-foreground "$border_fg" \
            --padding "1 2" \
            --width 56 \
            "Phase $phase: $name" \
            "Status: $status"
    fi
}
```

#### Server Status Panel

```bash
render_server_panel() {
    local current_phase="$1"
    local total_phases="$2"
    local model="$3"
    local host="$4"
    
    # Progress bar with gum
    local filled=$((current_phase * 20 / total_phases))
    local empty=$((20 - filled))
    local progress_bar=$(printf '█%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))
    
    # Label based on phase
    local label="ACTIVATION"
    if [[ "$current_phase" == "6" ]]; then
        label="MIGRATION (RESTART)"
    fi
    
    gum style \
        --border rounded \
        --border-foreground 99 \
        --padding "1 2" \
        --width 58 \
        "🔥 $label IN PROGRESS" \
        "" \
        "Model: $model" \
        "Host:  $host" \
        "" \
        "Progress: [$progress_bar] $current_phase/$total_phases" \
        ""
    
    # Highlight action phases
    if [[ "$current_phase" == "6" || "$current_phase" == "7" ]]; then
        gum style \
            --foreground 228 \
            --bold \
            --align center \
            "⚡ YOUR ACTION NEEDED: Phase $current_phase ⚡"
    fi
}
```

---

### 6. Complete Dashboard Implementation

Here's the improved dashboard script:

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
#  ✨ PRISMO'S TIME ROOM DASHBOARD v2.0 ✨
#  Cosmic but cozy - powered by gum!
# ═══════════════════════════════════════════════════════════════

TIME_ROOM="${TIME_ROOM:-$HOME/.config/flake/.opencode/time-room}"
SERVER_STATUS_FILE="$HOME/.local/state/ollama-server-status"
REFRESH_RATE="${REFRESH_RATE:-5}"
REMOTE_HOST="nebulanix.local:11434"

# Theme colors
C_PRIMARY="212"     # Hot pink
C_SECONDARY="99"    # Purple  
C_ACCENT="228"      # Yellow
C_SUCCESS="40"      # Green
C_ERROR="196"       # Red
C_DIM="240"         # Gray

# ─────────────────────────────────────────────────────────────────
# Zellij-safe rendering
# ─────────────────────────────────────────────────────────────────

zellij_safe_clear() {
    printf '\033[?2027h'  # Enter sync mode
    tput clear 2>/dev/null || printf '\033[2J\033[H'
}

# ─────────────────────────────────────────────────────────────────
# Agent functions
# ─────────────────────────────────────────────────────────────────

get_agents() {
    local agents_dir="$TIME_ROOM/agents"
    [ -d "$agents_dir" ] || { echo ""; return; }
    
    local agents=()
    for agent in "$agents_dir"/*.md; do
        [ -f "$agent" ] || continue
        local name
        name=$(basename "$agent" .md)
        
        # Check status (look for STATUS in file)
        local status="idle"
        if grep -q "STATUS.*ACTIVE" "$agent" 2>/dev/null; then
            status="active"
        elif grep -q "STATUS.*RESTING" "$agent" 2>/dev/null; then
            status="resting"
        fi
        
        agents+=("$name:$status")
    done
    
    printf '%s\n' "${agents[@]}"
}

render_agent_card() {
    local name="$1"
    local status="$2"
    
    local icon color
    case "$status" in
        active)  icon="●" ; color="$C_SUCCESS" ;;
        resting) icon="◐" ; color="$C_ACCENT" ;;
        away)    icon="○" ; color="$C_ERROR" ;;
        *)       icon="○" ; color="$C_DIM" ;;
    esac
    
    printf "  %s %-14s %s\n" "$icon" "$name" "$status"
}

# ─────────────────────────────────────────────────────────────────
# Status functions  
# ─────────────────────────────────────────────────────────────────

get_ollama_status() {
    if pgrep -f "ollama serve" &>/dev/null; then
        if curl -s --max-time 2 http://localhost:11434/api/tags &>/dev/null; then
            echo "RUNNING"
        else
            echo "STARTING"
        fi
    else
        echo "STOPPED"
    fi
}

get_active_model() {
    curl -s --max-time 2 http://localhost:11434/api/ps 2>/dev/null | \
        jq -r '.models[0].name // "none"'
}

get_remote_status() {
    if curl -s --max-time 2 "http://${REMOTE_HOST}/api/tags" &>/dev/null; then
        echo "Connected"
    else
        echo "Offline"
    fi
}

get_hostname() {
    hostname -s 2>/dev/null || echo "unknown"
}

is_nebulanix() { [[ "$(get_hostname)" == "nebulanix" ]]; }
is_spacehound() { [[ "$(get_hostname)" == "spacehound" ]]; }

# ─────────────────────────────────────────────────────────────────
# Server status (LLM activation)
# ─────────────────────────────────────────────────────────────────

get_server_status() {
    [ -f "$SERVER_STATUS_FILE" ] && cat "$SERVER_STATUS_FILE"
}

is_activation_in_progress() {
    local status
    status=$(get_server_status)
    [ -z "$status" ] && return 1
    echo "$status" | jq -e '.phases | to_entries[] | select(.value.status == "in_progress")' &>/dev/null
}

render_server_progress() {
    local status
    status=$(get_server_status)
    [ -z "$status" ] && return
    
    local current_phase total model host current_name
    current_phase=$(echo "$status" | jq -r '.current_phase // 0')
    total=$(echo "$status" | jq '.phases | length')
    model=$(echo "$status" | jq -r '.model // "unknown"')
    host=$(echo "$status" | jq -r '.host // "unknown"')
    current_name=$(echo "$status" | jq -r ".phases[\"$current_phase\"].name // \"Unknown\"")
    
    # Progress bar
    local complete
    complete=$(echo "$status" | jq '[.phases | .[] | select(.status == "complete")] | length')
    
    local bar_width=20
    local filled=$((complete * bar_width / total))
    local empty=$((bar_width - filled))
    local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null))$(printf '░%.0s' $(seq 1 $empty 2>/dev/null))
    
    # Render with gum - highlight action phases
    if [[ "$current_phase" == "6" || "$current_phase" == "7" ]]; then
        gum style \
            --border thick \
            --border-foreground "$C_ACCENT" \
            --padding "1 2" \
            --width 56 \
            "⚡ MIGRATION: ACTION NEEDED ⚡" \
            "" \
            "Phase: $current_name" \
            "Model: $model" \
            "Host: $host" \
            "" \
            "Progress: [$bar] $complete/$total" \
            "" \
            "$(gum style --foreground "$C_ACCENT" --bold '>>> USER ACTION REQUIRED: Phase '$current_phase' <<<')"
    else
        gum style \
            --border rounded \
            --border-foreground "$C_SECONDARY" \
            --padding "1 2" \
            --width 56 \
            "🔥 MIGRATION IN PROGRESS" \
            "" \
            "Phase: $current_name" \
            "Model: $model" \
            "Host: $host" \
            "" \
            "Progress: [$bar] $complete/$total"
    fi
}

# ─────────────────────────────────────────────────────────────────
# Main render
# ─────────────────────────────────────────────────────────────────

render_dashboard() {
    zellij_safe_clear
    
    local hostname
    hostname=$(get_hostname)
    
    local role_indicator=""
    is_nebulanix && role_indicator=" [SERVER]"
    is_spacehound && role_indicator=" [CLIENT]"
    
    # Header
    gum style \
        --foreground "$C_PRIMARY" \
        --bold \
        --align center \
        --width 60 \
        "✨ PRISMO'S TIME ROOM ✨$role_indicator"
    
    echo ""
    echo "  📅 $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # Ollama Status
    local ollama_status remote_status active_model
    ollama_status=$(get_ollama_status)
    remote_status=$(get_remote_status)
    active_model=$(get_active_model)
    
    local status_color
    case "$ollama_status" in
        RUNNING)  status_color="$C_SUCCESS" ;;
        STARTING) status_color="$C_ACCENT" ;;
        STOPPED)  status_color="$C_ERROR" ;;
        *)        status_color="$C_DIM" ;;
    esac
    
    if is_nebulanix; then
        gum style \
            --border double \
            --border-foreground "$C_SECONDARY" \
            --padding "1 2" \
            --width 58 \
            "📺 THE TV - Ollama (Server Mode)" \
            "" \
            "Status: $(gum style --foreground "$status_color" "$ollama_status")" \
            "Model: $active_model"
    elif is_spacehound; then
        gum style \
            --border double \
            --border-foreground "$C_SECONDARY" \
            --padding "1 2" \
            --width 58 \
            "📺 THE TV - Ollama (Client Mode)" \
            "" \
            "Remote: $(gum style --foreground "$status_color" "$remote_status")" \
            "Local:  $(gum style --foreground "$status_color" "$ollama_status")"
    fi
    
    # Server status (if active)
    if is_activation_in_progress; then
        echo ""
        render_server_progress
    fi
    
    # System info
    local cpu_mem
    if [[ "$OSTYPE" == "darwin"* ]]; then
        cpu_mem=$(ps -A -o %cpu,%mem | awk '{cpu+=$1; mem+=$2} END {printf "%.0f%% / %.0f%%", cpu, mem}')
    else
        cpu_mem="N/A"
    fi
    
    echo ""
    gum style --foreground "$C_DIM" "  🖥️  $hostname | CPU/MEM: $cpu_mem"
    
    # Agent roster
    echo ""
    gum style \
        --border normal \
        --border-foreground "$C_PRIMARY" \
        --padding "1 1" \
        --width 58 \
        "🎭 AGENT ROSTER"
    
    local agents
    agents=$(get_agents)
    if [ -n "$agents" ]; then
        while IFS=: read -r name status; do
            render_agent_card "$name" "$status"
        done <<< "$agents"
    else
        gum style --foreground "$C_DIM" "  (no agents active)"
    fi
    
    # Quick actions
    echo ""
    gum style \
        --border normal \
        --border-foreground "$C_DIM" \
        --padding "0 2" \
        --width 30 \
        "⚡ QUICK ACTIONS" \
        "ollamactl status" \
        "ollama-optimize" \
        "connect-ollama"
    
    # Footer
    echo ""
    gum style \
        --foreground "$C_DIM" \
        --align center \
        "Press Ctrl+C to exit | Refresh: ${REFRESH_RATE}s"
    
    gum style \
        --foreground "$C_PRIMARY" \
        --bold \
        --align center \
        "✨ Have a cosmic time in the Time Room! ✨"
}

# ─────────────────────────────────────────────────────────────────
# Main loop
# ─────────────────────────────────────────────────────────────────

main() {
    trap 'zellij_safe_clear; echo "Dashboard closed. Farewell, friend!"; exit 0' INT TERM
    
    echo "Summoning Prismo's Dashboard..."
    sleep 1
    
    while true; do
        render_dashboard
        sleep "$REFRESH_RATE"
    done
}

main "$@"
```

---

### 7. OpenCode Skill Installation

#### Skill Structure

OpenCode skills should be placed in `.opencode/skills/` (or as defined in the AGENTS.md context). Since skills aren't currently defined, we'll create a skill definition file.

#### Creating the Skill

```bash
# Create skills directory
mkdir -p .opencode/skills

# Create skill definition
cat > .opencode/skills/time-room-dashboard.md <<'EOF'
# Time Room Dashboard Skill

> *"What do you wish for?"* - Prismo

## Overview

This skill provides commands for interacting with the Time Room Dashboard - a cosmic TUI for monitoring Ollama, agents, and server activation status.

## Available Actions

### Start Dashboard
```bash
scripts/time-room-dashboard
```

### Dashboard with Custom Refresh
```bash
REFRESH_RATE=2 scripts/time-room-dashboard
```

### Check Ollama Status
```bash
ollamactl status
```

### Check Server Status
```bash
cat ~/.local/state/ollama-server-status | jq
```

## Requirements

- **gum** - Charmbracelet styling (install via `mise install gum` or `brew install gum`)
- **jq** - JSON parsing
- **curl** - HTTP requests

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TIME_ROOM` | `~/.config/flake/.opencode/time-room` | Agent directory |
| `REFRESH_RATE` | `5` | Dashboard refresh interval (seconds) |
| `REMOTE_HOST` | `nebulanix.local:11434` | Remote Ollama host |

## Features

1. **Zellij-safe rendering** - Proper CSI escape sequences
2. **Agent status display** - Individual agent cards
3. **Server activation tracking** - Phase 6 ("migration"/restart) action highlights  
4. **Charmbracelet aesthetic** - Cosmic but cozy!

## Troubleshooting

### Garbled display in zellij?
Ensure you're using the latest version of the dashboard script with `zellij_safe_clear()`.

### Gum not found?
```bash
mise install gum
# or
brew install gum
```
EOF
```

#### Skill Installation Instructions

```bash
# Option 1: Copy skill file to opencode config
cp .opencode/skills/time-room-dashboard.md ~/.config/opencode/skills/

# Option 2: Add to AGENTS.md reference
# The skill will be auto-discovered from .opencode/skills/

# Verify skill is available
ls -la ~/.config/opencode/skills/
```

---

## Implementation Checklist

- [ ] **Phase 1**: Fix zellij sync with `printf '\033[?2027h'`
- [ ] **Phase 2**: Replace ASCII boxes with `gum style`
- [ ] **Phase 3**: Implement agent status display
- [ ] **Phase 4**: Add server status progress with Phase 6 (migration) highlights
- [ ] **Phase 5**: Style with Charmbracelet colors/emojis
- [ ] **Phase 6**: Create skill definition file
- [ ] **Phase 7**: Test in zellij floating pane
- [ ] **Phase 8**: Document in AGENTS.md

---

## Files to Modify/Create

| File | Action |
|------|--------|
| `scripts/time-room-dashboard` | Replace with v2 implementation |
| `.opencode/skills/time-room-dashboard.md` | Create skill definition |
| `.opencode/time-room/agents/*` | Add STATUS markers to agent files |

---

## Testing Checklist

- [ ] Dashboard renders in regular terminal
- [ ] Dashboard renders in zellij floating pane (no artifacts!)
- [ ] Agent status displays correctly
- [ ] Server activation Phase 6 (migration/restart) shows action highlight
- [ ] Gum commands work (style, spin, etc.)
- [ ] Ctrl+C exits cleanly
- [ ] Auto-refresh works

---

## 8. Agent Status Tracking Mechanism

### Problem

Currently the dashboard reads agent files but status is static - we can't tell if an agent is "active" (currently working), "resting" (idle but available), or "away" (unavailable).

### Research Findings

| Approach | Pros | Cons | Feasibility |
|----------|------|------|-------------|
| **Timestamp file** | Simple, automatic | No "active" state, only last-used | ✅ High |
| **Status command** | Explicit control | Manual, requires user action | ✅ High |
| **Task tool detection** | Automatic "active" | Can't detect which specific agent | ⚠️ Medium |
| **Hybrid** | Best of both worlds | Slightly more complex | ✅ Best |

### Recommended: Hybrid Approach

Combine timestamp tracking with explicit status markers:

#### 8.1 Timestamp Tracking

```bash
# Update timestamp when agent is "invoked" (referenced in conversation)
update_agent_activity() {
    local agent_name="$1"
    local timestamp_file="$TIME_ROOM/agents/.activity/${agent_name}.ts"
    
    mkdir -p "$TIME_ROOM/agents/.activity"
    date +%s > "$timestamp_file"
}

# Get last activity (in human-readable format)
get_agent_last_active() {
    local agent_name="$1"
    local timestamp_file="$TIME_ROOM/agents/.activity/${agent_name}.ts"
    
    if [ -f "$timestamp_file" ]; then
        local ts
        ts=$(cat "$timestamp_file")
        # Convert to relative time
        echo "$(date -j -f %s "$ts" +%H:%M 2>/dev/null || echo "unknown")"
    else
        echo "never"
    fi
}
```

#### 8.2 Explicit Status Command

```bash
#!/usr/bin/env bash
# scripts/agent-status - Set/query agent status

set_agent_status() {
    local agent="$1"
    local status="$2"  # active, resting, away, idle
    
    local agent_file="$TIME_ROOM/agents/${agent}.md"
    [ -f "$agent_file" ] || { echo "Agent not found: $agent"; return 1; }
    
    # Remove existing STATUS lines
    sed -i '' '/^STATUS:/d' "$agent_file"
    
    # Add new status
    echo "STATUS: $status ($(date '+%Y-%m-%d %H:%M'))" >> "$agent_file"
    
    echo "Agent $agent status set to: $status"
}

get_agent_status() {
    local agent="$1"
    local agent_file="$TIME_ROOM/agents/${agent}.md"
    
    grep "^STATUS:" "$agent_file" 2>/dev/null | cut -d: -f2- | xargs || echo "idle"
}
```

#### 8.3 Auto-Tracking via OpenCode Integration

When OpenCode references an agent file, update activity:

```bash
# In dashboard or a wrapper, detect when opencode is running
is_agent_active() {
    # Check if opencode process is running
    pgrep -f "opencode" &>/dev/null
}
```

#### 8.4 Agent Status Display

```bash
render_agent_with_status() {
    local agent_name="$1"
    local agent_file="$TIME_ROOM/agents/${agent_name}.md"
    
    # Get explicit status from file
    local status
    status=$(grep "^STATUS:" "$agent_file" 2>/dev/null | cut -d: -f2 | xargs)
    
    # Fallback to idle if not set
    status="${status:-idle}"
    
    # Get last activity timestamp
    local last_active
    last_active=$(get_agent_last_active "$agent_name")
    
    # Determine if currently active (opencode running + recent timestamp)
    if pgrep -f "opencode" &>/dev/null && [ "$last_active" != "never" ]; then
        local ts
        ts=$(cat "$TIME_ROOM/agents/.activity/${agent_name}.ts" 2>/dev/null)
        local now
        now=$(date +%s)
        local diff=$((now - ts))
        if [ "$diff" -lt 300 ]; then  # 5 minutes
            status="active"
        fi
    fi
    
    # Render based on status
    case "$status" in
        active)    icon="●" ; color="$C_SUCCESS" ;;
        resting)   icon="◐" ; color="$C_ACCENT" ;;
        away)      icon="○" ; color="$C_ERROR" ;;
        idle|*)    icon="○" ; color="$C_DIM" ;;
    esac
    
    printf "  %s %-14s %-8s (Last: %s)\n" "$icon" "$agent_name" "$status" "$last_active"
}
```

### Implementation Plan

1. **Create activity tracking directory**: `$TIME_ROOM/agents/.activity/`
2. **Create `agent-status` script** in `scripts/`
3. **Add timestamp update** to dashboard or a wrapper
4. **Update agent display** to show status + last active time
5. **Add status command** to skill definition

---

## 9. Interactive Input Approach

### Problem

The dashboard currently only displays information - there's no way to interact with it (e.g., run commands, change settings) from within the dashboard.

### Research Findings

| Approach | Pros | Cons | Zellij Compatible |
|----------|------|------|-------------------|
| **Bubble Tea** | Full interactive TUI | Requires Go, complex | ✅ Yes |
| **Gum interactive** | Simple, Charmbracelet | Blocks on input, clears screen | ⚠️ Partial |
| **Command queue** | Simple, non-blocking | Extra file I/O | ✅ Yes |
| **Split pane** | Native terminal | Requires manual setup | ✅ Yes |
| **Keybind mode** | Works well in zellij | Requires mode switching | ✅ Yes |

### Recommended: Command Queue + Split Pane Hybrid

For zellij floating pane setup, the best approach combines:

1. **Command queue file** - Dashboard watches a file for commands
2. **Optional split pane** - For users who want direct interaction

#### 9.1 Command Queue Approach

```bash
# Dashboard watches this file for commands
COMMAND_QUEUE="$HOME/.time-room/dashboard-commands"

# Process commands from queue
process_commands() {
    [ -f "$COMMAND_QUEUE" ] || return
    
    while read -r line; do
        [ -z "$line" ] && continue
        case "$line" in
            "ollamactl start")
                ollamactl start
                ;;
            "ollamactl stop")
                ollamactl stop
                ;;
            "refresh")
                # Force immediate refresh
                return
                ;;
            "exit")
                exit 0
                ;;
        esac
    done < "$COMMAND_QUEUE"
    
    # Clear queue after processing
    > "$COMMAND_QUEUE"
}

# In render loop:
render_dashboard() {
    zellij_safe_clear
    # ... render content ...
    process_commands
    sleep "$REFRESH_RATE"
}
```

#### 9.2 Quick Action Menu (Non-Interactive Display)

Since full interactive input is tricky in a refreshing TUI, provide "quick action" hints:

```bash
render_quick_actions() {
    gum style \
        --border normal \
        --border-foreground "$C_DIM" \
        --padding "0 2" \
        --width 30 \
        "⚡ QUICK ACTIONS" \
        "" \
        "echo 'ollamactl start' > ~/.time-room/dashboard-commands" \
        "echo 'refresh' > ~/.time-room/dashboard-commands" \
        "echo 'exit' > ~/.time-room/dashboard-commands"
}
```

#### 9.3 Split Pane Setup (Alternative)

For users who want true interactivity:

```bash
# In zellij, create a layout with display + command pane
# ~/.config/zellij/layouts/dashboard.kdl

layout {
    pane size=1 borderless {
        command "time-room-dashboard"
    }
    pane {
        // Command input pane
    }
}
```

#### 9.4 Bubble Tea (Future Enhancement)

For a full interactive TUI, consider migrating to Bubble Tea (Go):

```go
// Conceptual Bubble Tea model for dashboard
type model struct {
    agents     []Agent
    ollamaStatus string
    // ... other state
}

func (m model) View() string {
    // Render with lipgloss styling
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
    // Handle keyboard input
    // Respond to menu selections
}
```

**Pros**: Full interactive control, menus, inputs
**Cons**: Requires Go, significant rewrite
**Best for**: v3 if more interactivity needed

### Implementation Plan

1. **Create command queue directory**: `$HOME/.time-room/`
2. **Add `process_commands` function** to dashboard
3. **Document quick actions** in dashboard footer
4. **Provide helper script** for writing commands:
   ```bash
   # scripts/dashboard-cmd
   echo "$1" > "$HOME/.time-room/dashboard-commands"
   ```

---

## 10. Implementation Checklist

### Agent Status Tracking
- [ ] Create `$TIME_ROOM/agents/.activity/` directory
- [ ] Create `scripts/agent-status` script
- [ ] Add timestamp update mechanism
- [ ] Update dashboard to show status + last active
- [ ] Document in skill definition

### Interactive Input
- [ ] Create command queue file setup
- [ ] Add `process_commands` to dashboard
- [ ] Create `scripts/dashboard-cmd` helper
- [ ] Document quick actions
- [ ] Test in zellij floating pane

---

*"Everything stays in the Time Room... but the dashboard gets better!"* ✨

> **Next Step**: Execute the implementation plan!
