{
...
}:
let
  mainUser = "gabz";
in
{
  garden.system = {
    users = [ mainUser "rodz" ];
  };

  home-manager.users.rodz = {
    programs.zsh.enable = true;
  };

  home-manager.users.${mainUser} = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      # discord.enable = true;

      ghostty.enable = true;
      wezterm.enable = true;
    };
  };
}

