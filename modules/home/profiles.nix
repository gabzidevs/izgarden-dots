{ lib, osConfig, ... }:
let
  cfg = osConfig.garden.profiles;
in
{
  garden.profiles = {
    inherit (cfg)
      graphical
      headless
      workstation
      laptop
      ;

    # workstation = {
    #   inherit (cfg.workstation) enable;
    #   git = {
    #     fsck = lib.mkEnableOption "Git FSCK flags" // {
    #       enable = lib.mkDefault true;
    #     };
    #   };
    # };

    # we don't inherit these as there is extra options here
    gaming = { inherit (cfg.gaming) enable; };

    server = {
      inherit (cfg.server) enable;
      oracle.enable = cfg.server.oracle.enable;
      hetzner.enable = cfg.server.hetzner.enable;
    };
  };

  programs.git.enable = lib.mkDefault cfg.workstation.enable;
}
