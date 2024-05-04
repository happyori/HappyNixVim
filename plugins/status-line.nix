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
        "filetype"
        "progress"
      ];
      lualine_z = [
        { name = "location"; separator.right = ""; padding.left = 2; padding.right = 1; }
      ];
    };
    inactiveSections = {
      lualine_a = [ "filename" ];
      lualine_z = [ "location" ];
    };
  };
}
