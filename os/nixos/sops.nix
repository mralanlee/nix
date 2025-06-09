{
  sops.age.keyFile = "/home/alan/.config/sops/age/keys.txt";

  # Sops configuration

  sops.defaultSopsFile = ../common/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.secrets.github_token = {
    owner = "alan";
    group = "users";
    mode = "0400";
  };
}
