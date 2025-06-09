{pkgs, ...}: {
  # Sops configuration

  sops.defaultSopsFile = ../common/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/alan/.config/sops/age/keys.txt";
  
  sops.secrets.github_token = {
    owner = "alan";
    group = "users";
    mode = "0400";
  };
}
