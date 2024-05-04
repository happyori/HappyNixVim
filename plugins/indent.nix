{ lib, ... }:
let
  scopes = [
    "RainbowDelimiterRed"
    "RainbowDelimiterYellow"
    "RainbowDelimiterBlue"
    "RainbowDelimiterOrange"
    "RainbowDelimiterGreen"
    "RainbowDelimiterViolet"
    "RainbowDelimiterCyan"
  ];
in
{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      exclude = {
        buftypes = [
          "terminal"
          "quickfix"
          "help"
          "neo-tree"
          "Trouble"
          "trouble"
          "notify"
          "lazyterm"
        ];
      };
      scope = {
        enabled = true;
        show_start = true;
        show_end = false;
        char = "▕";
        highlight = scopes;
      };
      indent = {
        char = "┇";
      };
    };
  };
  plugins.rainbow-delimiters.highlight = lib.mkForce scopes;
  plugins.mini.modules = {
    indentscope = {
      symbol = "▕";
      options = { try_as_border = true; };
    };
  };
  plugins.illuminate = {
    enable = true;
    delay = 200;
    largeFileCutoff = 2000;
    largeFileOverrides = {
      providers = [ "lsp" ];
    };
  };
  colorschemes.rose-pine.settings.highlight_groups = {
    MiniIndentscopeSymbol = { fg = "pine"; };
  };
  extraConfigLua = /* lua */ ''
    local hooks = require "ibl.hooks"
    hooks.register(
      hooks.type.SCOPE_HIGHLIGHT,
      hooks.builtin.scope_highlight_from_extmark
    )
  '';
}
