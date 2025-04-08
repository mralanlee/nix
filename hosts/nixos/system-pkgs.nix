{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # for sops to work
    age

    # for the system to work
    git
    libgcc
    gnumake

    dig
    dnsutils
  ];
}
