{pkgs, ...}: {
  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    gcc
    imv
    nvd
    mpv
    sops
    sox
    btop
    just
    nixd
    ffmpeg
    stylua
    gnumake
    ddcutil
    equibop
    seanime
    hunspell
    nautilus
    obsidian
    alejandra
    mcp-nixos
    iptvnator
    stress-ng
    libnotify
    zed-editor
    claude-code
    brave-origin
    google-chrome
    unigine-heaven
    hyphenDicts.en_GB
    libreoffice-qt-stable
    nvtopPackages.nvidia
    hunspellDicts.en_GB-ise
  ];

  nixpkgs.config.permittedInsecurePackages = [
  ];
}
