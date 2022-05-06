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
  };

  outputs = { lain, awesome-freedesktop, ... }: {
    setup = { config, pkgs, ... }: {
      xdg.configFile = {
        "awesome/rc.lua".source = ./rc.lua;
        "awesome/lua".source = ./lua;
        "awesome/themes".source = ./themes;
        "awesome/lain".source = lain;
        "awesome/freedesktop".source = awesome-freedesktop;
      };

      xdg.configFile = {
        "awesome/auto_start.lua".text = with pkgs; ''
          return {
            "${flameshot}/bin/flameshot",
            "${picom}/bin/picom -b",
          }
        '';
      };

      services.picom = {
        backend = "glx";
      };
    };
  };
}

