{ helpers, lib, ... }:
let
  betterUpDown = { key, dir ? key }:
    let
      mode = [ "n" "x" ];
      action = "v:count == 0 ? 'g${dir}' : '${dir}'";
      options = { expr = true; silent = true; };
    in
    { inherit mode key action options; };
  windowMovement =
    let
      keys = [ "h" "j" "k" "l" ];
      dir = [ "Left" "Lower" "Upper" "Right" ];
      zipped = lib.zipLists keys dir;
      mapper = zip: {
        key = "<C-${zip.fst}>";
        mode = "n";
        action = "<C-w>${zip.fst}";
        options = { desc = "Go to ${zip.snd} Window"; remap = true; };
      };
    in
    map mapper zipped;
in
{
  keymaps = lib.flatten [
    (betterUpDown { key = "j"; })
    (betterUpDown { key = "k"; })
    (betterUpDown { key = "<Down>"; dir = "j"; })
    (betterUpDown { key = "<Up>"; dir = "k"; })
    windowMovement
  ];
}
