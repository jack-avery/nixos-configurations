{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixdesk";
  networking.networkmanager.enable = true;

  time.timeZone = "Canada/Eastern";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.xfce4.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jack = {
    isNormalUser = true;
    description = "jack";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      flatpak
      gnome-software
      librewolf
      kitty
      shotcut
      vlc
      obs-studio
      prismlauncher
      vesktop
      osu-lazer-bin
      pinta
    ];
  };
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;
  virtualisation.docker.enable = true;

  # NVidia
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  environment.sessionVariables = {
    "CLUTTER_DEFAULT_FPS" = 144;
    "__GL_SYNC_DISPLAY_DEVICE" = "DP-0";
    "__GL_SYNC_TO_VBLANK" = 0;
    "KWIN_X11_NO_SYNC_TO_VBLANK" = 1;
    "KWIN_X11_REFRESH_RATE" = 144000;
    "KWIN_X11_FORCE_SOFTWARE_VSYNC" = 1;
  };
  systemd.services.apply-nvidia = {
    description = "nvidia-settings apply";
    enable = true;
    serviceConfig = {Type = "oneshot";};
    script = "${config.hardware.nvidia.package.settings}/bin/nvidia-settings --load-config-only";
    environment = {DISPLAY = ":0";};
    after = ["plasma-plasmashell.service"];
    wantedBy = ["plasma-workspace.target"];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    xdg-desktop-portal-kde
    git
  ];

  system.stateVersion = "24.05";
}
