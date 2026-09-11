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
        default_lang = "en";
      };
      general.instance_name = "searxng";
      outgoing = {
        request_timeout = 6.0;
        max_request_timeout = 10.0;
        retries = 1;
      };
      # merged by name into the packaged defaults (use_default_settings = true),
      # so only the overrides are needed
      engines = [
        {
          name = "mojeek";
          disabled = false;
        }
        {
          name = "qwant";
          disabled = false;
        }
        {
          name = "duckduckgo web";
          disabled = false;
        }
      ];
    };
  };
}
