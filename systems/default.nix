{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    additionalClasses = {
      wsl = "nixos";
    };

    perClass = class: {
      modules = [
        "${self}/modules/${class}/default.nix"
      ];
    };

    hosts = {
      # keep-sorted start block=yes newline_separated=yes
      nebx = {
        arch = "aarch64";
        class = "darwin";
      };

      spacehound = {
        arch = "aarch64";
        class = "darwin";
      };
      # keep-sorted end
    };
  };
}
