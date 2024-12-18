{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../wm/hyprland.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      # efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "mac-2015";
  };

  system.stateVersion = "24.11";
}
