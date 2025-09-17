{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # comin = {
    #   url = "github:nlewo/comin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      nixpkgs,
      disko,
      # comin,
      ...
    }@inputs:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          # comin.nixosModules.comin
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
