{
  home = {
    username = "alan";
    file = {
      ".tmux.conf" = {
        source = ../dotfiles/tmux/.tmux.conf;
      };
      ".config/ghostty" = {
        source = ../dotfiles/ghostty;
        recursive = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  xdg.enable = true;
  fonts.fontconfig.enable = true;
}
