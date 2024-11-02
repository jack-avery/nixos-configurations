# What?

[NixOS](https://nixos.org) is a Linux distribution managed using a fully declarative package manager. I do a lot of [remote stuff](https://github.com/jack-avery/ansible-tf2network), so having ways to manage an entire environment declaratively sounds like a wonderful idea to me.

I also have had a wonderful experience using NixOS so far aside, from some video games that block Linux altogether.

# How?

I use a flake-based system configuration. Regardless of whether you're using NixOS or just have Nix installed, you need to enable the `nix-command` and `flakes` experimental features.

Once that is done, if you're using NixOS, you can match my system using `sudo nixos-rebuild switch --flake .`. Note that this assumes you have my hardware configuration as well.

If you're not on NixOS, you'll have to install [home-manager](https://nix-community.github.io/home-manager/). I use the Standalone installation. Once you have it set up, run `home-manager switch --flake .`, and resource your shell.

# Where?

Sources for my NixOS and home-manager configurations are listed under `systems` and `homes`. You can see the ones for my current computer here: [NixOS](https://github.com/jack-avery/nixos-configurations/blob/main/systems/nixdesk/configuration.nix) [home-manager](https://github.com/jack-avery/nixos-configurations/blob/main/homes/jack/home.nix)
