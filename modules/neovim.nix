{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    lua-language-server
  ];
}
