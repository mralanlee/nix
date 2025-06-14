{
  programs.zsh.initContent = ''
    export PATH="/run/current-system/sw/bin:$PATH"
    
    # SSH agent setup for macOS
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
  '';
}