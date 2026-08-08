{config, ...}: {
  nixflix = {
    enable = true;
    mediaDir = "/mnt/storage/data/media";
    downloadsDir = "/mnt/storage/data/downloads";
    stateDir = "/var/lib/nixflix";

    sonarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."sonarr/api_key".path;};
        hostConfig = {
          username = "admin";
          password = {_secret = config.sops.secrets."sonarr/password".path;};
        };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."radarr/api_key".path;};
        hostConfig = {
          username = "admin";
          password = {_secret = config.sops.secrets."radarr/password".path;};
        };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."prowlarr/api_key".path;};
        hostConfig = {
          username = "admin";
          password = {_secret = config.sops.secrets."prowlarr/password".path;};
        };
      };
    };

    usenetClients.sabnzbd = {
      enable = true;
      settings = {
        misc = {
          api_key = {_secret = config.sops.secrets."sabnzbd/api_key".path;};
          nzb_key = {_secret = config.sops.secrets."sabnzbd/nzb_key".path;};
        };
        servers = [
          {
            name = "primary";
            host = "sslreader.eweka.nl";
            port = 563;
            ssl = true;
            connections = 50;
            priority = 0;
            retention = 6564;
            username = {_secret = config.sops.secrets."usenet/eweka/username".path;};
            password = {_secret = config.sops.secrets."usenet/eweka/password".path;};
          }
        ];
      };
    };

    jellyfin = {
      enable = true;
      apiKey = {_secret = config.sops.secrets."jellyfin/api_key".path;};
      users.admin = {
        policy.isAdministrator = true;
        password = {_secret = config.sops.secrets."jellyfin/admin_password".path;};
      };
    };

    seerr = {
      enable = true;
      apiKey = {_secret = config.sops.secrets."seerr/api_key".path;};

      radarr.default = {
        apiKey = {_secret = config.sops.secrets."radarr/api_key".path;};
        isDefault = true;
      };

      sonarr.default = {
        apiKey = {_secret = config.sops.secrets."sonarr/api_key".path;};
        isDefault = true;
      };
    };
  };
}
