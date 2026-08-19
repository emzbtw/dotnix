{
  pkgs,
  inputs,
  ...
}: {
  # Install fish shell
  programs.fish.enable = true;

  # Install bat
  programs.bat = {
    enable = true;
    settings = {
      style = "header,grid,snip";
    };
  };

  # Install zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Install nh the yet-another-nix-helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/emz/nixos";
  };

  # Install comma, runs software without installing it
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.package = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;

  environment.systemPackages = with pkgs; [
    fd
    jq
    git
    fzf
    dig
    eza
    zip
    cava
    wget
    yazi
    procs
    unzip
    cliamp
    hwinfo
    yt-dlp
    ripgrep
    tcpdump
    ghostty
    tealdeer
    starship
    fastfetch
    wl-clipboard
    proton-vpn-cli
    translate-shell
  ];
}
