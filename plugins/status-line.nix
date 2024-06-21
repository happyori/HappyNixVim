{ pkgs, ... }:
{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    iconsEnabled = true;
    sectionSeparators = {
      left = "";
      right = "";
    };
    componentSeparators = {
      left = "";
      right = "";
    };
    sections = {
      lualine_a = [
        { name = "mode"; separator.left = ""; padding.right = 2; padding.left = 1; }
      ];
      lualine_b = [
        "filename"
        "branch"
      ];
      lualine_c = [
        "%="
      ];
      lualine_y = [
        "require('lsp-status').status()"
        "progress"
      ];
      lualine_z = [
        { name = "location"; separator.right = ""; padding.left = 2; padding.right = 1; }
      ];
    };
    winbar = {
      lualine_a = [{
        name = "buffers";
        extraConfig = {
          show_filename_only = true;
          use_mode_colors = true;
          symbols = {
            alternate_file = "";
          };
        };
      }];
      lualine_z = [ ];
    };
    inactiveSections = {
      lualine_a = [ "filename" ];
      lualine_z = [ "location" ];
    };
    extensions = [
      "oil"
    ];
  };

  extraPlugins = [ pkgs.vimPlugins.lsp-status-nvim ];
}
