{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) optionalAttrs mergeAttrsList;

  cfg = config.garden.profiles;
in {
  garden.packages = mergeAttrsList [
    (optionalAttrs cfg.graphical.enable {
      inherit (pkgs)
        cowsay
        ;
    })

  ];
}
