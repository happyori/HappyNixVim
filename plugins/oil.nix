{ helpers, ... }:
{
  plugins.oil = {
    enable = true;
    settings = {
      keymaps = {
        "<bs>" = "actions.parent";
        "H" = "actions.toggle_hidden";
        "q" = "actions.close";
        "<esc>" = "actions.close";
        "<C-s>" = helpers.mkRaw ''require("oil").save'';
      };
      skip_confirm_for_simple_edits = true;
      win_options = {
        cursorcolumn = false;
        list = false;
        signcolumn = "no";
        wrap = false;
      };
      float.win_options.winblend = 50;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = helpers.mkRaw /* lua */ ''
        function()
          require("oil").toggle_float()
        end
      '';
      options = { desc = "Open explorer"; };
    }
  ];
}
