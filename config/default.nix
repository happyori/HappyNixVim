{ inputs, system, ... }:
{
  package = inputs.neovim-nightly-overlay.packages.${system}.default;
  imports = [
    ./colorscheme.nix
    ./neovim-options.nix
    ./keymaps.nix
    ../plugins
  ];

  luaLoader.enable = true;
  clipboard.providers.wl-copy.enable = true;
}
