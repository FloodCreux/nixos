let
  scripts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      gsk = pkgs.callPackage ./gen-ssh-key.nix { };
    in
    # szp = pkgs.callPackage ./show-zombie-parents.nix { };
    {
      home.packages = [
        gsk # generate ssh key and add it to the system
        # szp # show zombie parents
      ] ++ (pkgs.sxm.scripts or [ ]);
    };
in
[ scripts ]
