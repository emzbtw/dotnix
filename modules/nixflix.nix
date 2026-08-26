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

    sonarr-anime = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."sonarr-anime/api_key".path;};
        hostConfig = {
          username = "admin";
          password = {_secret = config.sops.secrets."sonarr-anime/password".path;};
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

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."prowlarr/api_key".path;};
        hostConfig = {
          username = "admin";
          password = {_secret = config.sops.secrets."prowlarr/password".path;};
        };
        indexers = [
          {
            name = "DrunkenSlug";
            apiKey = {_secret = config.sops.secrets."prowlarr/indexers/drunkenslug/api_key".path;};
          }
          {
            name = "NZBFinder";
            apiKey = {_secret = config.sops.secrets."prowlarr/indexers/nzbfinder/api_key".path;};
          }
          {
            name = "NZBgeek";
            apiKey = {_secret = config.sops.secrets."prowlarr/indexers/nzbgeek/api_key".path;};
          }
        ];
      };
    };

    usenetClients.sabnzbd = {
      enable = true;
      settings = {
        misc = {
          api_key = {_secret = config.sops.secrets."sabnzbd/api_key".path;};
          nzb_key = {_secret = config.sops.secrets."sabnzbd/nzb_key".path;};
          bandwidth_max = "100M";
          bandwidth_perc = 80;
          cache_limit = "1G";
          download_dir = "/var/lib/sabnzbd/incomplete";
          download_free = "25G";
          unwanted_extensions = "ade, adp, app, application, appref-ms, asp, aspx, asx, bas, bat, bgi, cab, cer, chm, cmd, cnt, com, cpl, crt, csh, der, diagcab, exe, fxp, gadget, grp, hlp, hpj, hta, htc, inf, ins, iso, isp, its, jar, jnlp, js, jse, ksh, lnk, mad, maf, mag, mam, maq, mar, mas, mat, mau, mav, maw, mcf, mda, mdb, mde, mdt, mdw, mdz, msc, msh, msh1, msh2, mshxml, msh1xml, msh2xml, msi, msp, mst, msu, ops, osd, pcd, pif, pl, plg, prf, prg, printerexport, ps1, ps1xml, ps2, ps2xml, psc1, psc2, psd1, psdm1, pst, py, pyc, pyo, pyw, pyz, pyzw, reg, scf, scr, sct, shb, shs, sln, theme, tmp, url, vb, vbe, vbp, vbs, vcxproj, vhd, vhdx, vsmacros, vsw, webpnp, website, ws, wsc, wsf, wsh, xbap, xll, xnk";
          action_on_unwanted_extensions = 2;
        };
        servers = [
          {
            name = "Eweka";
            host = "news.eweka.nl";
            port = 563;
            ssl = true;
            connections = 20;
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
    };
  };
}
