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
        "awesome/auto_start.lua".text = with pkgs; ''
          return {
            "${flameshot}/bin/flameshot",
            "${picom}/bin/picom -b",
          }
        '';
        "awesome/sys_apps.lua".text = with pkgs; ''
          return {
            screenshot = "${flameshot}/bin/flameshot gui",
            lockscreen = "${xlockmore}/bin/xlock -mode blank",
            bright = {
              inc = "${brightnessctl}/bin/brightnessctl set 10%+",
              dec = "${brightnessctl}/bin/brightnessctl set 10%-",
            },
            volume = {
              inc = "${pamixer}/bin/pamixer -i 10",
              dec = "${pamixer}/bin/pamixer -d 10",
              mute = "${pamixer}/bin/pamixer -t",
            },
          }
        '';
      };
    };
  };
}

