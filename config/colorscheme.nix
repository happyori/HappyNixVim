{ ... }:
{
  colorschemes.rose-pine = {
    enable = true;
    settings = {
      variant = "moon";
      dark_variant = "moon";
      extend_background_behind_borders = false;
      enable = {
        terminal = true;
        migrations = true;
      };
      styles = {
        transparency = true;
        bold = true;
      };
      highlight_groups = {
        RainbowDelimiterRed = { fg = "love"; };
        RainbowDelimiterYellow = { fg = "gold"; };
        RainbowDelimiterBlue = { fg = "pine"; };
        RainbowDelimiterOrange = { fg = "rose"; };
        RainbowDelimiterGreen = { fg = "foam"; };
        RainbowDelimiterViolet = { fg = "iris"; };
        RainbowDelimiterCyan = { fg = "pine"; };
        CursorLine = { bold = true; bg = "overlay"; };
      };
    };
  };

  plugins.transparent.enable = true;
}
