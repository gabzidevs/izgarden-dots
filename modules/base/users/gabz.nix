{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "gabz" config.garden.system.users) {
    users.users.gabz = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACHj1HRTKsmOT+06X5gC32ASo+8xUkt19X4nE5P5h41"
      ];
    };
  };
}
