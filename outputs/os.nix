{
  extraSystemConfig,
  inputs,
  system,
  pkgs,
  ...
}:

with inputs;

let
  inherit (nixpkgs.lib) nixosSystem;
  inherit (pkgs) lib;
in
{
  mac-2015 = nixosSystem {
    inherit lib pkgs system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/machine/mac-2015
      ../system/configuration.nix
      extraSystemConfig
    ];
  };
}
