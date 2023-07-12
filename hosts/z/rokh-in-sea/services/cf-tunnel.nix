{
  config,
  pkgs,
  ...
}: {
  sops.secrets."cf_tunnel/rokh-in-sea" = {
    owner = "cloudflared";
    sopsFile = ../secrets.yaml;
  };

  services.cloudflared.enable = true;
  services.cloudflared.tunnels = {
    "8b60b9ab-efd2-4c32-b39d-4cf789b3fe38" = {
      credentialsFile = config.sops.secrets."cf_tunnel/rokh-in-sea".path;
      default = "http_status:404";
    };
  };
}
