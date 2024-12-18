{
  pkgs,
  lib,
  config,
  ...
}:

let
  filePath = "${config.dotfiles.path}/programs/neofetch/electric.conf";
  configSrc =
    if !config.dotfiles.mutable then ./electric.conf else config.lib.file.mkOutOfStoreSymlink filePath;

  neofetchPath = lib.makeBinPath (
    with pkgs;
    [
      chafa
      imagemagick
    ]
  );

  neofetchSixelsSupport = pkgs.neofetch.overrideAttrs (old: {
    postInstall =
      lib.optionalString (!config.dotfiles.mutable) ''''
      + ''
        wrapProgram $out/bin/neofetch --prefix PATH : ${neofetchPath}
      '';
  });
in
{
  home.packages = [
    pkgs.hyfetch
    neofetchSixelsSupport
  ];
  xdg.configFile."hyfetch.json".source = ./hyfetch.json;
  xdg.configFile."neofetch/config.conf".source = configSrc;
}
