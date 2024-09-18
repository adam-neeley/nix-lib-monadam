{
  description = "monadam's Nix library";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (builtins)
        attrValues readDir pathExists concatLists concatStringsSep;
      inherit (pkgs.lib)
        strings collect isString mapAttrs filter id mapAttrsRecursive
        mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair
        removeSuffix;
    in {
      lib = rec {
        readDirRec = dir:
          mapAttrs (file: type:
            if (type == "directory") then readDirRec "${dir}/${file}" else type)
          (builtins.readDir dir);
      lib = pkgs.lib.extend (final: prev: rec {
        getFirstChar = str: strings.head (strings.stringToCharacters str);
        getDirs = dir:
          filter (el: el != null) (pkgs.lib.attrsets.mapAttrsToList (file: type:
            if (type == "directory" && getFirstChar file != ".") then
              file
            else
              null) (builtins.readDir dir));
        files = dir:
          collect isString
          (mapAttrsRecursive (path: type: concatStringsSep "/" path)
            (readDirRec dir));
        packageFiles = dir:
          map (file: ./. + "/${file}")
          (filter (file: (baseNameOf file) == "package.nix") (files dir));
      });
    };
}
