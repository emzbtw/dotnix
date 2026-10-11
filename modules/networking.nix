{config, ...}: {
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";

    # nameservers = [
    #   "9.9.9.9#dns.quad9.net"
    #   "149.112.112.112#dns.quad9.net"
    #   "2620:fe::fe#dns.quad9.net"
    #   "2620:fe::9#dns.quad9.net"
    # ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false";
      Domains = ["~."];
      DNSOverTLS = "true";
      FallbackDNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
      ];
    };
  };

  # ControlD over DoT first, Quad9 after it. resolved ignores FallbackDNS once
  # DNS= is set, so Quad9 is repeated here. The resolver ID comes from sops.
  sops.templates."resolved-controld.conf" = {
    path = "/etc/systemd/resolved.conf.d/controld.conf";
    owner = "systemd-resolve";
    restartUnits = ["systemd-resolved.service"];
    content = let
      host = "${config.sops.placeholder."controld/resolver_id"}.dns.controld.com";
    in ''
      [Resolve]
      DNS=76.76.2.22#${host} 2606:1a40::22#${host} 9.9.9.9#dns.quad9.net 2620:fe::fe#dns.quad9.net
    '';
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
