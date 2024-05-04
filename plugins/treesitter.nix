{
  plugins.treesitter = {
    enable = true;
    indent = true;
    folding = true;
    nixGrammars = true;
    nixvimInjections = true;
    incrementalSelection = {
      enable = true;
      keymaps = {
        initSelection = "<C-space>";
        nodeIncremental = "<C-space>";
        scopeIncremental = "";
        nodeDecremental = "<bs>";
      };
    };
  };
  plugins.treesitter-context.enable = true;
  plugins.treesitter-context.settings = {
    max_lines = 3;
    mode = "cursor";
  };
  plugins.treesitter-textobjects.enable = true;
  plugins.ts-autotag.enable = true;
  plugins.ts-context-commentstring.enable = true;
  plugins.rainbow-delimiters.enable = true;

  filetype = {
    extension = { rasi = "rasi"; rofi = "rofi"; wofi = "wofi"; };
    filename = {
      ".env" = "dotenv";
      "vifmrc" = "vim";
    };
    pattern = {
      ".*/waybar/config" = "jsonc";
      ".*/mako/config" = "dosini";
      ".*/kitty/.+%.conf" = "bash";
      ".*/hypr/.+%.conf" = "hyprlang";
      "%.env%.[%w_.-]+" = "dotenv";
    };
  };
}
