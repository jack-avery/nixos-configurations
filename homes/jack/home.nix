{
  config,
  pkgs,
  ...
}: {
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

    btop

    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # lsp, fmt
    cargo
    rustc
    rustfmt
    rust-analyzer

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

    nil
    alejandra
  ];

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

  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      if [ -f '~/git/google-cloud-sdk/path.bash.inc' ]; then . '~/git/google-cloud-sdk/path.bash.inc'; fi
      if [ -f '~/git/google-cloud-sdk/completion.bash.inc' ]; then . '~/git/google-cloud-sdk/completion.bash.inc'; fi
      eval "$(~/.rbenv/bin/rbenv init - bash 2> /dev/null)"

      rc_color() {
          if [[ ! $? == 0 ]] then
              echo -e '\033[0;31m'
          else
              echo -e '\033[0m'
          fi
      }

      git_ps1() {
          local git_status="$(git status 2> /dev/null)"
          local on_branch="On branch ([^$IFS]*)"
          local on_commit="HEAD detached at ([^$IFS]*)"

          if [[ $git_status =~ $on_branch ]]; then
              local branch=''${BASH_REMATCH[1]}
              echo -e " ($branch)"
          elif [[ $git_status =~ $on_commit ]]; then
              local commit=''${BASH_REMATCH[1]}
              echo -e " ($commit)"
          fi
      }

      PROMPT_COMMAND='RC_COLOR=$(rc_color);GITPS1=$(git_ps1)'
      PS1=' \001\033[0;33m\002\W\001\033[0;35m\002''${GITPS1} \001''${RC_COLOR}\002\$ \001\033[0m\002'
    '';

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -ahl";
      l = "ls -Ahl";
      c = "cd ..";
      "cd.." = "cd ..";
      v = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      catppuccin-nvim
      nvim-lspconfig
      nvim-tree-lua
      nvim-web-devicons
      cmp-nvim-lsp
      nvim-cmp
      cmp-vsnip
      vim-vsnip
      trouble-nvim
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "
      require("lazy").setup({
          performance = {
              reset_packpath = false,
              rtp = {
                  reset = false,
              }
          },
          dev = {
              path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
              patterns = {""},
          },
          install = {
              missing = false,
          },
          spec = {
              { import = "plugins" },
          },
      })

      vim.cmd.colorscheme "catppuccin"

      -- General
      vim.opt.number=true
      vim.opt.relativenumber=true
      vim.opt.autoread=true
      vim.opt.smartcase=true
      vim.opt.ignorecase=true
      vim.opt.hlsearch=true
      vim.opt.incsearch=true
      vim.opt.fileencoding="ascii"
      vim.opt.belloff="all"
      vim.opt.paste=false
      vim.opt.modifiable=true

      -- Indentation
      vim.opt.shiftwidth=4
      vim.opt.softtabstop=2
      vim.opt.tabstop=2
      vim.opt.expandtab=true
      vim.opt.smartindent=true
      vim.opt.autoindent=true

      -- Disable swap
      vim.opt.swapfile=false
      vim.opt.backup=false
      vim.opt.wb=false

      -- Fast save & quit
      vim.api.nvim_set_keymap("n", "<leader>w", ":w<cr>", {noremap=true})
      vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", {noremap=true})
      vim.api.nvim_set_keymap("n", "<leader>Q", ":qa!<CR>", {noremap=true})

      -- Indentation binds
      vim.api.nvim_set_keymap("x", "<tab>", ">gv", {noremap=true})
      vim.api.nvim_set_keymap("x", "<s-tab>", "<gv", {noremap=true})
      vim.api.nvim_set_keymap("n", "<tab>", ">>", {noremap=true})
      vim.api.nvim_set_keymap("n", "<s-tab>", "<<", {noremap=true})
      vim.api.nvim_set_keymap("i", "<s-tab>", "<esc><<A", {noremap=true})

      -- Whitespace handling
      vim.opt.list=true
      local space = "·"
      vim.opt.listchars:append {
        tab = "│ ",
        multispace = space,
        lead = space,
        trail = space,
        nbsp = space
      }
      vim.cmd([[match TrailingWhitespace /\s\+$/]])
      vim.api.nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })
      vim.cmd([[filetype plugin on]])
    '';
  };

  xdg.configFile = {
    "nvim/lua/plugins" = {
      recursive = true;
      source = ./nvim/plugins;
    };
    "nvim/after/ftplugin" = {
      recursive = true;
      source = ./nvim/ftplugin;
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}