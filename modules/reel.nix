{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.reel.packages.${system}.default
  ];

  systemd.services.reel-sync = {
    description = "Sync Obsidian media wishlist with Seerr";
    after = ["seerr.service"];
    wants = ["seerr.service"];
    serviceConfig = {
      Type = "oneshot";
      User = "emz";
      ExecStart = "${inputs.reel.packages.${pkgs.system}.default}/bin/reel sync --quiet --yes";
      Environment = "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };

  systemd.timers.reel-sync = {
    description = "Run reel sync periodically";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "60min";
      Unit = "reel-sync.service";
    };
  };
}
