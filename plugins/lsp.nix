{ inputs, system, ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
        package = inputs.nixd.packages.${system}.nixd;
      };
      lua-ls = {};
      dockerls = {};
      jsonls = {};
      nushell = {};
      rust-analyzer = {};
      tsserver = {};
      yamlls = {};
      gopls = {};
    };
  };
}
