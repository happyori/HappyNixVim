{
  plugins.none-ls = {
    enable = true;
    border = "rounded";
    sources = {
      formatting.nixpkgs_fmt.enable = true;
      formatting.prettierd.enable = true;
      code_actions.statix.enable = true;
      diagnostics.statix.enable = true;
    };
  };
}
