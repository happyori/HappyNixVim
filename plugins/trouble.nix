{ config, lib, ... }:
let
  inherit (config.happy) mkKeymap;
in
{
  plugins.trouble.enable = true;

  plugins.which-key.registrations = {
    "<leader>x" = "Diagnostics";
  };

  keymaps = lib.flatten [
    (mkKeymap [ "n" "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" { desc = "Toggle Diagnostics (Trouble)"; } ])
    (mkKeymap [ "n" "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" { desc = "Toggle Buffer Diagnostics (Trouble)"; } ])
    (mkKeymap [ "n" "<leader>xL" "<cmd>Trouble loclist toggle<cr>" { desc = "Location List (Trouble)"; } ])
    (mkKeymap [ "n" "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" { desc = "Quickfix List (Trouble)"; } ])
    (mkKeymap [ "n" "<leader>cl" "<cmd>Trouble lsp toggle focus=false win.position=right<cr>" { desc = "LSP definitions / references / ... (Trouble)"; } ])
    (mkKeymap [ "n" "<leader>cs" "<cmd>Trouble symbols toggle focus=false<cr>" { desc = "Symbols (Trouble)"; } ])
  ];
}
