{
  config,
  pkgs,
  ...
}: {
  sops.secrets."cf_tunnel/lif-in-yul" = {
    owner = "cloudflared";
    sopsFile = ../secrets.yaml;
  };

  services.cloudflared.enable = true;
  services.cloudflared.tunnels = {
    "7e542415-bb7c-44a6-a3ac-b2b5ade6241a" = {
      credentialsFile = config.sops.secrets."cf_tunnel/lif-in-yul".path;
      default = "http_status:404";
    };
  };
}
