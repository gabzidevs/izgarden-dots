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
    hostName = "spacehound";
    computerName = "Montz MBP-M3 | spacehound 🚧";
  };

  nix-homebrew.autoMigrate = true;
}
