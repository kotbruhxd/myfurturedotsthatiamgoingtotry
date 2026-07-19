# MyFurturedots

Three dotfiles configs for Hyprland/Niri on NixOS with shared host `nikospc`.

[Русский](README_ru.md) | English

## Projects

| Project | Directory | Compositor |
|---------|-----------|------------|
| iNiR | `iNiR/` | Niri |
| end4 | `end4/dots-hyprland/` | Hyprland |
| ml4w | `ml4w/dotfiles/` | Hyprland |

## Installation

### Automatic (via setup script)

```bash
# iNiR
cd ~/myfurturedots/iNiR
./setup install

# end4
cd ~/myfurturedots/end4/dots-hyprland
./setup install

# ml4w
cd ~/myfurturedots/ml4w/dotfiles
./setup install
```

### Manual (NixOS only)

```bash
# First add all files to git
cd ~/myfurturedots/<project>
git add -A

# Apply NixOS configuration
sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config
```



## Structure

```
myfurturedots/
├── iNiR/
│   ├── nix/                    # NixOS modules
│   │   ├── hosts/nikospc/      # Host config
│   │   └── modules/            # Packages, services, drivers
│   ├── flake.nix               # NixOS flake
│   ├── dots/                   # Dotfiles to copy
│   └── setup                   # Setup script
├── end4/dots-hyprland/
│   ├── hosts/nikospc/          # Host config
│   ├── modules/                # NixOS modules
│   ├── flake.nix               # NixOS flake
│   ├── dots/                   # Dotfiles to copy
│   └── setup                   # Setup script
└── ml4w/dotfiles/
    ├── hosts/nikospc/          # Host config
    ├── modules/                # NixOS modules
    ├── flake.nix               # NixOS flake
    ├── dotfiles/               # Dotfiles to copy
    └── setup/                  # Setup scripts
```

## Common

- Host: `nikospc`
- User: `arseniy`
- Shell: fish
- Display manager: ly
- GPU: NVIDIA + Intel
- SecureBoot: lanzaboote
- Spicetify: catppuccin mocha

## Credits

This is a personal collection of dotfiles based on the following projects:

### iNiR
- **Author:** [snowarch](https://github.com/snowarch/inir)
- **License:** MIT
- **Description:** Complete desktop shell for Niri, built on Quickshell
- **Original:** https://github.com/snowarch/inir

### end4 (illogical-impulse)
- **Author:** [end-4](https://github.com/end-4/dots-hyprland)
- **License:** MIT
- **Description:** Material Design desktop for Hyprland with dynamic color theming
- **Original:** https://github.com/end-4/dots-hyprland

### ML4W OS
- **Author:** [mylinuxforwork](https://github.com/mylinuxforwork/dotfiles)
- **License:** GPL-3.0
- **Description:** Advanced Hyprland configuration for Arch Linux
- **Original:** https://github.com/mylinuxforwork/dotfiles
- **Inspired by:** [JaKooLit](https://github.com/JaKooLit/Hyprland-Dots), [prasanthrangan](https://github.com/prasanthrangan/hyprdots)

### NixOS Configuration
- Based on personal NixOS-Hyprland configuration
- Uses [NixOS](https://nixos.org/), [home-manager](https://github.com/nix-community/home-manager), [catppuccin](https://github.com/catppuccin/nix), [lanzaboote](https://github.com/nix-community/lanzaboote), [spicetify-nix](https://github.com/Gerg-L/spicetify-nix)
