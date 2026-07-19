{ pkgs, lib, config, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hyprland ecosystem
    hypridle
    hyprpolkitagent
    uwsm
    hyprlang
    hyprshot
    hyprshutdown
    hyprcursor
    hyprland-qt-support
    nwg-displays
    nwg-look
    waypaper
    ddcutil

    # Audio
    brightnessctl
    playerctl
    wl-clipboard
    cliphist
    libnotify
    glib
    pavucontrol
    networkmanagerapplet
    file-roller
    nautilus
    mpv
    ffmpeg
    socat
    jq
    yq-go
    rsync
    bc
    xdg-utils
    xdg-user-dirs
    unzip
    unrar

    # Apps
    scrcpy
    hyfetch
    upscayl
    wine
    protonup-qt
    android-tools
    blender
    krita
    osu-lazer-bin
    zsh
    alacritty
    vesktop
    telegram-desktop
    go
    alejandra
    uv
    onefetch
    wtype

    # Terminals
    ghostty
    kitty
    wezterm

    # Editors
    zed-editor
    micro
    helix

    # CLI tools
    fastfetch
    onefetch
    inxi
    eza
    zoxide
    fd
    ripgrep
    fzf
    bat
    tmux
    yazi
    bottom
    btop
    htop
    atop
    lazygit
    lazydocker
    curl
    wget
    findutils
    killall
    procps
    file
    bc
    jq

    # System utils
    nvtopPackages.nvidia
    nvtopPackages.full
    dua
    dysk
    ncdu
    dust
    baobab
    btrfs-progs
    timeshift
    duf
    figlet
    ffmpeg
    fd
    feh
    gcc
    git
    glib
    gnome-system-monitor
    gsettings-qt
    fastfetch
    gearlever
    gnumake
    grim
    grimblast
    gtk-engine-murrine
    imagemagick
    pciutils
    networkmanagerapplet
    pamixer
    pavucontrol
    pulseaudio
    playerctl
    rofi
    slurp
    swappy
    swaynotificationcenter
    wdisplays
    wl-clipboard
    wlr-randr
    wlogout
    xarchiver
    yad
    yt-dlp
    wallust

    # Fun
    cbonsai
    pipes
    nyancat
    sl
    cowsay
    fortune
    cmatrix
    lolcat
    figlet

    # Hardware
    bandwhich
    cyme
    gdu
    glances
    gping
    ipfetch
    pfetch
    smartmontools
    lm_sensors
    mission-center

    # Dev
    lua
    lua55Packages.luacheck
    luarocks
    lua-language-server
    stylua
    cargo
    clang
    cmake

    # Virtualization
    virt-viewer
    libvirt
    qemu
    qemu-utils
    virt-manager
    bridge-utils
    distrobox

    # Video
    vlc
    obs-studio

    # Utils
    ctop
    erdtree
    frogmouth
    lstr
    macchina
    mcat
    mdcat
    parallel-disk-usage
    pik
    oh-my-posh
    ncdu
    ncftp
    netop
    starship
    trippy
    tldr
    tuptime
    ugrep
    v4l-utils
    procs
    hexyl
    xh
    hyperfine
    delta
    dust
    dog
    tokei
    choose
    visidata
    fx
    gron
    miller
    dasel
    glow
    direnv
    just
    tig
    gitui
    gh
    statix
    deadnix
    atuin
    mcfly
    nushell
    watchexec
    mprocs
    duckdb

    # Shells
    fish
    nushell
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    kdeconnect.enable = true;
    firefox.enable = true;
    hyprlock.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    git.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
      ];
    };
    tmux.enable = true;
    nm-applet.indicator = true;
    neovim = {
      enable = true;
      defaultEditor = false;
    };
    thunar.enable = true;
    thunar.plugins = with pkgs; [
      xfce4-exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];
  };

  hardware.opentabletdriver.enable = true;
  services.flatpak.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nss nspr atk cairo pango gtk3 libdrm mesa alsa-lib
  ];

  systemd.user.services.polkit-agent =
    let
      polkitAgentScript = pkgs.writeShellScript "polkit-agent" ''
        if [ -x "${lib.getExe pkgs.hyprpolkitagent}" ]; then
          exec "${lib.getExe pkgs.hyprpolkitagent}"
        fi
        if [ -x "${lib.getExe' pkgs.mate-polkit "polkit-mate-authentication-agent-1"}" ]; then
          exec "${lib.getExe' pkgs.mate-polkit "polkit-mate-authentication-agent-1"}"
        fi
        echo "No supported polkit agent found." >&2
        exit 1
      '';
    in
    {
      description = "Polkit authentication agent";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = polkitAgentScript;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

  environment.variables = {

  };
}
