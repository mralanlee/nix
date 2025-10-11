{pkgs, ...}: {
  home.packages = with pkgs; [
    # fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    awscli2
    fd
    htop
    tree
    jq

    # chat
    telegram-desktop
    slack
    signal-desktop-bin
    discord

    # media
    # spotify  # temporarily disabled due to download issues

    # developer tools
    mise
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
    zed-editor
    uv
    jdk24

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
  ];
}
