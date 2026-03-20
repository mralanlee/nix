{
  programs.ssh = {
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
