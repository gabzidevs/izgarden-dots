{ lib, config, ... }:

let
  inherit (lib) mkIf;
  agentsModule = import ./agents.nix { inherit lib; };
  providers = import ./providers.nix { inherit lib; };
  opencodeCfg = config.garden.programs.opencode;
in

{
  imports = [
    ./secrets.nix
    ./ocx.nix
  ];

  options.garden.programs.opencode = {
    enable = lib.mkEnableOption "OpenCode AI coding assistant";
    agentPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to agent markdown files";
    };
    model = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default model for opencode. If null, uses connect-ollama wrapper to select model at runtime";
    };
    ollamaHost = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:11434";
      description = "Ollama server host";
    };
    enableGoogle = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Google Antigravity provider with models";
    };
    enableAnthropic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Anthropic provider (requires OAuth via opencode auth login)";
    };
    enableOllamaCloud = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Ollama Cloud provider (requires API key via opencode auth login)";
    };
    defaultAgent = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "build"
          "plan"
        ]
      );
      default = "plan";
      description = "Default agent to use when none is specified";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of OpenCode plugins to enable";
    };
    models = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (_: {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Display name for the model";
            };
            tools = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable tool calling for this model";
            };
            reasoning = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable reasoning mode for this model";
            };
            numCtx = lib.mkOption {
              type = lib.types.int;
              default = 65536;
              description = "Context window size for this model";
            };
          };
        })
      );
      default = { };
      description = "Per-model configuration for Ollama provider";
    };
    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional opencode.json config options";
    };
  };

  config = mkIf opencodeCfg.enable (
    let
      # Plugins are now managed via OCX profiles and individual plugin lists
      # The omoSlim toggle has been replaced by OCX profile "omo/slim"
      selectedPlugins = opencodeCfg.plugins;

      baseConfig = {
        "$schema" = "https://opencode.ai/config.json";
      }
      // lib.optionalAttrs (opencodeCfg.model != null) { inherit (opencodeCfg) model; }
      // {
        plugin = selectedPlugins;
        permission.skill = {
          "*" = "allow";
        };
        provider = {
          # Always include local ollama provider - connect-ollama sets OPENCODE_MODEL at runtime
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama";
            options = {
              baseURL = "${opencodeCfg.ollamaHost}/v1";
            };
            models = lib.mapAttrs (modelName: modelCfg: {
              inherit modelName;
              inherit (modelCfg) tools;
              inherit (modelCfg) reasoning;
              options = {
                num_ctx = modelCfg.numCtx;
                # Don't override temperature - let Modelfile settings take precedence
                # temperature = 0.7;  # Stubbed out - use Modelfile params
                top_p = 0.95;
                repeat_penalty = 1.05;
              };
            }) opencodeCfg.models;
          };
        }
        // lib.optionalAttrs opencodeCfg.enableGoogle providers.googleProvider
        // lib.optionalAttrs opencodeCfg.enableAnthropic providers.anthropicProvider
        // lib.optionalAttrs opencodeCfg.enableOllamaCloud providers.ollamaCloudProvider;
      };

      agentConfig = lib.optionals (opencodeCfg.defaultAgent != null) {
        default_agent = opencodeCfg.defaultAgent;
        agent = agentsModule.mkAgents opencodeCfg.agentPath;
      };

      finalConfig = baseConfig // agentConfig // opencodeCfg.extraConfig;
    in
    {
      home.sessionVariables = {
        OLLAMA_HOST = opencodeCfg.ollamaHost;
        # Point OCX to a separate file for plugins - this allows OCX to modify it
        OPENCODE_CONFIG = "${config.home.homeDirectory}/.config/opencode/ocx-plugins.json";
      };

      # HM-managed base config (providers, agents, model)
      home.file.".config/opencode/opencode.json" = {
        text = builtins.toJSON finalConfig;
      };

      # Fallback plugin config for dual local mode
      home.file.".config/opencode/rate-limit-fallback.json" = {
        text = builtins.toJSON {
          fallbacks = [
            "ollama/qwen2.5-coder:32b-instruct-q4_K_M"
            "ollama/devstral"
            "ollama/gpt-oss:20b"
            "ollama/llama3.2:1b"
          ];
        };
      };
    }
  );
}
