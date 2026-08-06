{
  config,
  pkgs,
  ...
}: {
  # Syncthing
  services.syncthing = {
    enable = true;
    user = "emz";
    dataDir = "/home/emz/Syncthing";
    configDir = "/home/emz/.config/syncthing";
    openDefaultPorts = true;
  };
}
