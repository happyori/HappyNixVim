{
  description = "Happy Ori's NixVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixd.url = "github:nix-community/nixd";
  };

  outputs =
    { nixvim
    , flake-parts
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [
          "x86_64-linux"
        ];

        perSystem =
          { pkgs
          , system
          , self'
          , ...
          }:
          let
            inherit (inputs.nixpkgs.lib) getExe;
            nixvimLib = nixvim.lib.${system};
            nixvim' = nixvim.legacyPackages.${system};
            nixvimModule = {
              inherit pkgs;
              module = import ./config;
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
              };
            };
            nvim = nixvim'.makeNixvimWithModule nixvimModule;
            nixvide = pkgs.callPackage ./nixvide.nix { nixvim = getExe self'.packages.nvim; };
          in
          {
            checks = {
              default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
            };
            packages = {
              default = nixvide;
              inherit nvim nixvide;
            };
          };
      };
}
