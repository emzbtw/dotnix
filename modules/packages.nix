{
  config,
  pkgs,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    nvd
    mpv
    sox
    btop
    nixd
    ffmpeg
    logseq
    gnumake
    ddcutil
    equibop
    seanime
    hunspell
    alejandra
    stress-ng
    libnotify
    zed-editor
    unigine-heaven
    hyphenDicts.en_GB
    stremio-linux-shell
    libreoffice-qt-fresh
    hunspellDicts.en_GB-ise
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
}
