{
  home.homeDirectory = "/home/alan";
  home.file = {
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/alan/projects/nix/dotfiles/hypr";
      enable = true; 
    };
  };
}
