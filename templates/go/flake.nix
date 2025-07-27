{
  description = "A development environment for this Go project";

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
      ];
      perSystem =
        {
          pkgs,
          self',
          config,
          lib,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          devShells = {
            default = self'.devShells.devel;
            devel = pkgs.mkShell {
              inputsFrom = [ self'.packages.template ]; # FIXME
              packages = with pkgs; [
                just # Make replacement
                go
                air
                delve
              ];
              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };
          };
          packages = {
            default = self'.packages.template; # FIXME
            template = pkgs.buildGoModule {
              pname = "template";
              src = ./.;
              version = "git";
              vendorHash = lib.fakeHash;
              buildInputs = with pkgs; [ ];
              nativeBuildInputs = with pkgs; [ ];
            };
          };
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              settings = {
                formatters = with pkgs; [
                  nixfmt-rfc-style
                  gofmt
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
            gofmt.enable = true;
            golangci-lint.enable = true;
          };
        };
    };
}
