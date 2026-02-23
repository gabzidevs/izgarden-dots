{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  # Nix ghostty package only supports Linux as of Feb 2026 (platforms list has no Darwin).
  # On Darwin, Ghostty is installed via Homebrew (conditionally in modules/darwin/brew/default.nix).
  # Setting package = null on Darwin lets home-manager still manage the config file.
  package = if isLinux then pkgs.ghostty else null;
in
{
  programs.ghostty = {
    inherit package;

    settings = {
      # ==========================================================================
      # Shell
      # ==========================================================================
      # Pin to nix-managed fish binary for reproducibility
      command = "${lib.getExe config.programs.fish.package}";

      # Shell integration: let ghostty auto-detect (was "none" due to a
      # misunderstanding about Neovim interplay - proven unrelated to Ghostty).
      # Valid features: cursor, sudo, title (ssh-env is NOT a valid value).
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";

      # ==========================================================================
      # Appearance
      # ==========================================================================
      background-opacity = 0.95;
      background-blur-radius = 20; # native blur behind transparent window (macOS/compositors)

      cursor-style = "bar";
      cursor-style-blink = true;

      font-family = config.garden.style.fonts.name;
      font-size = 13;
      font-thicken = isDarwin; # subpixel rendering improvement on macOS

      # Catppuccin Mocha for both light and dark (dark-first setup)
      theme = "light:catppuccin-mocha,dark:catppuccin-mocha";

      # ==========================================================================
      # Window
      # ==========================================================================
      window-padding-x = "4,4";
      window-padding-y = "4,4";
      window-padding-balance = true; # equal padding on all sides
      window-save-state = "always";
      window-decoration = isDarwin; # native macOS window chrome; false on Linux (WM handles it)

      gtk-titlebar = !isDarwin; # GTK titlebar only on Linux

      # ==========================================================================
      # Tabs
      # ==========================================================================
      # tab-bar-position = "top";

      # ==========================================================================
      # macOS-specific
      # ==========================================================================
      macos-option-as-alt = true; # use Option as Alt for shell shortcuts
      macos-titlebar-style = "tabs"; # compact title bar with tabs integrated
      macos-window-shadow = true;
      macos-auto-secure-input = true; # auto-enable secure input for password prompts
      auto-update-channel = "stable"; # stay on stable releases (brew manages updates anyway)

      # ==========================================================================
      # Scrollback & Mouse
      # ==========================================================================
      scrollback-limit = 10000;
      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = 3;

      # ==========================================================================
      # Keybindings
      # ==========================================================================
      keybind = [
        "super+u=copy_url_to_clipboard"
        "super+shift+c=copy_to_clipboard"
        "super+shift+v=paste_from_clipboard"
      ];
    };
  };
}
