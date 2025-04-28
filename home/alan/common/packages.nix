{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    fd
    htop
    tree
    jq

    # chat
    telegram-desktop
    slack
    signal-desktop
    discord

    # developer tools
    mise
    devbox
    alejandra
    hub
    kind
    lua
    zed-editor

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
