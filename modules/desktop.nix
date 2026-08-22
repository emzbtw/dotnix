{pkgs, ...}: {
  # Required for GTX 970 driver: nvidia.nix's kernelModules only load
  # when this is true, regardless of X11 vs Wayland session use.
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    nwg-look
    capitaine-cursors
    papirus-icon-theme
  ];

  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = ["JetBrainsMono Nerd Font Mono" "Noto Sans Mono"];
    sansSerif = ["Noto Sans"];
    serif = ["Noto Serif"];
  };

  # GTK toolkit integration
  programs.gdk-pixbuf.modulePackages = [pkgs.librsvg];

  # Qt toolkit integration
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
}
