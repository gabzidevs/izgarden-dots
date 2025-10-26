{ config, ... }:
let
  inherit (config.sops) secrets;
  inherit (config.home) homeDirectory;
  sshDir = "${homeDirectory}/.ssh";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # includes = [ secrets.extra-sshconf.path ];

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };

      # keep-sorted start block=yes newline_separated=yes
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = secrets.keys-gh.path;
        forwardAgent = true;
        addKeysToAgent = "yes";
      };

      "gitlab.com" = {
        user = "git";
        hostname = "gitlab.com";
        identityFile = secrets.keys-glab.path;
        forwardAgent = true;
        addKeysToAgent = "yes";
      };
      # keep-sorted end
    };
  };

  home.file.".ssh/id_ed25519.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACHj1HRTKsmOT+06X5gC32ASo+8xUkt19X4nE5P5h41
  '';

  sops.secrets = {
    # keep-sorted start block=yes
    keys-gh-pub.path = sshDir + "/id_ed25519_gh.pub";
    keys-gh.path = sshDir + "/id_ed25519_gh";
    keys-glab-pub.path = sshDir + "/id_ed25519_glab.pub";
    keys-glab.path = sshDir + "/id_ed25519_glab";
    # keep-sorted end
  };
}
