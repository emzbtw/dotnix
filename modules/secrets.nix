{config, ...}: {
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.secrets."sonarr/api_key" = {};
  sops.secrets."sonarr/password" = {};
  sops.secrets."radarr/api_key" = {};
  sops.secrets."radarr/password" = {};
  sops.secrets."prowlarr/api_key" = {};
  sops.secrets."prowlarr/password" = {};
  sops.secrets."seerr/api_key" = {};
  sops.secrets."sabnzbd/api_key" = {};
  sops.secrets."sabnzbd/nzb_key" = {};
  sops.secrets."jellyfin/admin_password" = {};
  sops.secrets."jellyfin/api_key" = {};
}
