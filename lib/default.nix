{ lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists concatStringsSep;
  inherit (lib)
    collect isString mapAttrs filter id mapAttrsRecursive mapAttrsToList
    filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
in rec {
  getDir = dir:
    mapAttrs (file: type:
      if (type == "directory") then getDir "${dir}/${file}" else type)
    (builtins.readDir dir);
  getDirs = dir: lib.attrsets.mapAttrsToList (k: v: k) (getDir dir);
  files = dir:
    collect isString
    (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));
  packageFiles = dir:
    map (file: ./. + "/${file}")
    (filter (file: (baseNameOf file) == "package.nix") (files dir));
}
