let
  more =
    { pkgs, ... }:
    {
      programs = {
        bat.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        fzf = {
          enable = true;
          enableFishIntegration = false; # broken
          defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
          defaultOptions = [ "--height 20%" ]; # FZF_DEFAULT_OPTS
          fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
        };

        gpg.enable = true;

        htop = {
          enable = true;
          settings = {
            sort_direction = true;
            sort_key = "PERCENT_CPU";
          };
        };

        jq.enable = true;

        # generate index with: nix-index --filter-prefix '/bin/'
        nix-index = {
          enable = true;
          enableFishIntegration = true;
        };
        # command-not-found only works with channels
        command-not-found.enable = false;

        obs-studio = {
          enable = false;
          plugins = [ ];
        };

        ssh.enable = true;

        zoxide = {
          enable = true;
          enableFishIntegration = true;
          options = [ ];
        };
      };
    };
in
[
  ../programs/git
  ../programs/firefox
  ../programs/fish
  ../programs/neofetch
  ../programs/neovim-ide
  more
]
