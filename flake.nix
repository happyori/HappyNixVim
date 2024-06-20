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
          in
          {
            checks = {
              default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
            };
            packages = {
              default = nvim;
            };
            devShells = rec {
              nixvim = pkgs.mkShellNoCC {
                name = "nixvim";
                nativeBuildInputs = [ self'.packages.default pkgs.fd pkgs.fzf ];
                shellHook = ''fd | fzf --preview "cat {}" | xargs nvim && exit'';
              };
              nixvide = pkgs.mkShellNoCC {
                name = "nixvide";
                nativeBuildInputs = [ self'.packages.default pkgs.fd pkgs.fzf pkgs.neovide ];
                shellHook = ''fd | fzf --preview "cat {}" | xargs neovide && exit'';
              };
              default = nixvide;
            };
          };
      };
}
