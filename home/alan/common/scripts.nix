{
  config,
  pkgs,
  ...
}: let
  aws_sso_auth = pkgs.writeShellScriptBin "aws_sso_auth" (builtins.readFile ../assets/scripts/aws_sso_auth);
  aider_copilot = pkgs.writeShellScriptBin "aider_copilot" (builtins.readFile ../assets/scripts/aider_copilot);
  audio-toggle = pkgs.writeShellScriptBin "audio-toggle" (builtins.readFile ../assets/scripts/audio-toggle);
  audio-menu-dropdown = pkgs.writeShellScriptBin "audio-menu-dropdown" (builtins.readFile ../assets/scripts/audio-menu-dropdown);
  mic-menu-dropdown = pkgs.writeShellScriptBin "mic-menu-dropdown" (builtins.readFile ../assets/scripts/mic-menu-dropdown);
in {
  home.packages = [
    aws_sso_auth
    aider_copilot
    audio-toggle
    audio-menu-dropdown
    mic-menu-dropdown
  ];
}
