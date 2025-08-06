{pkgs, ...}: {
  home.packages = with pkgs; [
    gruvbox-plus-icons
    bibata-cursors # manage this directly in WM settings, home-manager fucks up cursor size
  ];

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Gruvbox-Plus-Dark";
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

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
