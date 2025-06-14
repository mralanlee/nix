{
  # Enable SSH agent service
  services.ssh-agent.enable = true;
  
  programs.zsh.initExtra = ''
    # SSH agent setup for NixOS
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
  '';
}