{
  description = "A flake containing various utilities for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      formatter = self.lib.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      lib = import ./lib { inherit self nixpkgs; };
      templates = {
        go = {
          path = ./templates/go;
          description = "A template to setup a Go project.";
        };
        haskell = {
          path = ./templates/haskell;
          description = "A template to setup a Haskell project.";
        };
        python = {
          path = ./templates/python;
          description = "A template to setup a Python project.";
        };
        zig = {
          path = ./templates/zig;
          description = "A template to setup a Zig project.";
        };
      };
    };
}
