{...}: {
  programs.bash = {
    enable = true;

    # enabling completion causes some weird errors on non-NixOS machines?
    # unknown command 'have'
    # spent about 2 hours debugging, this solved the issue, and completion continues to function
    enableCompletion = false;

    bashrcExtra = ''
      C_BLACK='\033[0;30m'
      C_RED='\033[0;31m'
      C_GREEN='\033[0;32m'
      C_GREENB='\033[1;32m'
      C_YELLOW='\033[0;33m'
      C_BLUE='\033[0;34m'
      C_BLUEB='\033[1;34m'
      C_MAGENTA='\033[0;35m'
      C_MAGENTAB='\033[1;35m'
      C_CYAN='\033[0;36m'
      C_GRAY='\033[0;90m'
      C_WHITE='\033[0;97m'
      C_LBLUE='\033[0;94m'
      C_LCYAN='\033[0;96m'
      CB_BLUE='\033[44m'
      CB_CYAN='\033[46m'
      CB_LBLUE='\033[104m'
      CB_LCYAN='\033[106m'
      CB_WHITE='\033[107m'
      C_END='\033[0m'

      if [ -f '~/git/google-cloud-sdk/path.bash.inc' ]; then . '~/git/google-cloud-sdk/path.bash.inc'; fi
      if [ -f '~/git/google-cloud-sdk/completion.bash.inc' ]; then . '~/git/google-cloud-sdk/completion.bash.inc'; fi
      eval "$(~/.rbenv/bin/rbenv init - bash 2> /dev/null)"

      rc_color() {
          if [[ ! $? == 0 ]] then
              echo -e "''${C_RED}"
          else
              echo -e "''${C_BLUEB}"
          fi
      }

      # git_ps1() {
      #     local git_status="$(git status 2> /dev/null)"
      #     local on_branch="On branch ([^$IFS]*)"
      #     local on_commit="HEAD detached at ([^$IFS]*)"

      #     if [[ $git_status =~ $on_branch ]]; then
      #         local branch=''${BASH_REMATCH[1]}
      #         echo -e " ($branch)"
      #     elif [[ $git_status =~ $on_commit ]]; then
      #         local commit=''${BASH_REMATCH[1]}
      #         echo -e " ($commit)"
      #     fi
      # }

      PROMPT_COMMAND='RC_COLOR=$(rc_color)'
      PS1='\n \001\033[0;90m\002\W \001''${RC_COLOR}\002λ \001\033[0m\002'
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
