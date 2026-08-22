{pkgs, ...}: {
  programs.niri.enable = true;
  #useNautilus = true;

  services.gnome.gcr-ssh-agent.enable = false;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
