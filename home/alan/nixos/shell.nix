{
  # Enable SSH agent service
  services.ssh-agent.enable = true;

  programs.zsh = {
    initContent = ''
      # SSH agent setup for NixOS
      ssh-add ~/.ssh/id_ed25519 2>/dev/null

      # Hyprland environment setup
      if [ -d "/run/user/$(id -u)/hypr" ]; then
        export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /run/user/$(id -u)/hypr 2>/dev/null | head -n 1)
      fi
    '';
  };
}
