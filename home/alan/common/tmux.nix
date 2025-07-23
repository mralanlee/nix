{pkgs, config, ...}: {
  programs.tmux = {
    enable = config.myConfig.tmux.enable;
    # config in dotfiles
  };
}
