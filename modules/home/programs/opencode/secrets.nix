{ config, lib, ... }:

{
  options.garden.programs.opencode.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable OpenCode secret management via sops-nix";
    };

    keys = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Secret name";
            };
            envVar = lib.mkOption {
              type = lib.types.str;
              description = "Environment variable name";
            };
          };
        }
      );
      default = [ ];
      description = "API keys to manage";
    };
  };

  config = lib.mkIf config.garden.programs.opencode.secrets.enable (
    lib.mkIf config.sops.enable {
      sops.secrets = builtins.listToAttrs (
        map (key: {
          name = "opencode-${key.name}";
          value = {
            needed = [ "home-manager" ];
            format = "env";
          };
        }) config.garden.programs.opencode.secrets.keys
      );

      home.sessionVariables = builtins.listToAttrs (
        map (key: {
          name = key.envVar;
          value = config.sops.secrets."opencode-${key.name}".path;
        }) config.garden.programs.opencode.secrets.keys
      );
    }
  );
}
