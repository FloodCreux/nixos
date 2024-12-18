{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nix-schema = {
      url = "github:DeterminateSystems/nix-src/flake-schemas";
      inputs.flake-schemas.follows = "flake-schemas";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:FloodCreux/neovim-ide";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-schemas.follows = "flake-schemas";
    };

    # Hyprland
    hypr-binds-flake = {
      url = "github:hyprland-community/hypr-binds";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Search
    nix-search = {
      url = "github:diamondburned/nix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      overlays = import ./lib/overlays.nix { inherit inputs system; };

      pkgs = import inputs.nixpkgs {
        inherit overlays system;
        config.allowUnfree = true;
      };

      homeConfigurations = pkgs.mkHomeConfigurations { };
      nixosConfigurations = pkgs.mkNixosConfigurations { };

      neovim = homeConfigurations.hprland-hdmi.config.programs.neovim-ide.finalPackage;
    in
    {
      inherit homeConfigurations nixosConfigurations;

      out = { inherit pkgs overlays; };

      schemas =
        inputs.flake-schemas.schemas
        // import ./lib/schemas.nix { inherit (inputs) flake-schemas; };

      apps.${system}."nix" = {
        type = "app";
        program = "${pkgs.nix-schema}/bin/schema";
      };

      packages.${system} = {
        inherit neovim;
      };
    };
}
