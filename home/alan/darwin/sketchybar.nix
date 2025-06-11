{pkgs, ...}: {
  home.file.".config/sketchybar/sketchybarrc" = {
    source = ../dotfiles/sketchybar/sketchybarrc;
    executable = true;
  };

  home.file.".config/sketchybar/globalstyles.sh" = {
    source = ../dotfiles/sketchybar/globalstyles.sh;
    executable = true;
  };

  home.file.".config/sketchybar/items" = {
    source = ../dotfiles/sketchybar/items;
    recursive = true;
  };

  home.file.".config/sketchybar/plugins" = {
    source = ../dotfiles/sketchybar/plugins;
    recursive = true;
  };

  home.file.".config/sketchybar/start_sketchybar.sh" = {
    source = ../dotfiles/sketchybar/start_sketchybar.sh;
    executable = true;
  };

  # Environment variables for SketchyBar
  home.sessionVariables = {
    CONFIG_DIR = "$HOME/.config/sketchybar";
    PLUGIN_DIR = "$HOME/.config/sketchybar/plugins";
  };

  # LaunchAgent for auto-starting SketchyBar
  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = ["/bin/bash" "/Users/alan/.config/sketchybar/start_sketchybar.sh"];
      Label = "com.user.sketchybar";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/sketchybar.log";
      StandardErrorPath = "/tmp/sketchybar.error.log";
      EnvironmentVariables = {
        PATH = "/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin";
      };
    };
  };
}
