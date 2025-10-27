{
  imports = [
    ./users.nix
    ./apps.nix
  ];

  garden = {
    profiles = {
      laptop.enable = true;
      graphical.enable = true;
      workstation.enable = true;
    };
  };

  networking = {
    hostName = "nebx";
    computerName = "MBP-M4 | nebulanix 🚧";
  };

  nix-homebrew.autoMigrate = true;
}
