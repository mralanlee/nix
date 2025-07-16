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

    # for anyone reading this, I haven't gone soft.
    # I'm using this to get a github token because Travis told me to
    jetbrains.idea-community-bin

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
