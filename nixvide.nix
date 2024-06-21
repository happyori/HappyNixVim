{ stdenv, makeWrapper, neovide, nixvim }:
stdenv.mkDerivation {
  name = "nixvide";
  buildInputs = [ neovide makeWrapper ];

  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    makeWrapper "${neovide}/bin/neovide" "$out/bin/nixvide" --add-flags "--neovim-bin ${nixvim}"
  '';

  meta.mainProgram = "nixvide";
}
