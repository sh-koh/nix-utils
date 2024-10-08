{
  description = "A development environment for this python project";

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
          devShells.default = pkgs.mkShell { buildInputs = with pkgs; [ python312 ]; };
          packages.default = pkgs.python312.pkgs.buildPythonApplication {
            name = "python-template";
            version = "git";
            src = ./.;
            buildInputs = with pkgs; [ ];
            nativeBuildInputs = with pkgs; [ ];
          };
        };
    };
}
