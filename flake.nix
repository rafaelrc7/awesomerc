{
  description = "My awesomewm config flake";

  inputs = {
    lain = {
      flake = false;
      url = "github:lcpz/lain";
    };

    awesome-freedesktop = {
      flake = false;
      url = "github:lcpz/awesome-freedesktop";
    };

    awesome-git = {
      flake = false;
      url = "github:awesomewm/awesome";
    };
  };

  outputs = { lain, awesome-freedesktop, awesome-git, ... }: {
    # TODO: Set xsession awesomewm

    dotfiles = { config, ... }: {
      xdg.configFile = {
        "awesome/rc.lua".source = ./rc.lua;
        "awesome/lua".source = ./lua;
        "awesome/themes".source = ./themes;
        "awesome/lain".source = lain;
        "awesome/freedesktop".source = awesome-freedesktop;
      };
    };

    autorun = { pkgs, config, ... }: {
      home.packages = with pkgs; [
        flameshot
      ];

      xsession = {
        enable = true;
        windowManager.awesome = {
          enable = true;
          package = pkgs.awesome.overrideAttrs (old: {
            version = "git";
            src = awesome-git;
          });
        };
      };

      services.picom = {
        enable = true;
        backend = "glx";
      };

      xdg.configFile = {
        "awesome/auto_start.lua".text = with pkgs; ''
          return {
            flameshot,
          }
        '';
      };
    };

  };
}

