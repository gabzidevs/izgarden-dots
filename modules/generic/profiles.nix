{ lib, ... }:
let
  inherit (lib) mkEnableOption mkDefault;
in
{
  options.garden.profiles = {
    graphical.enable = mkEnableOption "Graphical interface";
    headless.enable = mkEnableOption "Headless";
    workstation = {
      enable = mkEnableOption "Workstation";

      git.fsck.enable = mkEnableOption "git FSCK flags" // {
        enable = mkDefault true;
      };
    };
    gaming.enable = mkEnableOption "Gaming";

    laptop.enable = mkEnableOption "Laptop";
    server.enable = mkEnableOption "Server";

    # Machine "personality" profiles
    work.focus = mkEnableOption "work-focused machine";
    recreational.focus = mkEnableOption "recreational-focused machine";
  };
}
