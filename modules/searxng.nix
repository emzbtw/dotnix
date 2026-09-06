{
  pkgs,
  config,
  ...
}: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = config.sops.secrets."searxng/secret_key".path;

    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8888;
        secret_key = "$SEARX_SECRET_KEY";
        method = "GET";
        limiter = false;
      };
      search = {
        formats = ["html" "json"];
      };
      general.instance_name = "searxng";
    };
  };
}
