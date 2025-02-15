{pkgs, ...} :{
  programs.tmux = {
    enable = true;

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-fzf
      tmuxPlugins.sensible
    ];
    
    prefix = "C-a";

    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = "
      # reload tmmux
      bind-key r source-file ~/.tmux.conf \\; display-message 'Config reloaded'

      # vi mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind -n C-k clear-history
      bind | split-window -h
      bind - split-window -v
      unbind %
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # resize pane
      bind-key Down resize-pane -D 10
      bind-key Up resize-pane -U 10
      bind-key Left resize-pane -L 10
      bind-key Right resize-pane -R 10
      set -g default-terminal 'screen-256color'
      set -g mouse on
      ";
  };
}
