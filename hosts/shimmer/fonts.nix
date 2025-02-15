{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrains Mono"];
    };
  };
}
