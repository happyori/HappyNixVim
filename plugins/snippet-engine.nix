{
  plugins.luasnip.enable = true;
  plugins.cmp.settings.sources = [{ name = "luasnip"; }];
  plugins.friendly-snippets.enable = true;
  keymaps = [
    {
      mode = "i";
      key = "<tab>";
      action = /* lua */ ''
        function()
          return require("luasnip").locally_jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end
      '';
      options = { expr = true; silent = true; };
      lua = true;
    }
    {
      mode = "s";
      key = "<tab>";
      action = /* lua */ ''
        function()
          local snip = require("luasnip")
          if snip.locally_jumpable(1) then
            snip.jump(1)
          end
        end
      '';
      lua = true;
    }
    {
      mode = [ "s" "i" ];
      key = "<S-tab>";
      action = /* lua */ ''
        function()
          local snip = require("luasnip")
          if snip.locally_jumpable(-1) then
            snip.jump(-1)
          end
        end
      '';
      lua = true;
    }
  ];

}
