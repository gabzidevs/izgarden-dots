{
  lib,
  ...
}:
let
  inherit (lib.lists) optionals;
in 
{
  nix-homebrew.taps = {
  };

  homebrew = {
    casks = [
      "orbstack"
      "homerow"
      "lunar"
      "mac-mouse-fix"
      "localsend"
      "obs"
      "vlc"
      "modrinth"
      {
        name = "steam";
        args.require_sha = false;
      }
    ];
  };
}
