{pkgs, ...}: {
  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    go
    age
    gcc
    nvd
    mpv
    sops
    sox
    btop
    just
    nixd
    gopls
    ffmpeg
    gnumake
    ddcutil
    equibop
    gofumpt
    seanime
    hunspell
    obsidian
    alejandra
    mcp-nixos
    stress-ng
    libnotify
    zed-editor
    claude-code
    unigine-heaven
    hyphenDicts.en_GB
    libreoffice-qt-fresh
    nvtopPackages.nvidia
    hunspellDicts.en_GB-ise
  ];

  nixpkgs.config.permittedInsecurePackages = [
  ];
}
