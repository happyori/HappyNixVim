{ inputs, system, ... }:
{
  package = inputs.neovim-nightly-overlay.defaultPackage.${system};
  imports = [
    ./colorscheme.nix
    ./neovim-options.nix
    ./keymaps.nix
  ];

  luaLoader.enable = true;
  clipboard = {
    register = "wl-copy";
    providers.wl-copy.enable = true;
  };
}
