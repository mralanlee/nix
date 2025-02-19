{ config, pkgs, ... }: {
  home.file = {
    ".config/nvim" = {
        source =  ../dotfiles/nvim;
        recursive = true;
    };
    
    ".config/hypr" = {
        source =  ../dotfiles/hypr;
        recursive = true;
    };
  };
}
