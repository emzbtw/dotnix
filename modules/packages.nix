{
  pkgs,
  lib,
  ...
}: let
  # rpiv-voice's prebuilt native binaries (mic capture, sherpa-onnx) need
  # ALSA and libstdc++ on LD_LIBRARY_PATH to dlopen on NixOS.
  pi-voice = pkgs.symlinkJoin {
    name = "pi-coding-agent-voice";
    paths = [pkgs.pi-coding-agent];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          pkgs.alsa-lib
          pkgs.stdenv.cc.cc.lib
        ]
      }
    '';
  };
in {
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
    herdr
    ffmpeg
    stylua
    gnumake
    ddcutil
    equibop
    seanime
    chromium
    hunspell
    nautilus
    ffmpegthumbnailer
    obsidian
    alejandra
    mcp-nixos
    iptvnator
    stress-ng
    libnotify
    zed-editor
    claude-code
    unigine-heaven
    pi-voice
    hyphenDicts.en_GB
    libreoffice-qt-stable
    nvtopPackages.nvidia
    hunspellDicts.en_GB-ise
  ];

  nixpkgs.config.permittedInsecurePackages = [
  ];
}
