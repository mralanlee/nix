{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
