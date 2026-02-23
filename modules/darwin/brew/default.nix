{
  pkgs,
  inputs,
  config,
  self,
  lib,
  ...
}:
let

  qh = self.lib.anyHome config;

  systemWorkFocus = config.garden.profiles.work.focus or false;
  systemRecreationalFocus = config.garden.profiles.recreational.focus or false;

  shouldInstallWorkApps = systemWorkFocus || (qh (c: c.garden.profiles.work.enable or false));
  shouldInstallGamingApps =
    systemRecreationalFocus || (qh (c: c.garden.profiles.recreational.enable or false));

  workApps = [
    "gather"
    "slack"
    "tuple"
    "loom"
    "linear-linear"
    "mongodb-compass"
    "warp"
    "1password"
    "beekeeper-studio"
  ];

  gamingApps = [
    {
      name = "steam";
      args.require_sha = false;
    }
    "bluestacks"
    "transmission"
    "modrinth"
  ];

  mediaApps = [
    "vlc"
  ];
in
{
  imports = [
    inputs.homebrew.darwinModules.nix-homebrew
    ./environment.nix
  ];

  config = {
    # brought in using nix-homebrew to make homebrew apps reproducible
    nix-homebrew = {
      enable = true;

      package = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "brew";
        rev = "a3cd1699236316db296be914b7a3f898b7d52866"; # version 5.0.13
        hash = "sha256-rN7SUKJHkoDf9ik1iKaRVeIW+BktlplWkMaUJpb6Jw0=";
      };

      # I want to force us to only use declarative taps
      mutableTaps = false;

      # we need a user to install the packages for
      user = config.garden.system.mainUser;

      # to truly be declarative, we need to specify the exact revision of homebrew-core
      #
      # you can run the following command to get the latest rev and hash of homebrew-core
      # nix-prefetch-github homebrew homebrew-core --nix
      taps = {
        "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
          owner = "homebrew";
          repo = "homebrew-core";
          rev = "9e4f733fb78302623b3109cc303eb8567ce353f5";
          hash = "sha256-AfN3/aibt1JN9SuwZI2//Abs2gOGGDrJAX4Adgmm3rM=";
        };
        "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
          owner = "homebrew";
          repo = "homebrew-cask";
          rev = "f2de00d40b3f3bdffb3acddc16dd31206dd1d6fe";
          hash = "sha256-RR6gJv0wvEMT/H/lnFUWC6OqHWzmPhs+HsMicaAjqT0=";
        };
      };
    };

    # without nix-homebrew, these are the apps installed by homebrew
    # are not managed by nix, and not reproducible! But with the use
    # of nix-homebrew, we can manage these apps with nix.
    #
    # for "legeacy reasons" you may want to remove nix-homebrew and
    # need to install homebrew manually, see https://brew.sh
    homebrew = {
      enable = true;

      caskArgs.require_sha = true;
      global.autoUpdate = false;

      onActivation = {
        # autoUpdate = true; # this should be managed by nix-homebrew
        upgrade = true;
        # 'zap': uninstalls all formulae (and related files) not listed here.
        cleanup = "zap";
      };

      # Applications to install from Mac App Store using mas.
      # You need to install all these Apps manually first so that your apple account have records for them.
      # otherwise Apple Store will refuse to install them.
      # For details, see https://github.com/mas-cli/mas
      masApps = { };

      # if we don't do this nix-darwin may attempt to remove our taps
      # even when they are managed by nix-homebrew
      taps = builtins.attrNames config.nix-homebrew.taps;

      # `brew install`
      # brews = [ ];
      brews = [ "mole" ];

      # `brew install --cask`
      # Universal apps (always installed)
      casks = [
        # "loungy" # app launcher, too beta to use mainstream
        # "gimp" # image editor
        "raycast" # app launcher, and clipboard manager
        # "inkscape" # vector graphics editor
        # "intellij-idea" # IDE
        # "jordanbaird-ice@beta" # better status bar
        # "discord"
        # "ghostty"
        "helium-browser"
        # "jellyfin-media-player"
      ]
      # Extra global ones
      ++ [
        "arc"
        # "deskflow"
        "jordanbaird-ice@beta"
        "homerow"
        "localsend"
        "lunar"
        "mac-mouse-fix"
        "orbstack"
        "protonvpn"
        "utm"
      ]
      # User-level conditional apps
      ++ lib.optionals (qh (c: c.programs.discord.enable or false)) [
        "discord"
      ]
      ++ lib.optionals (qh (c: c.programs.ghostty.enable or false)) [
        "ghostty"
      ]
      # System-level conditional: Work apps (system focus OR user profile)
      ++ lib.optionals shouldInstallWorkApps workApps
      # System-level conditional: Gaming apps (system focus OR user profile)
      ++ lib.optionals shouldInstallGamingApps gamingApps
      # Media apps (streaming profile)
      ++ lib.optionals (qh (c: c.garden.profiles.media.streaming.enable or false)) mediaApps;
    };
  };
}
