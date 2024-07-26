{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs @ { nixpkgs, home-manager, stylix, nixvim, nix-colors, ... }:
    let
      system = "x86_64-linux";
      user = "jacob";

#      pkgs = import nixpkgs {
#        inherit system;
#      	config.allowUnfree = true;
#      };

      lib = nixpkgs.lib;
    in 
    {
      nixosConfigurations = {
        laptop = lib.nixosSystem {
	        inherit system;
	        specialArgs = { inherit user inputs; };
	        modules = [ 
	          ./nixos
	          home-manager.nixosModules.home-manager {
	            home-manager.useGlobalPkgs = true;
	            home-manager.useUserPackages = true;
	            home-manager.extraSpecialArgs = { inherit user stylix nixvim nix-colors; };
	            home-manager.users.${user} = {
                imports = [ ./home ];
	            };
	          }
	        ];
	      };
      };
    };
}
