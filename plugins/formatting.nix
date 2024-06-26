{ helpers, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    extraOptions = {
      format = {
        timeout_ms = 3000;
        async = false;
        quiet = false;
        lsp_fallback = true;
      };
      formatters_by_ft = {
        lua = [ "stylua" ];
        fish = [ "fish_indent" ];
        sh = [ "shfmt" ];
        javascript = [ [ "prettierd" "prettier" ] ];
      };
      formatters = {
        injected = { options = { ignore_errors = true; }; };
      };
    };
    formatOnSave = {
      timeoutMs = 500;
      lspFallback = true;
    };
  };

  keymaps = [
    {
      mode = [ "n" "v" ];
      key = "<leader>cF";
      action = helpers.mkRaw "function() require('conform').format({ fromatters = { 'injected' }, timeout_ms = 3000 }) end";
      options = { desc = "Format injected langs"; };
    }
  ];

  opts = {
    formatexpr = "v:lua.require'conform'.formatexpr()";
  };
}
