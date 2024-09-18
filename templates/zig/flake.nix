{
  description = "A development environment for this zig project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell { packages = with pkgs; [ zig ]; };
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "zig-template";
            src = ./.;
            version = "git";
            buildInputs = with pkgs; [ ];
            nativeBuildInputs = with pkgs; [ zig.hook ];
          };
        };
    };
}
