{pkgs, ...}: {
  home.packages = [pkgs.kitty];

  home.file.".config/kitty/kitty.conf" = {
    source = ../dotfiles/kitty/kitty.conf;
  };

  home.file.".config/kitty/catppuccin-macchiato.conf" = {
    source = ../dotfiles/kitty/catppuccin-macchiato.conf;
  };
}
