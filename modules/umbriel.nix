{pkgs, ...}: {
  programs.umbriel.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
