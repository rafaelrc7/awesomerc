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
  };
}

