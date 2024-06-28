{ lib, config, ... }:
{
  plugins = {
    comment.enable = true;
    vim-css-color.enable = true;
    noice = {
      enable = true;
      cmdline = {
        enabled = true;
        format = {
          lua_inspect = {
            lang = "lua";
            pattern = "^:=";
          };
        };
      };
    };
    nvim-ufo = {
      enable = true;

    };
  };

  keymaps =
    let
      keymap' = config.happy.mkKeymap;
    in
    lib.flatten [
      (keymap' [ "n" "zR" "require('ufo').openAllFolds" { desc = "UFO: Open All Folds"; remap = true; } true ])
      (keymap' [ "n" "zM" "require('ufo').closeAllFolds" { desc = "UFO: Close All Folds"; remap = true; } true ])
    ];
}
