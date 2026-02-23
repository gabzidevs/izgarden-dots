_:
let
  mainUser = "gabz";
in
{
  garden.system = {
    users = [
      mainUser
      # "rodz"
    ];
  };

  # Additional users can be configured here
  # home-manager.users.rodz = {
  #   programs.zsh.enable = true;
  # };

  home-manager.users.${mainUser} = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      ghostty.enable = true;
      wezterm.enable = false;
    };

    # OpenCode with Ollama (local on Nebulanix)
    garden.programs.opencode = {
      enable = true;
      agentPath = /Users/gabz/.config/flake/.opencode/time-room/agents;
      # Use null - let connect-ollama select model at runtime
      model = null;
      ollamaHost = "http://0.0.0.0:11434";
      defaultAgent = "plan";
      enableGoogle = true;
      enableAnthropic = true;
      enableOllamaCloud = true;
      # Model catalog (try-ai stack)
      models = {
        # Small tooled models (fast, deterministic)
        "qwen2.5-3b-lich" = {
          name = "The Lich 3B - Ultra-precise (temp 0.01)";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen3-8b-lich" = {
          name = "The Lich 8B - Ultra-precise (temp 0.01)";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen2.5-3b-lemongrab" = {
          name = "Lemongrab 3B - UNACCEPTABLE validator";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen3-8b-lemongrab" = {
          name = "Lemongrab 8B - UNACCEPTABLE validator";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen2.5-3b-magicman" = {
          name = "Magic Man 3B - Casual chaos coder";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen2.5-coder-magicman" = {
          name = "Normal Man 32B - Grounded refactor specialist";
          tools = true;
          reasoning = true;
          numCtx = 65536;
        };
        "qwen2.5-3b-golb" = {
          name = "GOLB 3B - Chaotic creativity";
          tools = true;
          reasoning = false;
          numCtx = 32768;
        };
        "qwen3-tooled-small" = {
          name = "Qwen3 8B (tooled) - Princess Bubblegum";
          tools = true;
          reasoning = true;
          numCtx = 8192;
        };
        "qwen2.5-small-tooled" = {
          name = "Qwen2.5 3B (tooled) - Princess Bubblegum";
          tools = true;
          reasoning = false;
          numCtx = 8192;
        };
        # Large tooled variants with custom templates (priority)
        "qwen2.5-coder-tooled" = {
          name = "Qwen2.5 Coder 32B (tooled)";
          tools = true;
          reasoning = false;
          numCtx = 65536;
        };
        "qwen3-coder-tooled" = {
          name = "Qwen3 Coder 30B (tooled) - Princess Bubblegum";
          tools = true;
          reasoning = false;
          numCtx = 8192;
        };
        "qwen3-tooled" = {
          name = "Qwen3 32B (tooled)";
          tools = true;
          reasoning = true;
          numCtx = 65536;
        };
        "qwen3-moe-tooled" = {
          name = "Qwen3 30B MoE (tooled)";
          tools = true;
          reasoning = true;
          numCtx = 65536;
        };
        # claude's picks (original fallbacks)
        "qwen2.5-coder:32b-instruct-q4_K_M" = {
          name = "Qwen2.5 Coder 32B (claude's)";
          tools = true;
          reasoning = false;
          numCtx = 65536;
        };
        "devstral" = {
          name = "Devstral 24B (claude's)";
          tools = true;
          reasoning = false;
          numCtx = 65536;
        };
        "qwen3:32b-q4_K_M" = {
          name = "Qwen3 32B (claude's)";
          tools = true;
          reasoning = true;
          numCtx = 65536;
        };
        "qwen3:30b-a3b-q4_K_M" = {
          name = "Qwen3 30B MoE (claude's)";
          tools = true;
          reasoning = true;
          numCtx = 65536;
        };
        # near-zen picks
        "gpt-oss:20b" = {
          name = "GPT-OSS 20B (near-zen)";
          tools = true;
          reasoning = false;
          numCtx = 65536;
        };
        "glm4" = {
          name = "GLM 4 (near-zen)";
          tools = true;
          reasoning = false;
          numCtx = 65536;
        };
        # ours
        "llama3.2:1b" = {
          name = "Llama 3.2 1B (ours)";
          tools = true;
          reasoning = false;
          numCtx = 4096;
        };
      };
      # OCX with profile plugins
      ocx = {
        enable = true;
        flakePath = "/Users/gabz/.config/flake";
        cleanSync = true;
        registries = [
          "https://registry.kdco.dev"
          "https://ocx-kit.kdco.dev"
        ];
        # Default profile name
        defaultProfile = "nebx";
        # Install base profiles
        profiles = [
          "omo" # Registry profile - oh-my-opencode
        ];
        # OCX native plugins (empty - using profilePlugins instead)
        plugins = [ ];
        # Profile-specific plugins (inline)
        profilePlugins = {
          "nebx" = [
            # KDCO plugins (OCX native)
            "kdco/background-agents"
            "kdco/notify"
            # Fallback plugin for dual local mode
            "npm:@azumag/opencode-rate-limit-fallback"
            # Phase 1: Priority
            "npm:opencode-toolbox@0.10.4"
            "npm:opencode-working-memory"
            "npm:opencode-antigravity-auth"
            # Phase 1b: Orchestration
            "npm:@openspoon/subtask2"
            # Phase 2: Foundation
            "npm:@slkiser/opencode-quota"
            # Phase 3: Efficiency
            "npm:@nick-vi/opencode-type-inject"
            "npm:opencode-snippets"
            "npm:@franlol/opencode-md-table-formatter"
            # Phase 4: Token Optimization
            "npm:@tarquinen/opencode-dcp"
            "npm:@ramtinj95/opencode-tokenscope"
            "npm:opencode-rules"
          ];
          # "omo" = [
          #   "npm:oh-my-opencode"
          # ];
        };
        # Fallback npm plugins
        npmPlugins = [
          # "npm:opencode-toolbox@0.10.4"
        ];
      };
    };

    # User-level profile configuration
    garden.profiles = {
      coding = {
        enable = true;
        keyboard.remapCapsLock = "escape"; # Vim-style
      };

      recreational.enable = true;
      social.enable = true;

      media = {
        creation.enable = true;
        consumption.enable = true;
        streaming.enable = false;
      };
    };
  };
}
