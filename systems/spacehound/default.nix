{
  imports = [
    ./apps.nix
    ./users.nix
  ];

  garden = {
    profiles = {
      # Hardware profiles
      laptop.enable = true;
      graphical.enable = true;
      workstation.enable = true;

      # Machine personality: Gaming/recreational focused
      work.focus = false;
      recreational.focus = true;
    };
  };

  networking = {
    hostName = "spacehound";
    computerName = "Montz MBP-M3 | spacehound 🚧";
  };

  nix-homebrew.autoMigrate = true;

  # Enable passwordless sudo for remote provisioning
  prosecurity.sudoers = true;
}
