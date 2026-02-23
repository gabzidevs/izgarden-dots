{
  pkgs,
  ...
}:
{
  nix-homebrew.taps = {
    # keep-sorted start
    "mongodb/homebrew-brew" = pkgs.fetchFromGitHub {
      owner = "mongodb";
      repo = "homebrew-brew";
      rev = "c8ed310f2d445b7029463e8aab7ac72c6cbb7949";
      hash = "sha256-M9hGTTXa03KGvLtIvlRjxB9TWrd2m8i+0VRQC6eTgU8=";
    };
    "narugit/homebrew-tap" = pkgs.fetchFromGitHub {
      owner = "narugit";
      repo = "homebrew-tap";
      rev = "6f55fead758cca66806905e19771df23c415d4b8";
      hash = "sha256-PtDQU1PO7lFOOKjoJblJRbcfVz3e7drsBC6FV+KKImY=";
    };
    # "puma/homebrew-puma" = pkgs.fetchFromGitHub {
    #   owner = "puma";
    #   repo = "homebrew-puma";
    #   rev = "5960519de5e559a6326626643c0a7e4b2fd9832d";
    #   hash = "sha256-nk0ppCKciAKDdvgQ5GNrGXBatd9luhACKROkgXsHhBo=";
    # };
    # keep-sorted end
  };

  homebrew = {
    brews = [
      # keep-sorted start
      "smctemp" # CLI tool for CPU/GPU temperature monitoring on Apple Silicon
      "sqlite" # For opencode-mem native vector database dependency
      # keep-sorted end
    ];

    casks = [
      # keep-sorted start
      # keep-sorted end
    ];
  };
}
