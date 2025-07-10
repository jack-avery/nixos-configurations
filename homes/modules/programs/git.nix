{...}: {
  programs.git = {
    enable = true;
    userName = "jack-avery";
    userEmail = "47289484+jack-avery@users.noreply.github.com";

    extraConfig = {
      core = {
        editor = "nvim";
      };

      init = {
        defaultBranch = "main";
      };
    };
  };
}
