{
  description = "A flake containing various utilities for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
        "i686-linux"
        "powerpc64le-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "x86_64-freebsd"
        "x86_64-linux"
      ];

      imports = [
        ./lib
      ];

      flake.templates = inputs.nixpkgs.lib.pipe ./templates [
        builtins.readDir (builtins.mapAttrs (name: _: {
          description = "A flake for this ${name} project.";
          path = ./templates/${name};
        }))
      ];

      perSystem = { inputs', ... }:
      {
        formatter = inputs'.nixpkgs.legacyPackages.nixfmt-rfc-style;
      };
    };
}
