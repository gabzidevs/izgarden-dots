{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  config = mkIf config.garden.profiles.media.streaming.enable {
    garden.packages = {
      inherit (pkgs) chatterino7;
    };

    programs.obs-studio = mkIf (!isDarwin) {
      enable = true;
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-multi-rtmp
        obs-move-transition
      ];
    };
  };
}
