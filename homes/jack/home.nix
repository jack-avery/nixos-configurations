{
  config,
  pkgs,
  ...
}: let
  theme = "Breeze-Dark";
  iconTheme = "Gruvbox-Plus-Dark";
  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = 24;
in {
  home.username = "jack";
  home.homeDirectory = "/home/jack";

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "/usr/local/bin"
  ];

  home.pointerCursor = {
    name = cursorTheme;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
    size = cursorSize;
  };

  gtk = {
    enable = true;
    theme.name = theme;
    iconTheme.name = iconTheme;
    cursorTheme = {
      size = cursorSize;
      name = cursorTheme;
    };
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

    btop

    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # desktop
    gruvbox-plus-icons
    bibata-cursors

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
      PS1=' \001\033[0;33m\002\u\001\033[0m\002@\001\033[0;33m\002\h \W\001\033[0;35m\002''${GITPS1} \001''${RC_COLOR}\002\$ \001\033[0m\002'
    '';

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -ahl";
      l = "ls -Ahl";
      c = "cd ..";
      v = "nvim";
      ssha = "eval `ssh-agent -s` && ssh-add";
    };
  };

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
      source = ./nvim/plugins;
    };
    "nvim/after/ftplugin" = {
      recursive = true;
      source = ./nvim/ftplugin;
    };
  };

  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-ecb86b88-a51f-4913-862e-9c2ef3d6b532" = [];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "com.dec05eba.gpu_screen_recorder"."gpu_screen_recorder_pause_unpause_recording" = "none,Alt+2,Pause/unpause recording";
      "com.dec05eba.gpu_screen_recorder"."gpu_screen_recorder_save_replay" = "Alt+F10,Alt+3,Save replay";
      "com.dec05eba.gpu_screen_recorder"."gpu_screen_recorder_start_stop_recording" = "none,Alt+1,Start/stop recording/replay/streaming";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Touchpad Toggle" "Meta+Ctrl+Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Toggle Touchpad"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Pause" "Meta+Volume Mute" "Microphone Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = "none,,Shut Down Without Confirmation";
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
      "ksmserver"."LogOut" = "none,,Log Out";
      "ksmserver"."Reboot" = "none,,Reboot";
      "ksmserver"."Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
      "ksmserver"."Shut Down" = "none,,Shut Down";
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [];
      "kwin"."Cycle Overview Opposite" = [];
      "kwin"."Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Toggle Present Windows (All desktops)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [];
      "kwin"."MoveZoomLeft" = [];
      "kwin"."MoveZoomRight" = [];
      "kwin"."MoveZoomUp" = [];
      "kwin"."Overview" = "Meta,Meta+W,Toggle Overview";
      "kwin"."Setup Window Shortcut" = "none,,Setup Window Shortcut";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Suspend Compositing" = "none,Alt+Shift+F12,Suspend Compositing";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Switch to Desktop 10" = "none,,Switch to Desktop 10";
      "kwin"."Switch to Desktop 11" = "none,,Switch to Desktop 11";
      "kwin"."Switch to Desktop 12" = "none,,Switch to Desktop 12";
      "kwin"."Switch to Desktop 13" = "none,,Switch to Desktop 13";
      "kwin"."Switch to Desktop 14" = "none,,Switch to Desktop 14";
      "kwin"."Switch to Desktop 15" = "none,,Switch to Desktop 15";
      "kwin"."Switch to Desktop 16" = "none,,Switch to Desktop 16";
      "kwin"."Switch to Desktop 17" = "none,,Switch to Desktop 17";
      "kwin"."Switch to Desktop 18" = "none,,Switch to Desktop 18";
      "kwin"."Switch to Desktop 19" = "none,,Switch to Desktop 19";
      "kwin"."Switch to Desktop 2" = "Ctrl+F2";
      "kwin"."Switch to Desktop 20" = "none,,Switch to Desktop 20";
      "kwin"."Switch to Desktop 3" = "Ctrl+F3";
      "kwin"."Switch to Desktop 4" = "Ctrl+F4";
      "kwin"."Switch to Desktop 5" = "none,,Switch to Desktop 5";
      "kwin"."Switch to Desktop 6" = "none,,Switch to Desktop 6";
      "kwin"."Switch to Desktop 7" = "none,,Switch to Desktop 7";
      "kwin"."Switch to Desktop 8" = "none,,Switch to Desktop 8";
      "kwin"."Switch to Desktop 9" = "none,,Switch to Desktop 9";
      "kwin"."Switch to Next Desktop" = "none,,Switch to Next Desktop";
      "kwin"."Switch to Next Screen" = "none,,Switch to Next Screen";
      "kwin"."Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
      "kwin"."Switch to Previous Screen" = "none,,Switch to Previous Screen";
      "kwin"."Switch to Screen 0" = "none,,Switch to Screen 0";
      "kwin"."Switch to Screen 1" = "none,,Switch to Screen 1";
      "kwin"."Switch to Screen 2" = "none,,Switch to Screen 2";
      "kwin"."Switch to Screen 3" = "none,,Switch to Screen 3";
      "kwin"."Switch to Screen 4" = "none,,Switch to Screen 4";
      "kwin"."Switch to Screen 5" = "none,,Switch to Screen 5";
      "kwin"."Switch to Screen 6" = "none,,Switch to Screen 6";
      "kwin"."Switch to Screen 7" = "none,,Switch to Screen 7";
      "kwin"."Switch to Screen Above" = "none,,Switch to Screen Above";
      "kwin"."Switch to Screen Below" = "none,,Switch to Screen Below";
      "kwin"."Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
      "kwin"."Switch to Screen to the Right" = "none,,Switch to Screen to the Right";
      "kwin"."Toggle Night Color" = [];
      "kwin"."Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = "none,,Walk Through Windows Alternative";
      "kwin"."Walk Through Windows Alternative (Reverse)" = "none,,Walk Through Windows Alternative (Reverse)";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = "none,,Walk Through Windows of Current Application Alternative";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = "none,,Walk Through Windows of Current Application Alternative (Reverse)";
      "kwin"."Window Above Other Windows" = "none,,Keep Window Above Others";
      "kwin"."Window Below Other Windows" = "none,,Keep Window Below Others";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Custom Quick Tile Bottom" = "none,,Custom Quick Tile Window to the Bottom";
      "kwin"."Window Custom Quick Tile Left" = "none,,Custom Quick Tile Window to the Left";
      "kwin"."Window Custom Quick Tile Right" = "none,,Custom Quick Tile Window to the Right";
      "kwin"."Window Custom Quick Tile Top" = "none,,Custom Quick Tile Window to the Top";
      "kwin"."Window Fullscreen" = "none,,Make Window Fullscreen";
      "kwin"."Window Grow Horizontal" = "none,,Expand Window Horizontally";
      "kwin"."Window Grow Vertical" = "none,,Expand Window Vertically";
      "kwin"."Window Lower" = "none,,Lower Window";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
      "kwin"."Window Maximize Vertical" = "none,,Maximize Window Vertically";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = "none,,Move Window";
      "kwin"."Window Move Center" = "none,,Move Window to the Center";
      "kwin"."Window No Border" = "none,,Toggle Window Titlebar and Frame";
      "kwin"."Window On All Desktops" = "none,,Keep Window on All Desktops";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = "none,,Move Window One Screen Down";
      "kwin"."Window One Screen Up" = "none,,Move Window One Screen Up";
      "kwin"."Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
      "kwin"."Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "none,,Move Window Down";
      "kwin"."Window Pack Left" = "none,,Move Window Left";
      "kwin"."Window Pack Right" = "none,,Move Window Right";
      "kwin"."Window Pack Up" = "none,,Move Window Up";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
      "kwin"."Window Raise" = "none,,Raise Window";
      "kwin"."Window Resize" = "none,,Resize Window";
      "kwin"."Window Shade" = "none,,Shade Window";
      "kwin"."Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
      "kwin"."Window Shrink Vertical" = "none,,Shrink Window Vertically";
      "kwin"."Window to Desktop 1" = "none,,Window to Desktop 1";
      "kwin"."Window to Desktop 10" = "none,,Window to Desktop 10";
      "kwin"."Window to Desktop 11" = "none,,Window to Desktop 11";
      "kwin"."Window to Desktop 12" = "none,,Window to Desktop 12";
      "kwin"."Window to Desktop 13" = "none,,Window to Desktop 13";
      "kwin"."Window to Desktop 14" = "none,,Window to Desktop 14";
      "kwin"."Window to Desktop 15" = "none,,Window to Desktop 15";
      "kwin"."Window to Desktop 16" = "none,,Window to Desktop 16";
      "kwin"."Window to Desktop 17" = "none,,Window to Desktop 17";
      "kwin"."Window to Desktop 18" = "none,,Window to Desktop 18";
      "kwin"."Window to Desktop 19" = "none,,Window to Desktop 19";
      "kwin"."Window to Desktop 2" = "none,,Window to Desktop 2";
      "kwin"."Window to Desktop 20" = "none,,Window to Desktop 20";
      "kwin"."Window to Desktop 3" = "none,,Window to Desktop 3";
      "kwin"."Window to Desktop 4" = "none,,Window to Desktop 4";
      "kwin"."Window to Desktop 5" = "none,,Window to Desktop 5";
      "kwin"."Window to Desktop 6" = "none,,Window to Desktop 6";
      "kwin"."Window to Desktop 7" = "none,,Window to Desktop 7";
      "kwin"."Window to Desktop 8" = "none,,Window to Desktop 8";
      "kwin"."Window to Desktop 9" = "none,,Window to Desktop 9";
      "kwin"."Window to Next Desktop" = "none,,Window to Next Desktop";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = "none,,Window to Previous Desktop";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = "none,,Move Window to Screen 0";
      "kwin"."Window to Screen 1" = "none,,Move Window to Screen 1";
      "kwin"."Window to Screen 2" = "none,,Move Window to Screen 2";
      "kwin"."Window to Screen 3" = "none,,Move Window to Screen 3";
      "kwin"."Window to Screen 4" = "none,,Move Window to Screen 4";
      "kwin"."Window to Screen 5" = "none,,Move Window to Screen 5";
      "kwin"."Window to Screen 6" = "none,,Move Window to Screen 6";
      "kwin"."Window to Screen 7" = "none,,Move Window to Screen 7";
      "kwin"."disableInputCapture" = "Meta+Shift+Esc";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = "none,,Media volume down";
      "mediacontrol"."mediavolumeup" = "none,,Media volume up";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = "none,,Play media playback";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B,Battery" "Meta+B,Switch Power Profile"];
      "plasmashell"."activate application launcher" = ["none,Meta" "Alt+F1,Activate Application Launcher"];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = "none,,Activate Task Manager Entry 10";
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";
      "plasmashell"."clear-history" = "none,,Clear Clipboard History";
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = "none,,Next History Item";
      "plasmashell"."cyclePrevAction" = "none,,Previous History Item";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A,none,Walk through activities";
      "plasmashell"."previous activity" = "Meta+Shift+A,none,Walk through activities (Reverse)";
      "plasmashell"."repeat_action" = "none,,Manually Invoke Action on Current Clipboard";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = "none,,Show Barcode…";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = "none,,Switch to Next Activity";
      "plasmashell"."switch to previous activity" = "none,,Switch to Previous Activity";
      "plasmashell"."toggle do not disturb" = "none,,Toggle do not disturb";
      "services/org.kde.krunner.desktop"."_launch" = ["Meta+R" "Alt+F2" "Search" "Alt+Space"];
      "services/org.kde.spectacle.desktop"."RecordRegion" = "Meta+Shift+R";
      "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = [];
      "services/org.kde.spectacle.desktop"."_launch" = ["Meta+Shift+S" "Print"];
      "services/st.desktop"."_launch" = "Meta+Return";
    };
    configFile = {
      "baloofilerc"."General"."dbVersion" = 2;
      "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version" = 9;
      "dolphinrc"."General"."ViewPropsTimestamp" = "2024,10,19,14,24,16.499";
      "dolphinrc"."IconsMode"."PreviewSize" = 48;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "kactivitymanagerdrc"."activities"."ecb86b88-a51f-4913-862e-9c2ef3d6b532" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "ecb86b88-a51f-4913-862e-9c2ef3d6b532";
      "katerc"."General"."Days Meta Infos" = 30;
      "katerc"."General"."Save Meta Infos" = true;
      "katerc"."General"."Show Full Path in Title" = false;
      "katerc"."General"."Show Menu Bar" = true;
      "katerc"."General"."Show Status Bar" = true;
      "katerc"."General"."Show Tab Bar" = true;
      "katerc"."General"."Show Url Nav Bar" = true;
      "katerc"."KTextEditor Renderer"."Animate Bracket Matching" = false;
      "katerc"."KTextEditor Renderer"."Auto Color Theme Selection" = true;
      "katerc"."KTextEditor Renderer"."Color Theme" = "Breeze Dark";
      "katerc"."KTextEditor Renderer"."Line Height Multiplier" = 1;
      "katerc"."KTextEditor Renderer"."Show Indentation Lines" = false;
      "katerc"."KTextEditor Renderer"."Show Whole Bracket Expression" = false;
      "katerc"."KTextEditor Renderer"."Text Font" = "Hack,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1";
      "katerc"."KTextEditor Renderer"."Text Font Features" = "";
      "katerc"."KTextEditor Renderer"."Word Wrap Marker" = false;
      "katerc"."filetree"."editShade" = "31,81,106";
      "katerc"."filetree"."listMode" = false;
      "katerc"."filetree"."middleClickToClose" = false;
      "katerc"."filetree"."shadingEnabled" = true;
      "katerc"."filetree"."showCloseButton" = false;
      "katerc"."filetree"."showFullPathOnRoots" = false;
      "katerc"."filetree"."showToolbar" = true;
      "katerc"."filetree"."sortRole" = 0;
      "katerc"."filetree"."viewShade" = "81,49,95";
      "kcminputrc"."Libinput/1133/49305/Logitech G502 X"."PointerAcceleration" = "-0.200";
      "kcminputrc"."Libinput/1133/49305/Logitech G502 X"."PointerAccelerationProfile" = 1;
      "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = true;
      "kcminputrc"."Mouse"."cursorSize" = 32;
      "kcminputrc"."Mouse"."cursorTheme" = "Bibata-Modern-Classic";
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "1072,768";
      "kdeglobals"."DirSelect Dialog"."Splitter State" = "\x00\x00\x00\xff\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x8c\x00\x00\x02\xa8\x00\xff\xff\xff\xff\x01\x00\x00\x00\x01\x00";
      "kdeglobals"."General"."TerminalApplication" = "st";
      "kdeglobals"."General"."TerminalService" = "st.desktop";
      "kdeglobals"."General"."UseSystemBell" = true;
      "kdeglobals"."Icons"."Theme" = "Gruvbox-Plus-Dark";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = true;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
      "kdeglobals"."KFileDialog Settings"."View Style" = "Simple";
      "kdeglobals"."WM"."activeBackground" = "24,32,48";
      "kdeglobals"."WM"."activeBlend" = "24,32,48";
      "kdeglobals"."WM"."activeForeground" = "211,218,227";
      "kdeglobals"."WM"."inactiveBackground" = "28,37,56";
      "kdeglobals"."WM"."inactiveBlend" = "24,32,48";
      "kdeglobals"."WM"."inactiveForeground" = "141,147,159";
      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "execute";
      "klaunchrc"."BusyCursorSettings"."Bouncing" = false;
      "klipperrc"."General"."KeepClipboardContents" = false;
      "klipperrc"."General"."SelectionTextOnly" = false;
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "ksplashrc"."KSplash"."Theme" = "org.kde.breeze.desktop";
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Id_1" = "5610f14a-3b3a-4368-95e3-27ad8e8330fb";
      "kwinrc"."Desktops"."Number" = 1;
      "kwinrc"."Desktops"."Rows" = 1;
      "kwinrc"."EdgeBarrier"."EdgeBarrier" = 10;
      "kwinrc"."Plugins"."shakecursorEnabled" = false;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling/20cb5b6a-1bdf-50c6-8757-519d5324c007"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/30627bbb-07dc-58bb-b419-82dd3fe9ab5f"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/6654ae0e-e39e-5e6a-93c4-b6d63c5bb645"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/7000e3d9-d7c8-5ffd-adf5-56ebdd331bbc"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/706df368-bba1-5303-9132-186ba07c829a"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/92e842d7-5928-5c43-884a-4912e7cc82ed"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/a6d07d74-da9c-5570-93cd-42928f3dc397"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/c2ee4a23-0772-5b91-8a94-7e0f0db77d37"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/c3ff9b55-f506-5e26-8a8e-ad4d837b9173"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/cde44522-723e-5700-aa7c-7ba5490b08ba"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Windows"."ElectricBorderCooldown" = 200;
      "kwinrc"."Windows"."ElectricBorderDelay" = 0;
      "kwinrc"."Xwayland"."Scale" = 1;
      "kwinrc"."org.kde.kdecoration2"."theme" = "Breeze";
      "plasma-localerc"."Formats"."LANG" = "en_CA.UTF-8";
      "plasmanotifyrc"."Applications/com.dec05eba.gpu_screen_recorder"."Seen" = true;
      "plasmanotifyrc"."Applications/discord"."Seen" = true;
      "plasmanotifyrc"."Applications/vesktop"."Seen" = true;
      "plasmarc"."Theme"."name" = "default";
      "plasmarc"."Wallpapers"."usersWallpapers" = "/home/jack/Pictures/wallpaper.png";
      "spectaclerc"."General"."autoSaveImage" = true;
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
      "spectaclerc"."General"."launchAction" = "UseLastUsedCapturemode";
      "spectaclerc"."General"."rememberSelectionRect" = "Never";
      "spectaclerc"."General"."showMagnifier" = "ShowMagnifierAlways";
      "spectaclerc"."General"."useReleaseToCapture" = true;
      "spectaclerc"."GuiConfig"."captureDelay" = 1;
      "spectaclerc"."GuiConfig"."captureMode" = 0;
      "spectaclerc"."ImageSave"."imageFilenameTemplate" = "<title>_<yyyy><MM><dd>_<HH><mm><ss>";
      "spectaclerc"."ImageSave"."lastImageSaveLocation" = "file:///home/jack/Pictures/Screenshots/20250613_235706.png";
      "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
      "spectaclerc"."VideoSave"."preferredVideoFormat" = 0;
      "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
