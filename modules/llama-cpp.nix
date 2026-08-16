{pkgs, ...}: let
  llama-cpp-cuda = pkgs.llama-cpp.override {
    cudaSupport = true;
  };
in {
  services.llama-cpp = {
    enable = true;
    package = llama-cpp-cuda;
    openFirewall = false;
    settings = {
      models-preset = "/mnt/storage/models/presets.ini";
      models-max = 1;
      port = 8090;
    };
  };

  environment.systemPackages = [llama-cpp-cuda];
}
