{
  inputs,
  pkgs,
  ...
}: let
  voxtype = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = [voxtype.onnx voxtype.osd-native];

  systemd.user.services.voxtype = {
    description = "Voxtype voice-to-text daemon";
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    path = [voxtype.osd-native pkgs.which];
    environment.RUST_LOG = "voxtype=info,voxtype::daemon=warn,voxtype::transcribe=warn,warn";
    serviceConfig = {
      ExecStart = "${voxtype.onnx}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
