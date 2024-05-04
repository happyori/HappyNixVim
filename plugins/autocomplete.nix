{ config, lib, ... }:
let
  cfg = config.custom.autocomplete;
  inherit (lib) mkEnableOption;
  boolAsString = bool: if bool then "true" else "false";
in
{
  options.custom.autocomplete = {
    coq = mkEnableOption "Enable CoQ" // { default = true; };
    cmp = mkEnableOption "Enable Nvim CMP";
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.coq && cfg.cmp);
        message = "CoQ and CMP are in conflict: CoQ -> ${boolAsString cfg.coq} | CMP -> ${boolAsString cfg.cmp}";
      }
    ];
  };

  imports = [
    ./autocomplete/cmp.nix
    ./autocomplete/coq.nix
  ];
}
