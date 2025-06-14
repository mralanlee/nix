{
  programs.ssh = {
    extraConfig = ''
      Host *
        UseKeychain yes
    '';
  };
}
