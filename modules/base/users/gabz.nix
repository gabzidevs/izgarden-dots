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
        # TODO: Replace this with legit ssh key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQDiHbMSinj8twL9cTgPOfI6OMexrTZyHX27T8gnMj2"
      ];
    };
  };
}
