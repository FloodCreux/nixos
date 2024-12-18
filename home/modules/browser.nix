{ lib, ... }:

with lib;

{
  meta.maintainers = [ hm.maintainers.mflood ];

  options.programs.browser = {
    settings.dpi = mkOption {
      type = types.str;
      default = "0";
    };
  };
}
