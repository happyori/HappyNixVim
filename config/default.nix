{ inputs, system, ... }:
{
  package = inputs.neovim-nightly-overlay.defaultPackage.${system};
  imports = [
    ./colorscheme.nix
    ./neovim-options.nix
  ];
}
