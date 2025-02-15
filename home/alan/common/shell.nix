{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "docker"
          "docker-compose"
          "git"
          "tmux"
          "terraform"
          "deno"
          "fzf"
        ];
      };

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        "gco" = "git checkout";
        "vimc" = "nvim ~/.config/nvim";
        "cat" = "bat";
        "ls" = "eza --icons";
        "ll" = "eza --icons -l -g";
        "k" = "kubectl";
        "kns" = "kubens";
        "kx" = "kubectx";
        "qf" = "find. -type f | fzf";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
