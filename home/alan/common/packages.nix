{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      awscli2
      fd
      htop
      tree
      jq

      nodejs_24
      # chat
      telegram-desktop
      slack
      signal-desktop-bin
      discord

      # media
      # spotify  # temporarily disabled due to download issues

      # developer tools
      # mise  # Temporarily disabled due to Fish build issue
      devbox
      opencode
      vscode
      code-cursor
      claude-code
      google-cloud-sdk
      alejandra
      hub
      kind
      lua
      uv
      jdk21

      zoom-us
      railway
      redisinsight
      obsidian
      # containerization and related tooling
      podman
      podman-compose
      podman-tui
      kubeconform
      kubectl
      k9s
      lens
      stern

      # terraform
      terraform
      tgswitch
      hclfmt
      # terraform-ls moved to neovim config
    ])
    ++ (pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [pkgs.ghostty]);
}
