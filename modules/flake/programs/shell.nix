{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          name = "dotfiles";
          meta.description = "Development shell for this configuration";

          DIRENV_LOG_FORMAT = "";

          packages = builtins.attrValues {
            inherit (pkgs)
              just # quick and easy task runner
              gitMinimal # we need git
              sops # secrets management
              nix-output-monitor # get clean diff between generations

              # INFO: Secrets management (extended)
              ssh-to-age
              age

              # INFO: Sane terminal tools
              fish
              # neovim
              ripgrep
              fd
              eza

              # INFO: Just beacause
              mise
              lazygit
              croc
              nix-prefetch-github
              ;

            # Formatting
            inherit (pkgs)
              nixfmt
              ;
            inherit (config)
              formatter # nix formatter
              ;
          };

          inputsFrom = [ config.formatter ];
        };

        nixpkgs = pkgs.mkShellNoCC {
          packages = builtins.attrValues {
            inherit (pkgs)
              # package creation helpers
              nurl
              nix-init

              # nixpkgs dev stuff
              hydra-check
              nixpkgs-lint
              nixpkgs-review
              nixpkgs-hammering

              # nix helpers
              nix-melt
              nix-tree
              nix-inspect
              nix-search-cli
              ;
          };
        };
      };
    };
}
