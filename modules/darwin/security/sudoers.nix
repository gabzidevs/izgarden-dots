{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  options.prosecurity = {
    sudoers = mkEnableOption "Configure passwordless sudo for admin users";
  };

  config = lib.mkIf config.prosecurity.sudoers {
    security.sudo = {
      # Passwordless sudo for admin group
      extraConfig = ''
        %admin ALL=(ALL) NOPASSWD: ALL
      '';
    };
  };
}
