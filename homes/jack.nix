{
  pkgs,
  inputs,
  ...
}: let
  theme = "Breeze-Dark";
  iconTheme = "Gruvbox-Plus-Dark";
in {
  home.username = "jack";
  home.homeDirectory = "/home/jack";

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "/usr/local/bin"
  ];

  nixGL.packages = inputs.nixGL.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = ["mesa"];

  gtk = {
    enable = true;
    theme.name = theme;
    iconTheme.name = iconTheme;
    gtk3 = {
      bookmarks = [
        "file:///tmp"
      ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
  dconf.settings."org/gtk/settings/file-chooser" = {
    sort-directories-first = true;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

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

    # desktop
    gruvbox-plus-icons
    bibata-cursors

    # rust ls
    cargo
    rustc
    rustfmt
    rust-analyzer

    # python ls
    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        python-lsp-black
        python-lsp-ruff
        pyls-flake8
        pyls-isort
        isort
        flake8
        black
      ]))

    # nix ls
    nil
    alejandra

    # go ls
    gopls

    # lua ls
    lua-language-server
    stylua
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
