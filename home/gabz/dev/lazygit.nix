{ config, ... }:
{
  programs.lazygit = {
    enable = config.garden.profiles.workstation.enable && config.programs.git.enable;

    settings = {
      update.method = "never";

      gui = {
        nerdFontsVersion = 3;
        authorColors.gabz = "#6F4E37";
      };

      git = {
        overrideGpg = true;
        pagers = [
          { pager = "delta --paging=never"; }
        ];
      };
    };
  };
}
