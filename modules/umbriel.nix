{
  inputs,
  pkgs,
  ...
}: {
  programs.umbriel = {
    enable = true;
    portalPackage = inputs.xdg-desktop-portal-umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
