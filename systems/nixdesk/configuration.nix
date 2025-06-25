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
  networking.dhcpcd.enable = true;

  time.timeZone = "Canada/Eastern";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.displayManager.sddm = {
    enable = true;
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 32;
      };
    };
  };
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    oxygen
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # stop that
  services.libinput.mouse.middleEmulation = false;

  # Enable sound with pipewire.
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
      lutris
      librewolf
      shotcut
      joplin-desktop
      vlc
      obs-studio
      prismlauncher
      vesktop
      osu-lazer-bin
      gimp3
      kdePackages.spectacle
      libreoffice
      gpu-screen-recorder-gtk
    ];
  };
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;

  # have docker, but disabled by default
  virtualisation.docker.enable = true;
  systemd.services.docker = {
    wantedBy = pkgs.lib.mkForce [];
    stopIfChanged = pkgs.lib.mkForce true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Old NVidia stuff
  # hardware.graphics.enable = true;
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.beta;
  # };
  # environment.sessionVariables = {
  #   "CLUTTER_DEFAULT_FPS" = 144;
  #   "__GL_SYNC_DISPLAY_DEVICE" = "DP-0";
  #   "__GL_SYNC_TO_VBLANK" = 0;
  #   "KWIN_X11_NO_SYNC_TO_VBLANK" = 1;
  #   "KWIN_X11_REFRESH_RATE" = 144000;
  #   "KWIN_X11_FORCE_SOFTWARE_VSYNC" = 1;
  #   "KITTY_DISABLE_WAYLAND" = 0;
  # };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    git
    xdg-desktop-portal
    bibata-cursors
    xsettingsd
    xorg.xrdb
  ];

  services.logrotate.checkConfig = false;

  system.stateVersion = "24.05";
}
