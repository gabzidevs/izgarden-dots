{
  config,
  ...
}:
let

  # Get the main user and their keyboard preference
  inherit (config.garden.system) mainUser;
  userCfg = config.home-manager.users.${mainUser};

  # Profile setting (default from user config)
  profileSetting = userCfg.garden.profiles.coding.keyboard.remapCapsLock or "none";

  # State file for toggle persistence
  stateFile = "/Users/${mainUser}/.local/share/izgarden/capslock-state";

  # Read state file if it exists, otherwise use profile setting
  # Using a simple shell command to check file existence and read
  stateFileExists = builtins.pathExists stateFile;
  remapStyle = if stateFileExists then builtins.readFile stateFile else profileSetting;
in
{
  system = {
    keyboard = {
      enableKeyMapping = true; # enable key mapping

      # Per-user caps lock remapping based on state file or profile preference
      # State file allows runtime toggling via scripts/toggle-capslock.sh
      remapCapsLockToControl = remapStyle == "control";
      remapCapsLockToEscape = remapStyle == "escape";

      # swap left command and left alt
      # disabled as it only causes problems
      swapLeftCommandAndLeftAlt = false;
    };

    defaults.NSGlobalDomain = {
      # Use F1, F2, etc. keys as standard function keys.
      "com.apple.keyboard.fnState" = true;

      AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.

      ApplePressAndHoldEnabled = false; # enable press and hold
      # If you press and hold certain keyboard keys when in a text area, the key's character begins to repeat.
      # This is very useful for vim users, they use `hjkl` to move cursor.
      # sets how long it takes before it starts repeating.
      InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
      # sets how fast it repeats once it starts.
      KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
    };
  };
}
