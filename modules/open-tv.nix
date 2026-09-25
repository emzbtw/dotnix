{
  pkgs,
  ...
}: let
  # Updates: bump `version`, then recompute the hash with
  # `nix hash file --sri <path-to-downloaded-deb>` and replace `hash`.
  open-tv = pkgs.stdenv.mkDerivation rec {
    pname = "open-tv";
    version = "1.9.1";

    src = pkgs.fetchurl {
      url = "https://github.com/Fredolx/open-tv/releases/download/v${version}/Fred.TV_${version}_amd64.deb";
      hash = "sha256-yoe8+NmyKJ1vdTO2CZWO+MkAAG6gDz5jI7J752Z2MmI=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      cairo
      dconf
      gdk-pixbuf
      glib
      glib-networking
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gtk3
      libsoup_3
      openssl
      pango
      webkitgtk_4_1
    ];

    unpackPhase = ''
      dpkg -x $src .
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -m755 usr/bin/open_tv $out/bin/open_tv
      cp -r usr/share $out/share
      mv "$out/share/applications/Fred TV.desktop" $out/share/applications/open-tv.desktop
      substituteInPlace $out/share/applications/open-tv.desktop \
        --replace "Exec=env WEBKIT_DISABLE_DMABUF_RENDERER=1 open_tv" "Exec=open_tv"

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
        --prefix PATH : ${pkgs.mpv}/bin
      )
    '';

    meta = {
      description = "Ultra-fast, simple and powerful cross-platform IPTV app";
      homepage = "https://github.com/Fredolx/open-tv";
      license = pkgs.lib.licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      mainProgram = "open_tv";
    };
  };
in {
  environment.systemPackages = [open-tv];
}
