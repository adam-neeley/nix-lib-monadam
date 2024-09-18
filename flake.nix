{
  description = "monadam's Nix library";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { };
      inherit (builtins)
        attrValues readDir pathExists concatLists concatStringsSep;
      inherit (pkgs.lib)
        collect isString mapAttrs filter id mapAttrsRecursive mapAttrsToList
        filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
    in {
      lib = rec {
        getDir = dir:
          mapAttrs (file: type:
            if (type == "directory") then getDir "${dir}/${file}" else type)
          (builtins.readDir dir);
        getDirs = dir: pkgs.lib.attrsets.mapAttrsToList (k: v: k) (getDir dir);
        files = dir:
          collect isString
          (mapAttrsRecursive (path: type: concatStringsSep "/" path)
            (getDir dir));
        packageFiles = dir:
          map (file: ./. + "/${file}")
          (filter (file: (baseNameOf file) == "package.nix") (files dir));
      };
    };
}
