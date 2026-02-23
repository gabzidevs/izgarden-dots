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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILS+8+yQb154QMKyTtbdB48ExipEMAkflF7WS/osVrJE gabz@spacehound|root-2026-02-04"
      ];
    };
  };
}
