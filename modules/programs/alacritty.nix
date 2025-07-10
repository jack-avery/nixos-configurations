{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.alacritty;
    settings = {
      font = {
        size = 10.0;
        normal = {
          family = "JetBrainsMono NF";
          style = "Regular";
        };
      };
      window = {
        opacity = 0.95;
        dimensions = {
          lines = 24;
          columns = 110;
        };
      };
    };
    theme = "catppuccin_mocha";
  };
}
