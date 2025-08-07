{pkgs, ...}: {
  home.packages = with pkgs; [
    direnv
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };
}
