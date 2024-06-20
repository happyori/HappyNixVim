{ ... }:
{
  plugins.telescope = {
    enable = true;
    extensions = {
      ui-select.enable = true;
      fzf-native.enable = true;
    };
    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^output/"
          "^data/"
          "^.root"
        ];
        layout_strategy = "horizontal";
        layout_config = {
          prompt_position = "bottom";
        };
      };
    };
    keymaps = {
      "<leader><space>" = {
        action = "find_files";
        options = {
          desc = "Find files in the root dir";
        };
      };
      "<leader>/" = {
        action = "live_grep";
        options = {
          desc = "Find in files";
        };
      };
    };
  };
}
