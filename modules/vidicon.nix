{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.vidicon.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
