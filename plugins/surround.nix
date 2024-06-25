{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.nvim-surround
  ];

  extraConfigLua = ''
    require("nvim-surround").setup({})
  '';
}
