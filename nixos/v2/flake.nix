{
    description = "Basic";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    inputs.home-manager.url = "github:nix-community/home-manager/release-25.05";
    inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

    outputs = { self, nixpkgs, home-manager }: {
        nixosConfigurations.T14 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            modules = [
                ./configuration.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.users.hasim = import /home/hasim/.dotfiles/nixos/v2/home.nix;
                    home-manager.backupFileExtension = "backup";
                }
            ];
        };
    };
}
