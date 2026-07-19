{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/ly.nix
    ../../modules/packages.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/fonts.nix
    ../../modules/portals.nix
    ../../modules/theme.nix
    ../../modules/nh.nix
    ../../modules/overlays.nix
    ../../modules/local-hardware-clock.nix
    ../../modules/quickshell.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "nowatchdog"
    "modprobe.blacklist=sp5100_tco"
    "modprobe.blacklist=iTCO_wdt"
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=2,3 card_label="VirtCam1,VirtCam2" exclusive_caps=1,1
  '';

  boot.tmp = {
    useTmpfs = false;
    tmpfsSize = "30%";
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  boot.plymouth.enable = true;

  nix.optimise.automatic = true;
  nix.settings = {
    auto-optimise-store = true;
    max-jobs = 3;
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nikospc";
  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.enable = false;
  services.smartd.enable = false;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.udev.enable = true;
  services.envfs.enable = true;
  services.dbus.enable = true;
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  services.libinput.enable = true;
  services.rpcbind.enable = true;
  services.nfs.server.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
       )
     {
       return polkit.Result.YES;
     }
    })
  '';
  security.pam.services.swaylock.text = "auth include login";

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;

  console.keyMap = "us";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";
  };

  users.users.arseniy = {
    isNormalUser = true;
    description = "arseniy";
    extraGroups = [ "networkmanager" "wheel" "video" "i2c" "input" "libvirtd" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  system.stateVersion = "24.11";
}
