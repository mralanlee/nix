{ config, pkgs, ... }:
let
 aws_sso_auth = pkgs.writeShellScriptBin "aws_sso_auth" (builtins.readFile ../assets/scripts/aws_sso_auth);
 aider_copilot = pkgs.writeShellScriptBin "aider_copilot" (builtins.readFile ../assets/scripts/aider_copilot);
in
{
  home.packages = [
    aws_sso_auth
    aider_copilot
  ];
}
