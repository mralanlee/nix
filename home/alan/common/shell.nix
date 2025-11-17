{pkgs, config, ...}: {
  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "docker"
          "docker-compose"
          "git"
        ] ++ (if config.myConfig.tmux.enable then ["tmux"] else []) ++ [
          "terraform"
          "deno"
          "fzf"
        ];
      };

      initContent = ''
        ${if config.myConfig.tmux.enable then ''
        # tmux autostart
        export ZSH_TMUX_AUTOSTART=true
        if [ "$TMUX" = "" ]; then tmux; fi
        '' else ""}

        # fzf
        export FZF_DEFAULT_OPTS='-x --height 40% --layout=reverse --border'
        export FZF_CTRL_T_OPTS='--select-1 --exit-0'
        export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
        export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'tree -C {} | head -200'"
        ${if config.myConfig.tmux.enable then ''
        export FZF_TMUX=1
        export FZF_TMUX_OPTS='-d 40%'
        '' else ""}


        if [ $commands[kubectl] ]; then
          source <(kubectl completion zsh)
          # complete -F __start_kubectl k
        fi

        export PATH=$PATH:/Users/alan/.spicetify
        eval "$(/Users/alan/.local/bin/mise activate zsh)"
        eval "$(~/.local/bin/mise activate zsh)"
        export PATH="$HOME/.krew/bin:$PATH"

        export ZSH_CUSTOM=$HOME/.config/zsh
        export ZSHFUNCTIONS=$HOME/.config/zsh/functions.zsh
        export ZSHPATH=$HOME/.config/zsh/path.zsh
        export ZSHENV=$ZSH_CUSTOM/.zshenv

        # source $ZSH_CUSTOM/.zshenv
        source $ZSHPATH
        source $ZSHFUNCTIONS
        source $ZSHENV
        export PATH=$PATH:/opt/homebrew/bin
      '';

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        "fixgit" = "ssh-add --apple-use-keychain ~/.ssh/id_ed25519";
        "gco" = "git checkout";
        "vimc" = "nvim ~/.config/nvim";
        "cat" = "bat";
        "ll" = "eza --icons -l -g";
        "kns" = "kubens";
        "kx" = "kubectx";
        "qf" = "find. -type f | fzf";
        "docker" = "podman";
        "k" = "kubectl";
        "kcm" = "kubectl kc";
        "l" = "eza";
        "la" = "eza -a";
        "ls" = "eza --icons --color=auto";
        "rebuild" = "darwin-rebuild switch --flake ~/projects/nix";
      };
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        gcloud = {
          format = "'on [$symbol$account(\($region\))]($style) '";
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = config.myConfig.tmux.enable;
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
