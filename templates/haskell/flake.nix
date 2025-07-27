{
  description = "A development environment for this Haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    haskell-flake.url = "github:srid/haskell-flake";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.haskell-flake.flakeModule ];
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, self', ... }:
        {
          /*
            FIXME:
              You need to replace "template" with the project name
              here and in "template.cabal" and src/
          */
          packages.default = self'.packages.template; # FIX
          haskellProjects.template = {
            basePackages = pkgs.haskellPackages;
            packages = {
              # Deps version override
              # aeson.source = "1.5.0.0"; # for hackage
              # aeson.source = inputs.aeson; # to use a flake input
            };
            settings = {
              # Deps settings
              # aeson = {
              #   buildFromSdist = false;
              #   check = false;
              #   stan = false;
              #   haddock = false;
              #   jailbreak = true;
              #   cabalFlags.with-generics = false;
              #   broken = false;
              # };
            };
            otherOverlays = [ (_final: _prev: { }) ];
            devShell = {
              enable = true;
              hlsCheck.enable = true;
              tools = _hp: {
                #cabal = hp.cabal;
                just = pkgs.just;
              };
            };
          };
        };
    };
}
