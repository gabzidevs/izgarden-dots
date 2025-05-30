{
  lib,
  self,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.attrsets) mapAttrs;
  inherit (self.lib.services) mkServiceOption;
  inherit (self.lib.secrets) mkSecret;

  cfg = config.garden.services.nginx;
in
{
  options.garden.services.nginx = mkServiceOption "nginx" {
    domain = "isabelroses.com";

    extraConfig = {
      vhosts = mkOption {
        type = types.attrsOf (
          types.submodule {
            freeformType = types.attrsOf types.anything;
          }
        );
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflare-cert-api = mkSecret {
      file = "cloudflare/cert-api";
      owner = "nginx";
      group = "nginx";
    };

    networking = { inherit (cfg) domain; };

    security.acme = {
      acceptTerms = true;
      defaults.email = "isabel@isabelroses.com";

      certs.${cfg.domain} = {
        extraDomainNames = [ "*.${cfg.domain}" ];
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets."cloudflare-cert-api".path;
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;
      statusPage = true; # For monitoring scraping.

      package = pkgs.nginxQuic.override { withKTLS = true; };

      commonHttpConfig = ''
        # real_ip_header CF-Connecting-IP;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options nosniff;
      '';

      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2";

      virtualHosts = mapAttrs (
        _: settings:
        {
          quic = true;
          forceSSL = true;
          enableACME = false;
          useACMEHost = cfg.domain;
        }
        // settings
      ) cfg.vhosts;
    };
  };
}
