{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    glance
  ];

  # Glance self-hosted dashboard
  systemd.services.glance = {
    description = "Glance dashboard";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.glance}/bin/glance -config /home/emz/glance/config/glance.yml";
      User = "emz";
      Group = "users";
      Restart = "on-failure";
    };
  };
}
