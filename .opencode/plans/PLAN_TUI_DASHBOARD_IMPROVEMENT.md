# Time Room Dashboard TUI Improvement Plan

## Problem Analysis

### Current Issues
1. **Zellij wonkiness**: The `printf '\033[2J\033[H'` clear screen can cause artifacts in zellij floating panes
2. **Basic rendering**: Uses manual ASCII box drawing with hardcoded Unicode characters
3. **No agent details**: Just shows count, not status/details of each agent
4. **Alignment issues**: Hard to maintain consistent column widths

## Solution: Use `gum style` for Better Rendering

### Why Gum?
- Built by Charmbracelet (same ecosystem as zellij)
- Native border styles: `--border normal|double|thick|rounded|hidden`
- Proper terminal escape handling
- Color/formatting built-in
- Available in mise ecosystem

### Implementation Details

#### 1. Replace Box Drawing with `gum style`

```bash
# Current (manual):
draw_box() {
  printf "╔%s╗\n" "$(printf '%s' "$border_char" | head -c "$width")"
}

# With gum:
render_box() {
  local title="$1"
  gum style --border normal --border-foreground 212 \
    --align center --width 60 --padding "1 2" "$title"
}
```

#### 2. Better Zellij Compatibility

```bash
# Replace clear_screen with zellij-safe version:
clear_screen() {
  # Option 1: Use tput (more portable)
  tput clear 2>/dev/null || printf '\033[2J\033[H'
  
  # Option 2: Disable synchronized rendering for this script
  printf '\033[?2027s'  # Enter synchronized update mode
}

# Or disable in zellij config for floating panes
```

#### 3. Agent Status Display

```bash
# Get detailed agent status
get_agent_details() {
  local agents_dir="$TIME_ROOM/agents"
  if [ -d "$agents_dir" ]; then
    for agent in "$agents_dir"/*.md; do
      [ -f "$agent" ] || continue
      local name
      name=$(basename "$agent" .md)
      local status="idle"
      # Add logic to determine status
      echo "$name:$status"
    done
  fi
}

# Render with gum
render_agents() {
  local agents
  agents=$(get_agent_details)
  [ -z "$agents" ] && return
  
  echo "$agents" | while IFS=: read -r name status; do
    local icon="○"
    [[ "$status" == "active" ]] && icon="●"
    gum style --foreground 212 "  $icon $name"
  done
}
```

#### 4. Combined Dashboard Render

```bash
render_dashboard() {
  # Clear with zellij-safe method
  tput clear 2>/dev/null || printf '\033[2J\033[H'
  
  # Header
  gum style --foreground 212 --bold "✨ PRISMO'S TIME ROOM DASHBOARD ✨"
  echo ""
  
  # Status section
  gum style --border double --border-foreground 99 \
    --padding "1 2" --width 60 "OLLAMA STATUS"
  
  # System stats with gum table
  gum table --columns Name,Value -- \
    "Local Status" "$ollama_status" \
    "Active Model" "$active_model"
}
```

## Alternative: Use `boxes` + `lolcat`

If gum isn't available:

```bash
# Install: brew install boxes lolcat
echo "Status: RUNNING" | boxes -d diamond | lolcat
```

## Recommended Implementation Order

1. **Phase 1 - Zellij Fix**: Replace `\033[2J\033[H` with `tput clear`
2. **Phase 2 - Gum Integration**: Use `gum style` for headers and boxes
3. **Phase 3 - Agent Details**: Expand agent display with status indicators
4. **Phase 4 - Polish**: Add colors, animations with `gum spin`

## Quick Fix (Immediate)

```bash
# In time-room-dashboard, replace clear_screen:
clear_screen() {
  tput reset 2>/dev/null || {
    printf '\033[2J\033[H'
    # Add zellij sync escape
    printf '\033[?2027s'
  }
}
```

## Files to Modify
- `/Users/gabz/.config/flake/scripts/time-room-dashboard`

## Dependencies
- `gum` (charmbracelet) - available via mise or brew
- Optional: `boxes`, `lolcat` for alternatives
