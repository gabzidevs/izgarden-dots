{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) getExe;
  inherit (lib.hm.dag) entryAfter;
  ocxCfg = config.garden.programs.opencode.ocx;
  mise = getExe config.programs.mise.package;
  ocx = "${mise} x npm:ocx@latest -- ocx";
  ocxCleanup = pkgs.writeScriptBin "ocx-cleanup" (builtins.readFile ../../../../scripts/ocx-cleanup);
in
{
  options.garden.programs.opencode.ocx = {
    enable = lib.mkEnableOption "OCX (OpenCode eXtensions) plugin manager";

    registries = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://registry.kdco.dev"
        "https://ocx-kit.kdco.dev"
      ];
      description = "OCX registries to add (e.g., npm for npm packages)";
    };

    npmRegistry = lib.mkOption {
      type = lib.types.str;
      default = "https://registry.npmjs.org";
      description = "NPM registry URL for OCX";
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "kdco/worktree"
        "kdco/notify"
      ];
      description = "OCX native plugins to install";
    };

    npmPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "npm:opencode-toolbox@0.10.4"
        "npm:opencode-working-memory"
      ];
      description = "NPM plugins to install via OCX compatibility layer";
    };

    profiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "kit/ws" ];
      description = "OCX profiles to install";
    };

    profilePlugins = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      example = {
        "omo-slim-plus" = [
          "npm:oh-my-opencode-slim"
          "npm:opencode-working-memory"
        ];
        "omo" = [ "npm:oh-my-opencode" ];
      };
      description = "Map of OCX profile names to their specific plugins. Plugins are installed based on the active profile.";
    };

    defaultProfile = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Default OCX profile to activate (sets OCX_PROFILE env var)";
    };

    cleanSync = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, runs cleanup detection after install to remove orphaned plugins";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/flake";
      description = "Path to the flake directory for commit operations (runtime path, not nix store)";
    };

    opencodeConfigDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/opencode";
      description = "OpenCode config directory (runtime path, not nix store)";
    };
  };

  config = lib.mkIf ocxCfg.enable (
    let
      # Get plugins for the default profile, strip npm: prefix
      profilePlugins = ocxCfg.profilePlugins.${ocxCfg.defaultProfile} or [ ];
      pluginNames = map (p: lib.removePrefix "npm:" p) profilePlugins;
    in
    {
      home.sessionVariables = {
        PATH = "${config.home.homeDirectory}/.local/share/mise/shims:$PATH";
        OCX_PROFILE = ocxCfg.defaultProfile;
      };

      home.file = {
        # Write ocx-plugins.json with the profile plugins
        ".config/opencode/ocx-plugins.json" = {
          text = builtins.toJSON {
            "$schema" = "https://opencode.ai/config.json";
            plugin = pluginNames;
          };
        };
      };

      home.activation = {
        ocxSetup = entryAfter [ "writeBoundary" ] ''
          set -x
          eval "$(${mise} activate zsh --shims)"

          # Set default OCX profile
          export OCX_PROFILE="${ocxCfg.defaultProfile}"
          echo "OCX: Using default profile: $OCX_PROFILE"

          # Add npm registry for npm packages
          ${ocx} registry add ${ocxCfg.npmRegistry} --global || true
          ${lib.concatMapStrings (r: "${ocx} registry add ${r} --global || true\n") ocxCfg.registries}

          # Install base profiles
          ${lib.concatMapStrings (p: "${ocx} profile add ${p} --global || true\n") ocxCfg.profiles}

          # Install OCX native plugins
          ${lib.concatMapStrings (p: "${ocx} add ${p} --global || true\n") ocxCfg.plugins}

          # Install profile-specific plugins
          ${lib.concatMapStrings (name: ''
            if [ "$OCX_PROFILE" = "${name}" ]; then
              echo "OCX: Installing ${name} profile plugins..."
              ${lib.concatStringsSep "\n" (
                map (p: "${ocx} add ${p} --global || true") ocxCfg.profilePlugins.${name}
              )}
            fi
          '') (lib.attrNames ocxCfg.profilePlugins)}

          # Install dependencies for OCX plugins via bun
          cd ${ocxCfg.opencodeConfigDir}
          ${getExe config.programs.bun.package} install
          # Update all plugins to latest versions
          ${ocx} update --all || true
          # Cleanup orphaned plugins if enabled
          ${
            if ocxCfg.cleanSync then
              ''
                FLAKE_PATH="${ocxCfg.flakePath}"
                ${getExe ocxCleanup} --auto --flake "$FLAKE_PATH" || true
              ''
            else
              ""
          }
          set +x
        '';
      };
    }
  );
}
