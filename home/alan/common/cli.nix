{
  programs = {
    # direnv.enable = true;  # Temporarily disabled due to Fish build issue
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
  };
}
