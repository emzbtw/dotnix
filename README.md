# ❄️ dotnix

My personal, single-machine [NixOS](https://nixos.org) configuration, managed with **flakes**, no Home Manager. A [Umbriel](https://github.com/noctalia-dev/umbriel) + [Noctalia](https://github.com/noctalia-dev/noctalia) Wayland desktop, a fish/Ghostty daily driver, a CUDA llama.cpp server, and a self-hosted media stack, all declared here.

This isn't meant as a drop-in template: hardware paths, hostnames, and a fair number of opinions are baked in. Feel free to poke around for ideas.

## System

| | |
|---|---|
| **CPU** | AMD Ryzen 5 3600 (6c/12t, single CCD/CCX) |
| **GPU** | NVIDIA GTX 970 (GM204/Maxwell, proprietary `legacy_580`) |
| **RAM** | 16GB |
| **Compositor** | Umbriel (wlroots + SceneFX), Xwayland via xwayland-satellite |
| **Shell (desktop)** | Noctalia v5, with noctalia-greeter as display manager |
| **Shell / Terminal** | fish / Ghostty |
| **Editor** | Neovim (LazyVim, unmanaged by Nix) + Zed |
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
    ├── desktop.nix             # gvfs, GTK/Qt integration, theming, fonts
    ├── flatpak.nix              # Flatpak support (nix-flatpak)
    ├── gaming.nix                # Steam, gamemode, Proton-GE, MangoHud
    ├── glance.nix                 # Glance dashboard
    ├── hyprland.nix                # disabled — kept from the migration path
    ├── keepassxc.nix                # KeePassXC + backup service
    ├── llama-cpp.nix                 # CUDA llama.cpp server + MCP wiring
    ├── neovim.nix                     # Neovim, nix-ld, lua-language-server
    ├── networking.nix                  # hostname, NetworkManager, Quad9 DoT, Bluetooth
    ├── niri.nix                         # disabled — kept from the migration path
    ├── nixflix.nix                       # Jellyfin / *arr / SABnzbd / Seerr / Recyclarr
    ├── noctalia.nix                       # Noctalia shell + greeter
    ├── nvidia.nix                          # driver, CUDA capability pin, CUDA cache
    ├── packages.nix                         # system-wide packages
    ├── rclone.nix                            # rclone, cloud remote sync/backup
    ├── reel.nix                               # reel, a Go TUI/CLI for Seerr, flake-packaged
    ├── secrets.nix                             # sops-nix wiring (age keys, sops.secrets)
    ├── shell.nix                                # fish, Ghostty, CLI/TUI tools
    ├── spicetify.nix                             # spicetify-nix (Spotify theming)
    ├── syncthing.nix                              # Syncthing, syncs files over the LAN
    ├── system.nix                                  # boot, kernel, scheduler, locale, audio, user
    ├── tailscale.nix                                # Tailscale mesh VPN
    └── umbriel.nix                                   # Umbriel compositor + portal
```

Modules are organized **by concern, not chronology**: a new setting goes into the module it belongs to, or gets its own file only once that concern is stable.

## Highlights

- **Flakes, no Home Manager.** Kept deliberately simple; complexity gets added only once a workflow has stabilized (YAGNI over structure-for-its-own-sake).
- **Umbriel + Noctalia**, after a KDE Plasma → niri → Hyprland → Umbriel migration. Compositor from a flake input, shell and greeter from nixpkgs. Xwayland is on-demand via `xwayland-satellite` with no configuration beyond the package being present.
- **`nh` + `just`** for the rebuild loop: `just switch` / `try` / `build` map to `nh os switch` / `test` / `build`, plus `upgrade` for bumping flake inputs and git shortcuts (`add`, `commit`, `push`, `diff`, `log`) scoped to this repo.
- **`sops-nix`** for secrets, with separate machine and personal age keys. Encrypts values only, so the repo stays public and human-readable.
- **`nixflix`**: a self-hosted media stack (Jellyfin, Sonarr, Sonarr-Anime, Radarr, Prowlarr, SABnzbd, Seerr, Recyclarr) run direct-play only, since GM204 can't decode 10-bit HEVC. Indexers and quality profiles are declared in Nix and destructively reconciled on activation.
- **`llama-cpp`** built with `cudaSupport`, served on `:8090` in router mode with an MCP server wired in by absolute store path (the hardened unit has no `$PATH`). `cudaCapabilities` pinned to `5.2` so CUDA builds target only this card.
- **`reel`**: a small Go TUI/CLI for Seerr, packaged as its own flake and run hourly on a systemd timer.
- **`scx_lavd`** sched_ext scheduler, chosen over `scx_bpfland` for 1%-low focus on a topology-simple CPU paired with a GPU bottleneck.
- **`nixd`** wired into both Neovim and Zed for evaluation-based NixOS option completion and hover docs against this flake's own `nixosConfigurations`.
- **`alejandra`** formatting, enforced at three layers: editor format-on-save, a picker helper, and `just fmt`.

## Workflow

```
just switch     # nh os switch, apply and set as boot default
just test       # nh os test, activate without changing boot default
just build      # nh os build, compile-check only
just boot       # nh os boot, for kernel/initrd changes verified via reboot
just upgrade    # bump all flake inputs, rebuild, --ask before activating
just add / commit / push   # git shortcuts scoped to this repo
```

Run `just --list` (or bare `just`) from the repo for the full, grouped recipe list.

Day to day the landing path is a fish function, `nswitch`, which stages, shows a diff, rebuilds, and only offers a commit prompt after a successful build. `just switch` is the raw iteration primitive by comparison — it doesn't stage, so a brand-new untracked module won't be picked up by it.

## Notes

- `/etc/nixos` is a symlink to this repo, kept for tooling that assumes the default path.
- Public on purpose: nothing here is a secret; actual secrets go through `sops-nix` rather than a private repo.
- `hyprland.nix` and `niri.nix` are commented out of `configuration.nix` and kept only as migration reference.
- The `reel` input is a `path:` reference to a local directory, so this flake won't evaluate on a fresh clone without it.
- Editor configs (Neovim/LazyVim, Zed), fish functions, and the Umbriel `config.toml` all live outside this repo by design.
