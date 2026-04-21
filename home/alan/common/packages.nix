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
      signal-desktop
      discord

      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      # media
      spotify

      # developer tools
      # mise  # Temporarily disabled due to Fish build issue
      antigravity
      codex
      gemini-cli
      devbox
      opencode
      vscode
      code-cursor
      claude-code
      google-cloud-sdk
      alejandra
      hub
      direnv
      kind
      lua
      uv
      jdk21
      teleport

      zoom-us
      railway
      obsidian
      # containerization and related tooling
      colima
      docker-compose

      kubeconform
      kubectl
      k9s
      lens
      stern
      railway

      # terraform
      terraform
      terragrunt
      opentofu
      tgswitch
      hclfmt
      # terraform-ls moved to neovim config
    ])
    ++ (pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [pkgs.ghostty]);
}
