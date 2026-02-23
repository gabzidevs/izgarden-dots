{ config, ... }:
{
  programs.mise = {
    inherit (config.garden.profiles.workstation) enable;

    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;

    globalConfig = {
      # Tool auto-install is enabled by default (MISE_AUTO_INSTALL=true)
      # Tools are automatically installed when used via mise activation
      settings = {
        auto_install = true;
      };

      tools = {
        # Node.js LTS codenames: https://nodejs.org/docs/latest-v24.x/
        # - v22 (Jod)        - EOL: April 2027
        # - v24 (Krypton)    - Current Active LTS (since Feb 2026)
        node = "lts/krypton"; # v24 - latest active LTS
        neovim = "0.11.6"; # Latest stable 0.11.x
        opencode = "latest";
        gum = "0.17.0"; # Latest stable
        yarn = "4.12.0"; # Latest stable 4.x
        bun = "latest"; # For OpenCode plugin installation
        "npm:ocx" = "latest"; # OCX via npm backend
      };

      env = {
        # Lazyvim configuration - uncomment to use lazyvim nvim config
        # (The Ghostty concern was proven to be unrelated)
        NVIM_APPNAME = "nvim-lazy";
      };
    };
  };
}
