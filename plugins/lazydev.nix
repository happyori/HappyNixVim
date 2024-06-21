{ pkgs, ... }:
let
  lazyDevPkg = pkgs.vimUtils.buildVimPlugin {
    name = "lazydev";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "lazydev.nvim";
      rev = "6184ebbbc8045d70077659b7d30c705a588dc62f";
      hash = "sha256-sMwSh79gTzwY/TPUB5nOi73o1p+y31LR7WEieHq5Q84=";
    };
  };
in
{
  extraPlugins = [ lazyDevPkg ];
  extraConfigLua = /* lua */ ''
    require("lazydev").setup({
      library = {},
      integrations = {
        lspconfig = true,
        cmp = true,
        coq = false,
      },
    })
  '';
}
