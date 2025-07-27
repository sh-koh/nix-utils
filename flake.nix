{
  description = "A flake containing various utilities for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
        ./lib
      ];

      flake.templates = inputs.nixpkgs.lib.pipe ./templates [
        builtins.readDir
        (builtins.mapAttrs (
          name: _:
          let
            upperFirstLetter = inputs.self.lib.upperFirstLetter;
          in
          {
            description = "A flake for a ${upperFirstLetter name} project";
            path = ./templates/${name};
          }
        ))
      ];

      perSystem =
        { pkgs, inputs', ... }:
        {
          formatter = inputs'.nixpkgs.legacyPackages.nixfmt-rfc-style;
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              settings = {
                formatters = with pkgs; [
                  nixfmt-rfc-style
                  yamlfmt
                ];
              };
            };
            deadnix = {
              enable = true;
              settings = {
                edit = true;
                quiet = true;
              };
            };
          };
        };
    };
}
