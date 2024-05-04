{
  imports = [
    ./autocomplete.nix
    ./lsp.nix
    ./nonels.nix
    ./treesitter.nix
    ./mini.nix
    ./which-key.nix
    ./telescope.nix
  ];

  plugins.nix.enable = true;
  plugins.nix-develop.enable = true;
}
