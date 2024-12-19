{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nix-schema = {
      url = "github:DeterminateSystems/nix-src/flake-schemas";
      inputs.flake-schemas.follows = "flake-schemas";
    };

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurpkgs.url = "github:nix-community/NUR";

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

    # Fish shell
    fish-bobthefish-theme = {
      url = "github:gvolpe/theme-bobthefish";
      flake = false;
    };

    fish-keytool-completions = {
      url = "github:ckipp01/keytool-fish-completions";
      flake = false;
    };

    # Github Markdown ToC generator
    gh-md-toc = {
      url = "github:ekalinin/github-markdown-toc";
      flake = false;
    };

    # Fast nix search client
    nix-search = {
      url = "github:diamondburned/nix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix linter
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    statix = {
      url = "github:nerdypepper/statix";
      inputs.fenix.follows = "fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Miscelaneous
    cowsay = {
      url = "github:snowfallorg/cowsay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox style
    penguin-fox = {
      url = "github:p3nguin-kun/penguinFox";
      flake = false;
    };

    # Zig Latest
    zig.url = "github:mitchellh/zig-overlay";
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
