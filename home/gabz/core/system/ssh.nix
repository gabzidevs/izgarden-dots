{ config, ... }:
let
  inherit (config.sops) secrets;
  inherit (config.home) homeDirectory;

  sshDir = "${homeDirectory}/.ssh";
  # rootIdentity = "${sshDir}/id_ed25519";
  rootIdentity = "${sshDir}/keys-root";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # includes = [
    #   secrets.uni-sshconf.path
    #   secrets.rsync-sshconf.path
    # ];

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        compression = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        identityFile = rootIdentity;
        # Downgrade TERM for hosts that don't have ghostty terminfo installed.
        # Our own machines (nebulanix, spacehound) have it via modules/nixos/system/terminfo.nix
        # and override this below. External hosts get xterm-256color for safe compat.
        # When we upgrade to Ghostty ≥ 1.2.0, ssh-env in shell-integration-features
        # will handle this automatically.
        extraOptions.SetEnv = "TERM=xterm-256color";
      };

      # keep-sorted start block=yes newline_separated=yes
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = secrets.keys-gh.path;
      };

      "gitlab.com" = {
        user = "git";
        hostname = "gitlab.com";
      };

      # Our own machines have ghostty terminfo - use full xterm-ghostty TERM
      "nebulanix nebulanix.local" = {
        extraOptions.SetEnv = "TERM=xterm-ghostty";
      };

      "spacehound spacehound.local" = {
        extraOptions.SetEnv = "TERM=xterm-ghostty";
      };
      # keep-sorted end
    };
  };

  home.file."${rootIdentity}.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILS+8+yQb154QMKyTtbdB48ExipEMAkflF7WS/osVrJE gabz@spacehound|root-2026-02-04
  '';

  sops.secrets = {
    # keep-sorted start block=yes
    keys-gh-pub.path = sshDir + "/keys-gh.pub";
    keys-gh.path = sshDir + "/keys-gh";
    # keep-sorted end
  };
}
