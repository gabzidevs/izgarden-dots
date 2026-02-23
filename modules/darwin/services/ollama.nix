{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.garden.system.ollamaServer = mkEnableOption "Enable Ollama server with network access";

  options.garden.system.ollamaSettings = mkOption {
    description = "Ollama server environment variables";
    type = types.attrsOf types.str;
    default = { };
    example = {
      OLLAMA_KEEP_ALIVE = "30s";
      OLLAMA_CONTEXT_LENGTH = "2048";
    };
  };

  config = mkIf config.garden.system.ollamaServer {
    launchd.user.agents.ollama = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.ollama}/bin/ollama"
          "serve"
        ];
        EnvironmentVariables = {
          OLLAMA_HOST = "0.0.0.0:11434";
        }
        // config.garden.system.ollamaSettings;
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
