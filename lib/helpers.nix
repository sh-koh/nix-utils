{ self, nixpkgs }:
{
  forAllSystems = nixpkgs.lib.genAttrs [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
