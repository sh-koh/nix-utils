{ self, nixpkgs }:
{
  inherit (import ./helpers.nix { inherit self nixpkgs; }) forAllSystems;
}
