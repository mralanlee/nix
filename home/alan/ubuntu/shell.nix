{
  services.ssh-agent.enable = true;

  programs.zsh = {
    initContent = ''
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    '';
  };
}
