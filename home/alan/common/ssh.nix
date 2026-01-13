{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
