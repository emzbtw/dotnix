{config, ...}: {
  services.flick = {
    enable = true;
    environmentFile = config.sops.secrets."flick-football-data-api-key".path;
  };
}
