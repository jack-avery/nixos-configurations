{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    vimAlias = false;
    viAlias = false;
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
      plenary-nvim
      telescope-nvim
      gitsigns-nvim
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
      vim.opt.clipboard = { 'unnamed', 'unnamedplus' }

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
      source = ../../config/nvim/plugins;
    };
    "nvim/after/ftplugin" = {
      recursive = true;
      source = ../../config/nvim/ftplugin;
    };
  };
}
