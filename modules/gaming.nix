{
  config,
  pkgs,
  ...
}: {
  # Gaming
  # Steam
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [mangohud];
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    rusty-path-of-building
  ];
}
