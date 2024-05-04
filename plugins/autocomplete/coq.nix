{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.custom.autocomplete;
in
{
  config = mkIf cfg.coq {
    plugins.coq-nvim = {
      enable = true;
      installArtifacts = true;
    };
    plugins.coq-thirdparty.enable = true;
  };
}
