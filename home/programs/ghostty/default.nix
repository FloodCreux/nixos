{
  pkgs,
  config,
  ...
}:

let
  filePath = "${config.dotfiles.path}/programs/ghostty/config";
  configSrc =
    if !config.dotfiles.mutable then ./config else config.lib.file.mkOutOfStoreSymlink filePath;
in
{
  home.packages = [
    pkgs.ghostty
  ];
  xdg.configFile."ghostty/config".source = configSrc;
}
