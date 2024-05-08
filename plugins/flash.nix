{ config, ... }:
let
  inherit (config.happy) mkKeymap;
  flash_action = name: "function() require('flash').${name}() end";
  mkDesc = desc: { desc = "${toString desc}"; };
in
{
  plugins.flash = {
    enable = true;
  };
  keymaps = [
    (mkKeymap [ [ "n" "x" "o" ] "s" (flash_action "jump") (mkDesc "Flash") true ])
    (mkKeymap [ [ "n" "x" "o" ] "S" (flash_action "treesitter") (mkDesc "Flash on treesitter") true ])
    (mkKeymap [ "o" "r" (flash_action "remote") (mkDesc "Remote Flash") true ])
    (mkKeymap [ [ "o" "x" ] "R" (flash_action "treesitter_search") (mkDesc "Treesitter Search") true ])
    (mkKeymap [ "c" "<C-s>" (flash_action "toggle") (mkDesc "Toggle Flash Search") true ])
  ];
}
