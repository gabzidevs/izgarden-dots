{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) optionalString;
in
{
  sops = {
    secrets.env = { };

    templates.fish-env = {
      content = ''
        function setup_secrets_vars;
          if [ -n "$__SECRETS_SOURCED" ]
            return
          end
          set -gx __SECRETS_SOURCED '1'
          ${config.sops.placeholder.env}
        end
        setup_secrets_vars
      '';

      path = "${config.home.homeDirectory}/.config/fish/conf.d/sops-env.fish";
    };
  };

  programs.fish = {
    plugins = [ ];

    functions = {
      bj = "nohup $argv </dev/null &>/dev/null &";
      "." = ''
        set -l input $argv[1]
        if echo $input | grep -q '^[1-9][0-9]*$'
          set -l levels $input
          for i in (seq $levels)
            cd ..
          end
        else
          echo "Invalid input format. Please use '<number>' to go back a specific number of directories."
        end
      '';
      __zoxide_zi = ''
        zoxide query --interactive | read -l result
        if test -n "$result"
            cd $result
        end
      '';
      take = ''
        if test (count $argv) -gt 0
            set -l path $argv[1]
            # Create directory if it does not exist
            mkdir -p $path
            # Change into the new directory using zoxide
            cd $path
        else
            # If no arguments, use zoxide's interactive mode (zi)
            # to jump to a recently visited directory
            # __zoxide_zi
            cdi
        end
      '';
    };

    loginShellInit = optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin 
    '';

    shellInit = ''
      # themeing
      set fish_greeting
      set -g theme_display_date no
      set -g theme_nerd_fonts yes
      set -g theme_newline_cursor yes

      # Add flake scripts to PATH
      fish_add_path ${config.home.homeDirectory}/.config/flake/scripts

      # Source completions
      source ${config.home.homeDirectory}/.config/flake/scripts/completions/fish/oll_opz_doll.fish

      # Source connect-ollama runtime env if exists
      if test -f "$HOME/.local/share/opencode/runtime.json.env"
        source "$HOME/.local/share/opencode/runtime.json.env"
      end

      # Wrapper function for opencode that auto-loads runtime config + profile
      # Uses opz for profile awareness
      function opencode
        if test -f "$HOME/.local/share/opencode/runtime.json.env"
          source "$HOME/.local/share/opencode/runtime.json.env"
        end
        # Use opz for profile-aware launch
        opz $argv
      end
    '';

    # shellInitLast = ''
    #   ${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | source
    # '';
  };
}
