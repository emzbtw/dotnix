{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rclone
  ];

  # Rclone systemd service & timer
  systemd.services.rclone-gdrive-sync = {
    description = "Sync local folder to Google Drive";
    serviceConfig = {
      Type = "oneshot";
      User = "emz";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone sync /home/emz/Syncthing/keepassxc/ gdrive:keepassxc/ \
          --fast-list --transfers=4 --checkers=4 --delete-during \
          --exclude ".*/" \
          --log-file=/home/emz/Backup/rclone-sync.log --log-level INFO
      '';
    };
  };

  systemd.timers.rclone-gdrive-sync = {
    description = "Run rclone Google Drive sync every 8 hours";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "8h";
      Persistent = true;
    };
  };
}
