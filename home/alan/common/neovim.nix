{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      cargo
      delve
      docker-compose-language-service
      dockerfile-language-server-nodejs
      gcc
      goimports-reviser
      gopls
      puppet
      deno
      gotools
      hadolint
      lua-language-server
      marksman
      nodePackages.typescript-language-server
      shfmt
      terraform-ls
      yaml-language-server
      yamllint
    ];
  };
}
