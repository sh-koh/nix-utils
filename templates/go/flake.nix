{
  description = "A development environment for this go project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, lib, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              go
              air
              delve
            ];
          };
          packages.default = pkgs.buildGoModule {
            name = "go-template";
            src = ./.;
            version = "git";
            vendorHash = lib.fakeHash;
            buildInputs = with pkgs; [ ];
            nativeBuildInputs = with pkgs; [ ];
          };
        };
    };
}
