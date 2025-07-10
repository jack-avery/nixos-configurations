{...}: {
  programs.bash = {
    enable = true;

    # enabling completion causes some weird errors on non-NixOS machines?
    # unknown command 'have'
    # spent about 2 hours debugging, this solved the issue, and completion continues to function
    enableCompletion = false;

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
      neofetch = "fastfetch";
      doas = "sudo";
      ssha = "eval `ssh-agent -s` && ssh-add";
    };
  };
}
