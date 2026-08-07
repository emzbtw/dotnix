{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # Spotify
  # Spicetify
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      fullAppDisplay
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
