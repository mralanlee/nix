{
  programs = {
    direnv.enable = true;
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
