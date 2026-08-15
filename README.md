# ❄️ dotnix

My personal, single-machine [NixOS](https://nixos.org) configuration, managed with **flakes**, no Home Manager. KDE Plasma 6, a fish/Ghostty daily driver, and a self-hosted media stack, all declared here.

This isn't meant as a drop-in template: hardware paths, hostnames, and a fair number of opinions are baked in. Feel free to poke around for ideas.

## System

| | |
|---|---|
| **CPU** | AMD Ryzen 5 3600 (6c/12t, single CCD/CCX) |
| **GPU** | NVIDIA GTX 970 (proprietary driver) |
| **RAM** | 16GB |
| **Desktop** | KDE Plasma 6 on Wayland, via PLM (Plasma Login Manager) instead of SDDM |
| **Shell / Terminal** | fish / Ghostty |
| **Editor** | Neovim (LazyVim, unmanaged by Nix) |
| **Kernel** | `linuxPackages_latest`, `scx_lavd` scheduler via `services.scx.enable` |

## Structure

```
.
├── flake.nix / flake.lock
├── configuration.nix          # thin entrypoint, imports modules/
├── hardware-configuration.nix
├── justfile                   # command runner: rebuilds, git shortcuts, search
├── .sops.yaml                 # sops-nix recipient keys (public, safe to commit)
├── secrets/
│   └── secrets.yaml           # sops-encrypted values only
└── modules/
    ├── desktop.nix             # Plasma 6 + PLM display manager
    ├── flatpak.nix              # Flatpak support (nix-flatpak)
    ├── gaming.nix                # Steam, gamemode, MangoHud
    ├── glance.nix                 # Glance dashboard
    ├── keepassxc.nix               # KeePassXC + backup service
    ├── neovim.nix                   # Neovim, nixd LSP, format-on-save
    ├── networking.nix                # network config, Bluetooth
    ├── nixflix.nix                    # Jellyfin / *arr / SABnzbd / Seerr / Recyclarr
    ├── nvidia.nix                      # NVIDIA proprietary driver
    ├── packages.nix                     # system-wide packages
    ├── rclone.nix                        # rclone, cloud remote sync/backup
    ├── reel.nix                           # reel, a Go TUI/CLI for Seerr, flake-packaged
    ├── secrets.nix                         # sops-nix wiring (age keys, sops.secrets)
    ├── shell.nix                            # fish, Ghostty, CLI/TUI tools
    ├── spicetify.nix                         # spicetify-nix (Spotify theming)
    ├── syncthing.nix                          # Syncthing, syncs files to devices over the LAN
    ├── system.nix                              # boot, stateVersion, sudo, SSH
    └── tailscale.nix                            # Tailscale mesh VPN
```

Modules are organized **by concern, not chronology**: a new setting goes into the module it belongs to, or gets its own file only once that concern is stable.

## Highlights

- **Flakes, no Home Manager.** Kept deliberately simple; complexity gets added only once a workflow has stabilized (YAGNI over structure-for-its-own-sake).
- **`nh` + `just`** for the rebuild loop: `just switch` / `try` / `build` map to `nh os switch` / `test` / `build`, plus an `upgrade` recipe for bumping flake inputs and git shortcuts (`add`, `commit`, `push`, `diff`, `log`) scoped to this repo.
- **`sops-nix`** for secrets, with separate machine and personal age keys. Encrypts values only, so the repo stays public and human-readable.
- **`nixflix`**: a self-hosted media stack (Jellyfin, Sonarr, Radarr, Prowlarr, SABnzbd, Seerr, Recyclarr) run direct-play only, since the GTX 970 doesn't handle 10-bit HEVC decode.
- **`reel`**: a small Go TUI/CLI for Seerr, packaged as its own flake and installed system-wide.
- **`scx_lavd`** sched_ext scheduler / 1%-low focus on GPU-bound gaming loads.
- **`nixd`** wired into Neovim for evaluation-based NixOS option completion and hover docs against this flake's own `nixosConfigurations`.
- **`alejandra`** formatting, wired into `conform.nvim` for format-on-save on `.nix` files.

## Workflow

```
just switch     # nh os switch, apply and set as boot default
just try        # nh os test, activate without changing boot default
just build      # nh os build, compile-check only
just upgrade    # bump all flake inputs, rebuild, --ask before activating
just add / commit / push   # git shortcuts scoped to this repo
```

Run `just --list` (or bare `just`) from the repo for the full, grouped recipe list.

## Notes

- `/etc/nixos` is a symlink to this repo, kept for tooling that assumes the default path.
- Public on purpose: nothing here is a secret; actual secrets go through `sops-nix` rather than a private repo.
