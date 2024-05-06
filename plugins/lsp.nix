{ inputs, pkgs, system, ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
        package = inputs.nixd.packages.${system}.nixd;
      };
      lua-ls = { };
      dockerls = { };
      jsonls = { };
      nushell = { };
      rust-analyzer = { };
      tsserver = { };
      yamlls = { };
      gopls = { };
    };
  };

  extraPlugins = [
    pkgs.vimPlugins.neodev-nvim
  ];

  extraConfigLua = /* lua */ ''
    require("neodev").setup({
      library = {
        enable = true,
        runtime = true,
        types = true,
        plugins = { "nvim-treesitter", "telescope.nvim" },
      },
      setup_jsonls = true,
      lspconfig = true,
      pathStrict = true,
      override = function(root_dir, lib)
        if root_dir:find("${./.}/lua", 1, true) == 1 then
          lib.enabled = true
          lib.plugins = true
        end
      end
    })
  '';
}
