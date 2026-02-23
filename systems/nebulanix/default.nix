{
  imports = [
    ./apps.nix
    ./users.nix
    ../../modules/darwin/services
  ];

  garden = {
    # environment.flakePath = "/Users/gabz/.config/izgarden-dots";
    profiles = {
      # Hardware profiles
      laptop.enable = true;
      graphical.enable = true;
      workstation.enable = true;

      # Machine personality: Work-focused but with recreational capability
      work.focus = true;
      recreational.focus = false;
    };
  };

  networking = {
    hostName = "nebulanix";
    computerName = "MBP M4 | nebulanix 🚧";
  };

  nix-homebrew.autoMigrate = true;

  # Ollama server with memory optimization settings
  garden.system.ollamaServer = true;
  garden.system.ollamaSettings = {
    OLLAMA_KEEP_ALIVE = "30s";
    OLLAMA_CONTEXT_LENGTH = "2048";
    OLLAMA_FLASH_ATTENTION = "1";
    OLLAMA_KV_CACHE_TYPE = "q8_0";
    OLLAMA_MAX_LOADED_MODELS = "1";
    OLLAMA_NUM_PARALLEL = "1";
  };

  # Enable passwordless sudo for remote provisioning
  prosecurity.sudoers = true;
}
