{
  inputs,
  lib,
  pkgs,
  ...
}: let
  upstream = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.handy;
in {
  programs.handy = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "handy-${upstream.version}";
      paths = [upstream];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/handy --prefix PATH : ${lib.makeBinPath [pkgs.wtype]}
      '';
      inherit (upstream) meta;
    };
  };
}
