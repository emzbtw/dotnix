{config, ...}: {
  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "emz";

  networking.firewall.trustedInterfaces = [config.services.tailscale.interfaceName];
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
}
