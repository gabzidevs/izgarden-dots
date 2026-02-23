{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  garden.packages = mkIf config.garden.profiles.media.creation.enable (
    optionalAttrs isLinux {
      inherit (pkgs)
        inkscape # vector graphics editor
        gimp # image editor (Linux only)
        ;
    }
  );
}
