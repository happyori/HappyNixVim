{
  imports = [
    ./autocomplete.nix
    ./lsp.nix
    ./formatting.nix
    ./nonels.nix
    ./treesitter.nix
    ./mini.nix
    ./which-key.nix
    ./telescope.nix
    ./snippet-engine.nix
    ./indent.nix
    ./status-line.nix
    ./oil.nix
    ./pairs.nix
  ];

  plugins.nix.enable = true;
  plugins.nix-develop.enable = true;
}
