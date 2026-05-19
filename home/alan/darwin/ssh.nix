{hostname, ...}: {
  programs.ssh = {
    matchBlocks = {
      "10.22.6.*" = {
        user = "alan";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          IdentityAgent = "none";
        };
      };
      "*" = {
        extraOptions =
          if hostname == "yoshi-mac"
          then {
            IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          }
          else {
            AddKeysToAgent = "yes";
            IdentityFile = "~/.ssh/id_ed25519";
            UseKeychain = "yes";
          };
      };
    };
  };
}
