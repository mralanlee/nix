{hostname, ...}: {
  programs.zsh.initContent =
    ''
      export PATH="/run/current-system/sw/bin:$PATH"
    ''
    + (
      if hostname == "yoshi-mac"
      then ''

        # 1Password SSH agent
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
      ''
      else ''

        # SSH agent setup for macOS
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
      ''
    );
}
