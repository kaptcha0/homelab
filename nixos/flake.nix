{
  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
  };
  outputs = { self, nixpkgs, colmena, ...}@inputs: {
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      k3s-server = { name, nodes, pkgs, ... }: {
        imports = [
          ./hosts/k3-server
        ];
      };

      k3s-agent = { name, nodes, pkgs, ...}: {
        imports = [
          ./hosts/k3s-server
        ];
      }
    };
  };
}
