# MyFurturedots

Три конфига для Hyprland/Niri на NixOS с общим хостом `nikospc`.

English | [Русский](#установка)

## Проекты

| Проект | Директория | Композитор |
|--------|------------|------------|
| iNiR | `iNiR/` | Niri |
| end4 | `end4/dots-hyprland/` | Hyprland |
| ml4w | `ml4w/dotfiles/` | Hyprland |

## Установка

### Автоматически (через скрипт)

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

### Вручную (только NixOS)

```bash
# Сначала добавить все файлы в git
cd ~/myfurturedots/<проект>
git add -A

# Применить конфигурацию NixOS
sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config
```



## Структура

```
myfurturedots/
├── iNiR/
│   ├── nix/                    # NixOS модули
│   │   ├── hosts/nikospc/      # Конфиг хоста
│   │   └── modules/            # Пакеты, сервисы, драйверы
│   ├── flake.nix               # Flake для NixOS
│   ├── dots/                   # Dotfiles для копирования
│   └── setup                   # Скрипт установки
├── end4/dots-hyprland/
│   ├── hosts/nikospc/          # Конфиг хоста
│   ├── modules/                # NixOS модули
│   ├── flake.nix               # Flake для NixOS
│   ├── dots/                   # Dotfiles для копирования
│   └── setup                   # Скрипт установки
└── ml4w/dotfiles/
    ├── hosts/nikospc/          # Конфиг хоста
    ├── modules/                # NixOS модули
    ├── flake.nix               # Flake для NixOS
    ├── dotfiles/               # Dotfiles для копирования
    └── setup/                  # Скрипты установки
```

## Общее

- Хост: `nikospc`
- Пользователь: `arseniy`
- Shell: fish
- Дисплей-менеджер: ly
- GPU: NVIDIA + Intel
- SecureBoot: lanzaboote
- Spicetify: catppuccin mocha

## Авторы

Личная коллекция dotfiles на основе следующих проектов:

### iNiR
- **Автор:** [snowarch](https://github.com/snowarch/inir)
- **Лицензия:** MIT
- **Описание:** Полная рабочая оболочка для Niri на Quickshell
- **Оригинал:** https://github.com/snowarch/inir

### end4 (illogical-impulse)
- **Автор:** [end-4](https://github.com/end-4/dots-hyprland)
- **Лицензия:** MIT
- **Описание:** Material Design рабочий стол для Hyprland с динамическим окрашиванием
- **Оригинал:** https://github.com/end-4/dots-hyprland

### ML4W OS
- **Автор:** [mylinuxforwork](https://github.com/mylinuxforwork/dotfiles)
- **Лицензия:** GPL-3.0
- **Описание:** Продвинутая конфигурация Hyprland для Arch Linux
- **Оригинал:** https://github.com/mylinuxforwork/dotfiles
- **Вдохновлено:** [JaKooLit](https://github.com/JaKooLit/Hyprland-Dots), [prasanthrangan](https://github.com/prasanthrangan/hyprdots)

### NixOS конфигурация
- На основе личной конфигурации NixOS-Hyprland
- Использует [NixOS](https://nixos.org/), [home-manager](https://github.com/nix-community/home-manager), [catppuccin](https://github.com/catppuccin/nix), [lanzaboote](https://github.com/nix-community/lanzaboote), [spicetify-nix](https://github.com/Gerg-L/spicetify-nix)
