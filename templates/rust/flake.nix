{
  description = "A development environment for this Rust project";

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
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          packages = {
            default = self'.packages.accipere;
            accipere = pkgs.rustPlatform.buildRustPackage (_finalAttrs: {
              pname = "accipere";
              version = "0.1.0";
              src = ./.;
              buildInputs = with pkgs; [ ];
              nativeBuildInputs = with pkgs; [ ];
              strictDeps = true;
              useFetchCargoVendor = true;
              cargoLock.lockFile = ./Cargo.lock;
            });
          };
          devShells = {
            default = self'.devShells.devel;
            devel = pkgs.mkShell {
              formatter = pkgs.rustfmt;
              inputsFrom = [ self'.packages.accipere ];
              packages = with pkgs; [
                just # Make replacement

                # Rust
                bacon # Watcher
                cargo-info
                hyperfine
                lldb # Debugger
                mprocs
              ];
              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };
          };
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              settings = {
                formatters = with pkgs; [
                  nixfmt-rfc-style
                  rustfmt
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
            clippy.enable = true;
          };
        };
    };
}
