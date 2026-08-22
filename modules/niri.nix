{pkgs, ...}: {
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  services.gvfs.enable = true;
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
