# Keyboard Toggle Setup

> Caps Lock remapping toggle for macOS (Tahoe compatible)

## Overview

Toggle between **Caps Lock** (default) and **Escape** (vim mode) with persistent state across rebuilds.

## Current Status

✅ **Implemented:** Two-state toggle (escape ↔ capslock)  
✅ **Persists:** State survives nix rebuilds  
✅ **Notifies:** Native macOS toast notifications  
✅ **Default:** Escape for gabz (mainUser)  

## Usage

### Option 1: Terminal
```bash
./scripts/toggle-capslock.sh
```

### Option 2: Raycast (Recommended)

**Setup:**
1. Open Raycast Preferences (⌘ + ,)
2. Go to "Extensions" → "Script Commands"
3. Click "+" → "Add Script Directory"
4. Select: `/Users/gabz/.config/flake/scripts`
5. Or add individual script command:
   - Name: "Toggle Caps Lock"
   - Script: `/Users/gabz/.config/flake/scripts/toggle-capslock.sh`
   - Icon: ⌨️
   - Alias: "caps"

**Usage:**
- Open Raycast (⌘ + Space)
- Type "Toggle Caps Lock" or "caps"
- Press Enter
- See toast notification

### Option 3: VIA Integration (Future)

When ready, bind a VIA macro key to execute:
```bash
/Users/gabz/.config/flake/scripts/toggle-capslock.sh
```

## How It Works

1. **Profile Default**: Set in `systems/*/users.nix`
   ```nix
   coding.keyboard.remapCapsLock = "escape";  # or "capslock"
   ```

2. **State File**: `~/.local/share/izgarden/capslock-state`
   - Created on first toggle
   - Overrides profile setting
   - Persists across rebuilds

3. **Nix Integration**: 
   - Keyboard module reads state file during build
   - Applies appropriate nix-darwin setting
   - Falls back to profile if no state file

4. **Toggle Script**:
   - Cycles between states
   - Updates state file
   - Shows macOS notification
   - Applies immediately via `defaults`

## Cycle Behavior

```
Current State → Toggle → New State
escape        → Toggle → capslock
              ← Toggle ←
```

Two-state cycle only. For more states, see extension notes in the script.

## Extension Notes

To add more states (e.g., control, hyper):

1. Edit `scripts/toggle-capslock.sh`:
   - Modify `cycle_state()` function
   - Add cases to `apply_state()`
   - Update `show_toast()` messages

2. Example for control mode:
   ```bash
   cycle_state() {
       case "$1" in
           "escape") echo "control" ;;
           "control") echo "capslock" ;;
           *) echo "escape" ;;
       esac
   }
   ```

## Future: Karabiner Integration

For complex mappings (escape on tap, hyper on hold):

1. Install Karabiner-Elements via homebrew
2. Create `home/gabz/core/karabiner.nix`
3. Remove nix-darwin keyboard remapping
4. Use Karabiner JSON config for complex rules

See `DECISIONS.md` for full context.

## Troubleshooting

**State not persisting?**
- Check: `cat ~/.local/share/izgarden/capslock-state`
- Should contain: `escape` or `capslock`

**No notification?**
- macOS may suppress notifications from scripts
- Check System Preferences → Notifications
- Grant permissions to Terminal/Script runner

**Changes not applying?**
- Some apps need restart to see key remapping
- System-wide changes should be immediate
- Try: `killall SystemUIServer` if needed

## Files

- Script: `scripts/toggle-capslock.sh`
- Config: `modules/darwin/hardware/keyboard.nix`
- State: `~/.local/share/izgarden/capslock-state`

---

*Part of the home/gabz cleanup initiative*  
*See also: DECISIONS.md for architectural decisions*
