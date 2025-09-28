{
  self,
  name,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.sops.homeManagerModules.sops ];

  config = {
    sops = {
      defaultSopsFile = "${self}/secrets/${name}.yaml";
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      age.sshKeyPaths = [
        "${config.home.homeDirectory}/.ssh/id_ed25519"
      ];
    };
  };
}
