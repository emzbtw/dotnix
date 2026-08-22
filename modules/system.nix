{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05"; # system stateVersion

  # Bootloader.
  boot = {
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    loader.systemd-boot = {
      enable = true;
      consoleMode = "max";
      configurationLimit = 10;
    };
    initrd.systemd.enable = true;
    initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    kernel.sysctl = {"vm.swappiness" = 10;};
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Scheduler
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."emz" = {
    isNormalUser = true;
    description = "emz";
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.fish;
    packages = [];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.gnome.gcr-ssh-agent.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # $EDITOR
  #environment.variables.EDITOR = "vim";

  # External monitor tools
  hardware.i2c.enable = true;

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a4552316-f769-4f00-b4b0-0fbe492c855e";
    fsType = "ext4";
    options = ["defaults" "nofail"];
  };
}
