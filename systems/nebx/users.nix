_:
let
  mainUser = "gabz";
in
{
  garden.system = {
    users = [
      mainUser
    ];
  };

  

  home-manager.users.${mainUser} = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      ghostty.enable = true;

      # Problematic 🚧
      discord.enable = false;
      wezterm.enable = false;
    };
  };
}
