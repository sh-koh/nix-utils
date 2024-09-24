{
  description = "A development environment for this C project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            hardeningDisable = [ "all" ]; # Depend on the project
            packages = with pkgs; [
              clang
              gcc
              gdb
              valgrind
            ];
          };
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "template";
            src = ./.;
            version = "git";
            buildInputs = with pkgs; [ ];
            nativeBuildInputs = with pkgs; [ ];
          };
        };
    };
}
