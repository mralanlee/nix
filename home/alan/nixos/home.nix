{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };

    ".config/hypr" = {
      source = ../dotfiles/hypr;
      recursive = true;
    };

    ".config/gdm" = {
      source = ../dotfiles/gdm;
      recursive = true;
    };

    # Additional monitor config for lid-closed scenarios
    ".config/gdm/monitors-lid-closed.xml" = {
      source = ../dotfiles/gdm/monitors-lid-closed.xml;
    };

    ".config/rofi/material-theme.rasi" = {
      source = ../dotfiles/rofi/material-theme.rasi;
    };
  };
}
