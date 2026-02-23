{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    additionalClasses = {
      wsl = "nixos";
    };

    perClass = class: {
      modules = [
        # import the class module, this contains the common configurations between all systems of the same class
        "${self}/modules/${class}/default.nix"
      ];
    };

    # This is the list of system configuration
    #
    # the defaults consists of the following:
    #  arch = "x86_64";
    #  class = "nixos";
    #  modules = [ ];
    #  specialArgs = { };
    hosts = {
      # keep-sorted start block=yes newline_separated=yes
      amaterasu = { };

      aphrodite = { };

      athena = { };

      hephaestus = { };

      isis = { };

      lilith = {
        class = "iso";
      };

      minerva = { };

      nebulanix = {
        arch = "aarch64";
        class = "darwin";
      };

      skadi = {
        arch = "aarch64";
      };

      spacehound = {
        arch = "aarch64";
        class = "darwin";
      };

      tatsumaki = {
        arch = "aarch64";
        class = "darwin";
      };

      valkyrie = {
        class = "wsl";
      };
      # keep-sorted end
    };
  };
}
