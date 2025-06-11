{pkgs, ...}: {
  # Alacritty terminal configuration
  home.file.".config/alacritty/alacritty.toml" = {
    source = ../dotfiles/alacritty/alacritty.toml;
  };

  home.file.".config/alacritty/catppuccin-macchiato.toml" = {
    source = ../dotfiles/alacritty/catppuccin-macchiato.toml;
  };
}
