{pkgs, inputs, system, ...}: {
  home.packages = with pkgs; [
    obsidian
    hyprpaper
    rofi
    hyprlock
    inputs.zen-browser.packages."${system}".twilight
    git-credential-manager
  ];
}
