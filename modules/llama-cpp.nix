{pkgs, ...}: let
  llama-cpp-cuda = pkgs.llama-cpp.override {
    cudaSupport = true;
    # CUDA 13 dropped Maxwell (cudaCapabilities 5.2); 12.9 is the last release with it.
    cudaPackages = pkgs.cudaPackages_12_9;
  };
  mcpServersConfig = pkgs.writeText "llama-cpp-mcp-servers.json" (builtins.toJSON {
    mcpServers.nixos = {command = "${pkgs.mcp-nixos}/bin/mcp-nixos";};
  });
in {
  services.llama-cpp = {
    enable = true;
    package = llama-cpp-cuda;
    openFirewall = false;
    settings = {
      models-preset = "/mnt/storage/models/presets.ini";
      models-max = 1;
      port = 8090;
      mcp-servers-config = mcpServersConfig;
    };
  };

  environment.systemPackages = [llama-cpp-cuda];
}
