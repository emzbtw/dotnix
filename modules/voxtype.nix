{
  inputs,
  pkgs,
  ...
}: let
  voxtype = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = [voxtype.onnx voxtype.osd-native];
}
