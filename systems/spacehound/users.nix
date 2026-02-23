_:
let
  mainUser = "gabz";
in
{
  garden.system = {
    users = [
      mainUser
      # "rodz"
      # "grcee"
    ];
  };

  # Additional users can be configured here
  # home-manager.users.grcee = {
  #   programs.zsh.enable = true;
  # };
  #
  # home-manager.users.rodz = {
  #   programs.zsh.enable = true;
  # };

  home-manager.users.${mainUser} = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      ghostty.enable = true;
      wezterm.enable = true;
    };

    # OpenCode on Spacehound - profiles managed via OCX
    # Using null model - let connect-ollama select model at runtime
    garden.programs.opencode = {
      enable = true;
      agentPath = /Users/gabz/.config/flake/.opencode/time-room/agents;
      model = null;
      # Use localhost - Spacehound's local Ollama (llama3.2:3b fits in 18GB)
      ollamaHost = "http://localhost:11434";
      defaultAgent = "plan";
      # Also enable cloud as backup when local can't handle
      enableOllamaCloud = true;
      # Model catalog for Spacehound (smaller models for 18GB RAM)
      models = {
        # General fallback - fits in 18GB with room
        "llama3.2:3b" = {
          name = "Llama 3.2 3B - General fallback";
          tools = true;
          reasoning = false;
          numCtx = 4096;
        };
        # Fast responses - tiny model
        "gemma3:1b" = {
          name = "Gemma 3 1B - Fast responses";
          tools = true;
          reasoning = false;
          numCtx = 4096;
        };
        # Lightweight fallback
        "llama3.2:1b" = {
          name = "Llama 3.2 1B - Lightweight";
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
        defaultProfile = "spchound";
        # Install base profiles
        profiles = [
          "omo" # Registry profile - oh-my-opencode
        ];
        # OCX native plugins (empty - using profilePlugins instead)
        plugins = [ ];
        # Profile-specific plugins (inline)
        profilePlugins = {
          "spchound" = [
            # KDCO plugins (OCX native)
            "kdco/background-agents"
            # Phase 1: Priority
            "npm:opencode-toolbox@0.10.4"
            "npm:opencode-working-memory"
            "npm:opencode-antigravity-auth"
            # Phase 2: Foundation
            "npm:@slkiser/opencode-quota"
            # Phase 3: Efficiency
            "npm:opencode-snippets"
          ];
          # "omo" = [
          #   "npm:oh-my-opencode"
          # ];
        };
        # Fallback npm plugins
        npmPlugins = [
          "npm:opencode-working-memory"
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
        streaming.enable = true; # Enable streaming on spacehound
      };
    };
  };
}
