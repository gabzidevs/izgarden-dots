{
  imports = [
    # keep-sorted start
    ./ads.nix # remove ads
    ./firewall.nix # firewall
    ./pam.nix # pam security settings
    ./sudoers.nix # passwordless sudo for admin
    # keep-sorted end
  ];
}
