{ inputs, outputs }: 
{
  mkTemplates = lang: {
    path = ../templates/${lang};
    description = "A template to setup a ${lang} project.";
  };

  mkHosts = modules: inputs.nixpkgs.lib.nixosSystem {
    inherit modules;
    specialArgs = { inherit inputs outputs; };
  };
}
