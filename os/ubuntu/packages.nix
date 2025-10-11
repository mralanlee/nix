{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    age
    git
    libgcc
    gnumake
    dig
    dnsutils
  ];
}
