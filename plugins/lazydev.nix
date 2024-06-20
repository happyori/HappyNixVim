{ helpers, pkgs, ... }:
let
  lazyDevPkg = pkgs.vimUtils.buildVimPlugin {
    name = "lazydev";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "lazydev.nvim";
      rev = "6184ebbbc8045d70077659b7d30c705a588dc62f";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };
in
{
  extraPackages = [ lazyDevPkg ];
  extraConfigLua = helpers.mkRaw /* lua */ ''
  '';
}
