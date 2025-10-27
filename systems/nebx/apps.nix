{
  lib,
  pkgs,
  ...
}:
{
  nix-homebrew.taps = {
    "mongodb/homebrew-brew" = pkgs.fetchFromGitHub {
      owner = "mongodb";
      repo = "homebrew-brew";
      rev = "c8ed310f2d445b7029463e8aab7ac72c6cbb7949";
      hash = "sha256-M9hGTTXa03KGvLtIvlRjxB9TWrd2m8i+0VRQC6eTgU8=";
    };
    "puma/homebrew-puma" = pkgs.fetchFromGitHub {
      owner = "puma";
      repo = "homebrew-puma";
      rev = "5960519de5e559a6326626643c0a7e4b2fd9832d";
      hash = "sha256-nk0ppCKciAKDdvgQ5GNrGXBatd9luhACKROkgXsHhBo=";
    };
    "launchdarkly/homebrew-tap" = pkgs.fetchFromGitHub {
      owner = "launchdarkly";
      repo = "homebrew-tap";
      rev = "963b42364ed8a5c230e630694b645916162c7a85";
      hash = "sha256-Yw40FTPRROIF+9nV6PMUK1Xc4/al+4EnF7VI+6qv/+I=";
    };
    # TODO: Enable when tap permission issues are assesed
    # "microsoft/git" = pkgs.fetchFromGitHub {
    #   owner = "microsoft";
    #   repo = "homebrew-git";
    #   rev = "2547a4a02bbc171127b6a7247db24d91308b36b6";
    #   hash = "sha256-LdfC4sDiHT2MMat8U1ADXYefUDxIKoOUEJZckwn263A=";
    # };
  };

  homebrew = {
    casks = [
      "orbstack"
      "homerow"
      "lunar"
      "mac-mouse-fix"
      "localsend"
      "obs"
    ];
  };
}
