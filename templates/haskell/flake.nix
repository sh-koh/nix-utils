{
  description = "A development environment for this haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell { packages = with pkgs; [ ghc ]; };
          packages.default = pkgs.stdenv.mkDerivation (
            finalAttrs:
            let
              pname = "haskell-template";
            in
            {
              inherit pname;
              version = "git";
              src = ./.;
              buildInputs = with pkgs; [ ghc ];
              nativeBuildInputs = with pkgs; [ ];
              buildPhase = ''
                mkdir -p $out/bin
                ${pkgs.ghc}/bin/ghc src/Main.hs -o ${pname}
                cp ${pname} $out/bin/${pname}
              '';
            }
          );
        };
    };
}
