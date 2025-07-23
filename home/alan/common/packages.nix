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
    spotify

    # developer tools
    mise
    devbox
    opencode
    vscode
    claude-code
    alejandra
    hub
    kind
    lua
    zed-editor
    uv

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
    terraform-docs
    terraform
    tgswitch
    hclfmt
    # terraform-ls moved to neovim config
  ];
}
