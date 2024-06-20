{ helpers, ... }:
{
  plugins.oil = {
    enable = true;
    settings = {
      keymaps = {
        "<bs>" = "actions.parent";
        "H" = "actions.toggle_hidden";
        "q" = "actions.close";
        "<C-s>" = (helpers.listToUnkeyedAttrs [ "actions.save" ]) // { desc = "Save changes"; };
      };
      skip_confirm_for_simple_edits = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>o";
      action = helpers.mkRaw /* lua */ ''
        function()
          require("oil").toggle_float()
        end
      '';
      options = { desc = "Open oil float"; };
    }
  ];
}
