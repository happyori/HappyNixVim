{
  plugins.none-ls = {
    enable = true;
    border = "rounded";
    sources = {
      formatting.nixpkgs_fmt.enable = true;
      code_actions.statix.enable = true;
      diagnostics.statix.enable = true;
      code_actions.ts_node_action.enable = true;
    };
  };
}
