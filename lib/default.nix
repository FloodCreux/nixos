{ lib }:
{
  mkVimBool = val: if val then 1 else 0;

  writeIf = cond: msg: if cond then msg else "";

  withPlugins = cond: plugins: if cond then plugins else [ ];

  withAttrSet = cond: attrSet: if cond then attrSet else { };

  /*
    Return first binary executable name of the given derivation
    Type:
      exe :: Derivation -> String
  */
  exe =
    drv:
    let
      regFiles = lib.mapAttrsToList (f: _: f) (
        lib.filterAttrs (_: t: t == "regular") (builtins.readDir "${drv}/bin")
      );
      mainProg = drv.meta.mainProgram or (lib.head regFiles);
    in
    "${drv}/bin/${mainProg}";

  removeNewLine = lib.replaceRStrings [ "\n" ] [ "" ];
}
