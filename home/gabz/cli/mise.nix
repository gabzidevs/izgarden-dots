{ config, ... }:
{
  programs.mise = {
    inherit (config.garden.profiles.workstation) enable;

    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    globalConfig = {
      tools = {
        node = "lts/jod";
        # node = "lts/iron";
        bitwarden = "2025.9.0";
        neovim = "0.11.4";
      };

      env = {
        NVIM_APPNAME = "nvim-lazy";
      };
    };
  };
}
