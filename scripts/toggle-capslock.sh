#!/usr/bin/env bash
# Toggle caps lock remapping between default (capslock) and escape
# Usage: ./scripts/toggle-capslock.sh [--silent]
#
# Options:
#   --silent    Suppress stdout (useful for Raycast integration)
#
# EXTENSION NOTES (for future):
# To add more states, modify the cycle_state function:
#   case "$1" in
#       "escape") echo "control" ;;  # Add control mode
#       "control") echo "hyper" ;;    # Add hyper mode via Karabiner
#       *) echo "capslock" ;;
#   esac

set -euo pipefail

# Check for silent mode (Raycast integration)
SILENT_MODE=false
if [[ ${1:-} == "--silent" ]]; then
  SILENT_MODE=true
fi

STATE_DIR="${HOME}/.local/share/izgarden"
STATE_FILE="${STATE_DIR}/capslock-state"

# Ensure directory exists
mkdir -p "$STATE_DIR"

# Read current state (from file or detect from system)
get_current_state() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    # Default from profile (escape for gabz)
    echo "escape"
  fi
}

# Two-state toggle
# EXTENSION: Add more states here when needed
cycle_state() {
  case "$1" in
  "escape") echo "capslock" ;;
  *) echo "escape" ;;
  esac
}

# Apply state to macOS
apply_state() {
  local state="$1"

  # Clear existing mappings
  defaults delete -g com.apple.keyboard.modifiermapping 2>/dev/null || true

  if [ "$state" = "escape" ]; then
    # 30064771113 = Escape key
    # 30064771129 = Caps Lock key
    defaults write -g com.apple.keyboard.modifiermapping -array-add '
        <dict>
            <key>HIDKeyboardModifierMappingDst</key>
            <integer>30064771113</integer>
            <key>HIDKeyboardModifierMappingSrc</key>
            <integer>30064771129</integer>
        </dict>'
  fi
  # "capslock" = no mapping (default behavior)
}

# Show macOS native notification (Tahoe compatible)
show_toast() {
  local state="$1"
  local message
  local icon="⌨️"

  case "$state" in
  "escape") message="Caps Lock → Escape (Vim mode)" ;;
  *) message="Caps Lock restored (default)" ;;
  esac

  # Use AppleScript to show notification with proper escaping
  # The 'tell application "System Events"' ensures notification shows even when run from Raycast
  osascript <<EOF
tell application "System Events"
    display notification "$message" with title "${icon} Keyboard Toggle"
end tell
EOF
}

# Main
main() {
  local current new_state

  current=$(get_current_state)
  new_state=$(cycle_state "$current")

  # Show current state before switching
  if [[ $SILENT_MODE == "false" ]]; then
    echo "Current: $current"
    echo "Switching to: $new_state"
  fi

  apply_state "$new_state"
  echo "$new_state" >"$STATE_FILE"

  # Always show notification with the NEW state
  show_toast "$new_state"

  if [[ $SILENT_MODE == "false" ]]; then
    echo "✓ State changed to: $new_state"
  fi
}

main "$@"
