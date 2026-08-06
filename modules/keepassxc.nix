{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    keepassxc
  ];

  # Keepassxc local backup
  systemd.services.keepassxc-local-backup = {
    description = "Keepassxc local folder backup";
    serviceConfig = {
      Type = "oneshot";
      User = "emz";
      ExecStart = "${pkgs.bash}/bin/bash /home/emz/.local/bin/keepassxc_backup.sh";
    };
  };

  systemd.timers.keepassxc-local-backup = {
    description = "Keepassxc local folder backup timer";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "12h";
      Persistent = true;
    };
  };
}
