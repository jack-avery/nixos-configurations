{pkgs, ...}: {
  fonts.packages = with pkgs; [
    jetbrains-mono
    corefonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.noto
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
