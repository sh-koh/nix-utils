{
  inputs,
  config,
  withSystem,
  ...
}:
{
  flake.lib = {
    mkNixos = sys: extraModules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = withSystem sys ({ inputs', self', ... }:
          { inherit self' inputs' inputs; });
        modules = [
          inputs.nixpkgs.nixosModules.readOnlyPkgs
          { nixpkgs.pkgs = withSystem sys ({ pkgs, ... }: pkgs); }
        ] ++ extraModules;
    };
    mkHome = sys: modules:
      withSystem sys ({ pkgs, self', inputs', ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs modules;
          extraSpecialArgs = {inherit self' inputs' inputs;};
        });
  };
}
