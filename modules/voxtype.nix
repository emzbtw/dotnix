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
    path = [voxtype.osd-native];
    serviceConfig = {
      ExecStart = "${voxtype.onnx}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
