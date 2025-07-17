{ lib, myConfig ? {}, ... }:

{
  options = {
    myConfig = {
      tmux.enable = lib.mkOption {
        type = lib.types.bool;
        default = myConfig.tmux.enable or true;
        description = "Whether to enable tmux";
      };
    };
  };
}