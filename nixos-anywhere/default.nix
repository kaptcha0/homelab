{
  inputs,
  terraform,
  self,
  ...
}:
let
  lib = inputs.nixpkgs.lib;
  sops-nix = inputs.sops-nix;
  disko = inputs.disko;
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations = {
    k3s-server-master = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs terraform;
        self = {
          inputs = self.inputs;
          nixosModules = self.nixosModules;
        };
      };

      modules = [
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
        ./hosts/k3s-server/master.nix
        ./common.nix
      ];
    };

    k3s-server = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs terraform;
        self = {
          inputs = self.inputs;
          nixosModules = self.nixosModules;
        };
      };

      modules = [
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
        ./hosts/k3s-server/normal.nix
        ./common.nix
      ];
    };

    k3s-agent = lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs terraform;
        self = {
          inputs = self.inputs;
          nixosModules = self.nixosModules;
        };
      };

      modules = [
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
        ./hosts/k3s-agent/configuration.nix
        ./common.nix
      ];
    };
  };
}
