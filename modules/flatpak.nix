{
  services.flatpak = {
    enable = true;

    # Keep flathub explicitly since declaring `remotes` at all overrides the default
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      #"com.stremio.Stremio"
    ];

    update.onActivation = true; # updates run at `nh os switch`, not just install
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    uninstallUnmanaged = false; # leave manually-installed flatpaks alone (least-destructive default)
  };

  environment.sessionVariables.XDG_DATA_DIRS = [
    "/var/lib/flatpak/exports/share"
  ];
}
