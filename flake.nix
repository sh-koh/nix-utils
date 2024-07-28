{ description = "A flake to manage various utilities for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
  let 
    inherit (inputs.self) outputs;
  in {
    lib = import ./lib { inherit inputs outputs; };
    templates = inputs.nixpkgs.lib.genAttrs [ "go" "haskell" "python" "zig" ] inputs.self.lib.mkTemplates;
  };
}
