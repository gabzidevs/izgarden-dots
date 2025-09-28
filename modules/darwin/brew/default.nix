{
  self,
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (self.lib) anyHome;

  qh = anyHome config;
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
          rev = "ff07fffc3070dd370bd6c9cc5c1eb6bc860f2e23";
          hash = "sha256-9tbsCAzOHuGhqSgGCr9yNhbQB3hEPhGy6DjQyAT6qg0=";
        };
        "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
          owner = "homebrew";
          repo = "homebrew-cask";
          rev = "bade13641cb4435785cf4a353a33eb920e1289da";
          hash = "sha256-rFVldUOu1C/pfQM7uvGk65um+7kMEKOOSHG2BY/YZA0=";
        };
        # "th-ch/homebrew-youtube-music" = pkgs.fetchFromGitHub {
        #   owner = "th-ch";
        #   repo = "homebrew-youtube-music";
        #   rev = "b87d9c3dfa2ec58c182b6bfda182ccbdc58beb5c";
        #   hash = "sha256-7rcUremYRB9JsqaY6SyRfXk1GnrTfyJjYUi0fDiI5Sk=";
        # };
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
      # brews = [ "openjdk" ];

      # `brew install --cask`
      casks = [
        "arc" # browser
        # "loungy" # app launcher, too beta to use mainstream
        # "gimp" # image editor
        "raycast" # app launcher, and clipboard manager
        # "inkscape" # vector graphics editor
        # {
        #   name = "youtube-music";
        #   args.require_sha = false; # youtube music client
        #   greedy = true; # ytm is not properly versioned
        # }
        # "intellij-idea" # IDE
        "jordanbaird-ice" # better status bar
      ]
      ++ lib.optionals (qh (c: c.programs.ghostty.enable)) [
        "ghostty"
      ];
    };
  };
}
