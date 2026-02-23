{
  # This configuration creates the shell aliases across: bash, zsh and fish
  home.shellAliases = {
    mkdir = "mkdir -pv"; # always create pearent directory
    df = "df -h"; # human readblity
    rs = "systemctl reboot";
    jctl = "journalctl -p 3 -xb"; # get error messages from journalctl
    lg = "lazygit";
    zj = "zellij";

    # Ollama ecosystem
    oll = "oll";
    opz = "opz";
    doll = "doll";

    zzzpl = "cd ~/.local/share/zzz ; git pull ; git push ; cd -";
    zzzbk = "cd ~/.local/share/zzz ; git add . ; git commit -m 'chore: sync changes' ; git push ; cd -";
  };
}
