{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    htop
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

    # containerization and related tooling
    podman
    podman-compose
    podman-tui
    kubectl
    k9s
    lens
    stern

    # terraform
    terraform-docs
    terraform
    terraform
    # terraform-ls moved to neovim config
  ];
}
