{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.vidicon.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  # Links the Noctalia template into /run/current-system/sw/share/vidicon/.
  environment.pathsToLink = ["/share/vidicon"];
}
