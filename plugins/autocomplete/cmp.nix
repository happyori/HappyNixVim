{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.custom.autocomplete;
in
{
  config = mkIf cfg.cmp {
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        preselect = "cmp.PreselectMode.Item";
        sources = [
          { name = "otter"; priority = 1001; }
          { name = "nvim_lsp"; priority = 1000; }
          { name = "fish"; }
          { name = "path"; }
          { name = "buffer"; group_index = 2; }
        ];
        view = {
          entries = {
            follow_cursor = true;
          };
        };
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.SelectBehavior.Replace, select = true })";
          "<C-CR>" = ''
            function(fallback)
              cmp.abort()
              fallback()
            end
          '';
          "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
        };
        window.completion.border = "rounded";
      };
    };
  };
}
