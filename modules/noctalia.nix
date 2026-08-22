{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };
  services.displayManager.noctalia-greeter.enable = true;
}
