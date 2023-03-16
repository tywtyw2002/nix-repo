{ config
, pkgs
, ...
}: {
  sops.secrets."cf_tunnel/procurer-in-yeg" = {
    owner = "cloudflared";
    sopsFile = ../secrets.yaml;
  };

  services.cloudflared.enable = true;
  services.cloudflared.tunnels = {
    "f4b23b15-19ad-43bd-86f8-494b985f2626" = {
      credentialsFile = config.sops.secrets."cf_tunnel/procurer-in-yeg".path;
      default = "http_status:404";
    };
  };
}
