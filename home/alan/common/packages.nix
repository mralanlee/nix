{
  pkgs,
  inputs,
  ...
}: {
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

      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      # media
      spotify

      # developer tools
      go
      # mise  # Temporarily disabled due to Fish build issue
      ngrok
      cloudflared
      codex
      pi-coding-agent
      devbox
      opencode
      vscode
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

      # terraform removed: it builds from source and its Go link phase
      # exhausts the system-wide open-file table on macOS. opentofu (below) is
      # a drop-in replacement.
      terragrunt
      opentofu
      tgswitch
      hclfmt
      # terraform-ls moved to neovim config
    ])
    ++ [
      # markdown review tool; not in nixpkgs, comes from its own flake
      inputs.crit.packages.${pkgs.stdenv.hostPlatform.system}.crit
    ]
    ++ (pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [pkgs.ghostty]);
}
