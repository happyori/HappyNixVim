{ helpers, ... }:
{
  plugins = {
    luasnip.enable = true;
    cmp.settings.sources = [{ name = "luasnip"; }];
    friendly-snippets.enable = true;
  };

  keymaps = [
    {
      mode = "i";
      key = "<tab>";
      action = helpers.mkRaw /* lua */ ''
        function()
          return require("luasnip").locally_jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end
      '';
      options = { expr = true; silent = true; };
    }
    {
      mode = "s";
      key = "<tab>";
      action = helpers.mkRaw /* lua */ ''
        function()
          local snip = require("luasnip")
          if snip.locally_jumpable(1) then
            snip.jump(1)
          end
        end
      '';
    }
    {
      mode = [ "s" "i" ];
      key = "<S-tab>";
      action = helpers.mkRaw /* lua */ ''
        function()
          local snip = require("luasnip")
          if snip.locally_jumpable(-1) then
            snip.jump(-1)
          end
        end
      '';
    }
  ];

}
