{
  lib,
  config,
  osClass,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.garden.profiles = {
    # User-level application profiles
    coding = {
      enable = mkEnableOption "coding profile" // {
        default = config.garden.profiles.workstation.enable;
      };

      keyboard.remapCapsLock = mkOption {
        type = types.enum [
          "none"
          "escape"
          "control"
        ];
        default = "none";
        description = "How to remap caps lock (escape=vim-style, control=emacs-style, none=no remapping)";
      };

      keyboard.tapHold = {
        enable = mkEnableOption "tap/hold key behavior (requires Karabiner)";
        tapKey = mkOption {
          type = types.enum [
            "escape"
            "control"
            "none"
          ];
          default = "escape";
          description = "Key sent on tap";
        };
        holdKey = mkOption {
          type = types.enum [
            "escape"
            "control"
            "hyper"
            "none"
          ];
          default = "hyper";
          description = "Key sent on hold (hyper = Ctrl+Alt+Cmd+Shift)";
        };
        apps = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                tapKey = mkOption {
                  type = types.enum [
                    "escape"
                    "control"
                    "none"
                  ];
                  default = "escape";
                  description = "Key sent on tap for this app";
                };
                holdKey = mkOption {
                  type = types.enum [
                    "escape"
                    "control"
                    "hyper"
                    "none"
                  ];
                  default = "hyper";
                  description = "Key sent on hold for this app";
                };
              };
            }
          );
          default = { };
          description = "Per-app overrides for tap/hold behavior";
          example = {
            "com.apple.Terminal" = {
              tapKey = "escape";
              holdKey = "none";
            };
            "com.googlecode.iterm2" = {
              tapKey = "escape";
              holdKey = "control";
            };
            "com.microsoft.VSCode" = {
              tapKey = "escape";
              holdKey = "escape";
            };
          };
        };
      };
    };

    recreational.enable = mkEnableOption "recreational profile" // {
      default = false;
    };

    social.enable = mkEnableOption "social profile" // {
      default = config.garden.profiles.recreational.enable;
    };

    work.enable = mkEnableOption "work profile" // {
      default = config.garden.profiles.workstation.enable;
    };

    # Media profiles (user-level preferences)
    media = {
      creation.enable = mkEnableOption "media creation profile";
      streaming.enable = mkEnableOption "media streaming profile";
      consumption.enable = mkEnableOption "media consumption profile";

      watching.enable = mkEnableOption "media watching profile" // {
        default = config.garden.profiles.graphical.enable && osClass == "nixos";
      };
    };
  };

  config = {
    garden.profiles = {
      inherit (osConfig.garden.profiles)
        graphical
        headless
        workstation
        laptop
        server
        work
        recreational
        ;
    };
  };
}
