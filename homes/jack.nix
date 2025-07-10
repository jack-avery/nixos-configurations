{pkgs, ...}: {
  home.username = "jack";
  home.homeDirectory = "/home/jack";

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "/usr/local/bin"
  ];

  home.packages = with pkgs; [
    zip
    unzip
    xz

    file
    which
    tree
    ripgrep

    btop
    inxi
    fastfetch
    wl-clipboard

    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    tmux
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
