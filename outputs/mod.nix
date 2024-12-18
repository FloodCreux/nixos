{
  inputs,
  system,
  extraSpecialArgs,
  ...
}:
{
  home-manager = {
    inherit extraSpecialArgs;
    useGlobalPkgs = true;

    sharedModules = [
      inputs.neovim-flake.homeManagerModules.${system}.default
    ];

    users.mike = import ../home/wm/hyprland/home.nix;
  };
}
