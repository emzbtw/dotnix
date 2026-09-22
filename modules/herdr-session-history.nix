{pkgs, ...}: let
  # Herdr rewrites ~/.config/herdr/session.json in place with no backup, and a
  # shutdown race can persist a session with its workspaces pruned (panes die
  # before the server handles SIGTERM, each exit saved as a closed workspace).
  # Keep a rolling history of distinct versions, <utc>_w<workspaces>_<hash>.json,
  # plus a latest.json symlink pointing at the newest one.
  #
  # Upstream (main) already fixes this: a systemd-logind shutdown delay lock plus
  # built-in session-snapshots/ and session-backups/. nixpkgs (0.9.0) has neither,
  # and 0.9.1 only adds session-backups. Delete this module once nixpkgs carries a
  # release with the built-in snapshots.
  #
  # Restore: herdr server stop; cp ~/.local/state/herdr-session-history/latest.json
  # ~/.config/herdr/session.json; herdr   # agents resume their own conversations
  snapshot = pkgs.writeShellApplication {
    name = "herdr-session-snapshot";
    runtimeInputs = [pkgs.coreutils pkgs.findutils pkgs.jq];
    text = ''
      src="$HOME/.config/herdr/session.json"
      dir="''${XDG_STATE_HOME:-$HOME/.local/state}/herdr-session-history"
      keep=200

      [ -f "$src" ] || exit 0
      mkdir -p "$dir"

      hash="$(sha256sum "$src" | cut -c1-12)"
      if [ -n "$(find "$dir" -maxdepth 1 -name "*_''${hash}.json" -print -quit)" ]; then
        exit 0
      fi

      workspaces="$(jq -r '.workspaces | length' "$src" 2>/dev/null || echo unknown)"
      name="$(date -u +%Y-%m-%dT%H-%M-%SZ)_w''${workspaces}_''${hash}.json"
      cp "$src" "$dir/$name"
      ln -sfn "$name" "$dir/latest.json"

      # Timestamp prefixes: glob order is age order (legacy epoch names sort
      # ahead of ISO names, so mixed directories stay oldest-first too).
      # Skip symlinks so latest.json is never counted or pruned.
      snapshots=()
      for f in "$dir"/*.json; do
        [ -f "$f" ] && [ ! -L "$f" ] && snapshots+=("$f")
      done
      for ((i = 0; i < ''${#snapshots[@]} - keep; i++)); do
        rm -f -- "''${snapshots[i]}"
      done
    '';
  };
in {
  systemd.user.services.herdr-session-snapshot = {
    description = "Snapshot Herdr's saved session";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${snapshot}/bin/herdr-session-snapshot";
    };
  };

  systemd.user.timers.herdr-session-snapshot = {
    description = "Snapshot Herdr's saved session every minute";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
      Unit = "herdr-session-snapshot.service";
    };
  };
}
