{
  pkgs,
  ...
}: {
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.earlyVconsoleSetup = true;
  console = {
    font = "ter-132b";  # Replace with your chosen font
    packages = with pkgs; [ terminus_font ]; # Ensure the font package is included
  };

  boot.loader.systemd-boot.consoleMode = "2";
}
