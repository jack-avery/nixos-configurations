{pkgs, ...}: {
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
    corefonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
