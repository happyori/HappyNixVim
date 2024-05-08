{ lib, ... }:
let
  betterUpDown = { key, dir ? key }:
    let
      mode = [ "n" "x" ];
      action = "v:count == 0 ? 'g${dir}' : '${dir}'";
      options = { expr = true; silent = true; };
    in
    { inherit mode key action options; };
  keymap' = mapList:
    let
      inherit (lib) elemAt optionalAttrs length;
      mode = elemAt mapList 0;
      key = elemAt mapList 1;
      action = elemAt mapList 2;
      options = optionalAttrs (length mapList > 3) (elemAt mapList 3);
      lua = if length mapList > 4 then elemAt mapList 4 else false;
    in
    { inherit mode key action options lua; };
  windowMovement =
    let
      keys = [ "h" "j" "k" "l" ];
      dir = [ "Left" "Lower" "Upper" "Right" ];
      zipped = lib.zipLists keys dir;
      mapper = zip: keymap' [ "n" "<C-${zip.fst}>" "<C-w>${zip.fst}" { desc = "Go to ${zip.snd} Window"; remap = true; } ];
    in
    map mapper zipped;
  windowResize =
    let
      keys = [ "Up" "Down" "Left" "Right" ];
      values = [ "resize +2" "resize -2" "vertical resize -2" "vertical resize +2" ];
      zipped = lib.zipLists keys values;
      mapper = zip: keymap' [ "n" "<C-${zip.fst}>" "<cmd>${zip.snd}<cr>" ];
    in
    map mapper zipped;
  lineSwapping =
    let
      actions = [
        [ "n" "<D-j>" "<cmd>m .+1<cr>==" { desc = "Move line down"; } ]
        [ "n" "<D-k>" "<cmd>m .-2<cr>==" { desc = "Move line up"; } ]
        [ "i" "<D-j>" "<esc><cmd>m .+1<cr>==gi" { desc = "Move line down"; } ]
        [ "i" "<D-k>" "<esc><cmd>m .-2<cr>==gi" { desc = "Move line up"; } ]
        [ "v" "<D-j>" ":m '>+1<cr>gv=gv" { desc = "Move lines down"; } ]
        [ "v" "<D-k>" ":m '<-2<cr>gv=gv" { desc = "Move lines up"; } ]
      ];
    in
    map keymap' actions;
in
{
  options.happy.mkKeymap = lib.mkOption {
    type = lib.types.anything;
  };

  config = {
    happy.mkKeymap = keymap';
    keymaps = lib.flatten [
      (betterUpDown { key = "j"; })
      (betterUpDown { key = "k"; })
      (betterUpDown { key = "<Down>"; dir = "j"; })
      (betterUpDown { key = "<Up>"; dir = "k"; })

      windowMovement
      windowResize
      lineSwapping

      (keymap' [ "n" "<S-h>" "<cmd>bprevious<cr>" { desc = "Move to previous buffer"; } ])
      (keymap' [ "n" "<S-l>" "<cmd>bnext<cr>" { desc = "Move to next buffer"; } ])
      (keymap' [ [ "n" "i" ] "<esc>" "<cmd>noh<cr><esc>" { desc = "Escape and clear hlsearch"; } ])
      (keymap' [ [ "i" "n" "x" "s" ] "<C-s>" "<cmd>w<cr><esc>" { desc = "Save file and escape"; } ])

      # Better indenting in visual
      (keymap' [ "v" "<" "<gv" ])
      (keymap' [ "v" ">" ">gv" ])

      (keymap' [ "n" "<leader>xl" "<cmd>lopen<cr>" { desc = "Location list"; } ])
      (keymap' [ "n" "<leader>xq" "<cmd>copen<cr>" { desc = "Quickfix list"; } ])
      (keymap' [ "n" "[q" "vim.cmd.cprev" { desc = "Previous Quickfix Entry"; } true ])
      (keymap' [ "n" "]q" "vim.cmd.cnext" { desc = "Next Quickfix Entry"; } true ])

      (keymap' [ "n" "<leader>qq" "<cmd>qa<cr>" { desc = "Quit it all"; } ])
      (keymap' [ "n" "<leader>ui" "vim.show_pos" { desc = "Inspect position"; } true ])

      (keymap' [ "n" "<leader>|" "<C-W>v" { desc = "Split window right"; remap = true; } ])
      (keymap' [ "n" "<leader>-" "<C-W>s" { desc = "Split window below"; remap = true; } ])
      (keymap' [ [ "n" "i" "x" ] "<C-q>" "<cmd>q!<cr>" { desc = "Force quit window"; } ])
      (keymap' [ "n" "<leader>W" "HappyUtils.close_buffer" { desc = "Close the active buffer"; } true ])

      (keymap' [ "n" "<home>" "HappyUtils.move_to_start" { desc = "Improved home"; } true ])
      (keymap' [ "n" "<end>" "HappyUtils.move_to_end" { desc = "Improved end"; } true ])
      (keymap' [ [ "n" "i" ] "<C-,>" "HappyUtils.move_to_start" { desc = "Improved home"; } true ])
      (keymap' [ [ "n" "i" ] "<C-.>" "HappyUtils.move_to_end" { desc = "Improved end"; } true ])
    ];
  };
}
