# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

let
  customFonts = with (pkgs.nerd-fonts); [
    jetbrains-mono
    iosevka
  ];
in
{
  # CVE: https://discourse.nixos.org/t/newly-announced-vulnerabilities-in-cups/52771
  systemd.services.cups-browsed.enable = false;

  networking = {
    extraHosts = pkgs.sxm.hosts.extra or "";

    # Enables wireless support and openvpn via network manager.
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    firejail
    nix-schema
    vim
    tmux
    docker
    docker-compose
    wget
    iptables
    inetutils
    nmap
    git
    bash
    kitty
    yazi
    gh
    udisks2
    gnumake
    bun
    go
    xclip
    wl-clipboard
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 80 443 22 6969 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enable Docker support
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        bip = "169.254.0.1/16";
      };
    };
  };

  users.extraGroups.vboxusers.members = [ "mike" ];

  security.rtkit.enable = true;

  services = {
    # Network scanners
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    logind = {
      lidSwitchExternalPower = "ignore";
      extraConfig = "HandlePowerKey=suspend";
      lidSwitch = "ignore";
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      allowSFTP = true;
    };

    # SSH daemon.
    sshd.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
    };

    udev.packages = [ pkgs.udiskie pkgs.udisks2 ];
  };

  # Making fonts accessible to applications.
  fonts.packages =
    with pkgs;
    [
      font-awesome
    ]
    ++ customFonts;

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mike = {
    isNormalUser = true;
    # wheel for 'sudo', uucp for bazecor to access ttyAMC0 (keyboard firmware updates)
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
      "uucp"
    ];
    shell = pkgs.fish;
  };

  security = {
    # Yubikey login & sudo
    pam.yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
    };

    # Sudo custom prompt message
    # sudo.configFile = ''
    #   Defaults lecture=always
    #   Defaults lecture_file=${misc/groot.txt}
    # '';
  };

  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Flakes settings
    package = pkgs.nixVersions.git;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [
        "root"
        "mike"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
