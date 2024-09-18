{
  description = "monadam's Nix library";

  outputs = { self, nixpkgs }:
    let
      allSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      pkgs = import nixpkgs { inherit system; };
      inherit (builtins)
        attrValues readDir pathExists concatLists concatStringsSep;
      inherit (pkgs.lib)
        strings collect isString mapAttrs filter id mapAttrsRecursive
        mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair
        removeSuffix;
    in rec {
      lib = pkgs.lib.extend (final: prev: rec {
        # flakes
        flakes = rec {
          forEachSystem = (systems: f:
            nixpkgs.lib.genAttrs systems (system:
              f {
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
              }));
          forAllSystems = (f: forEachSystem allSystems f);
        };

        # strings
        strings = {
          getFirstChar = str:
            prev.strings.head (prev.strings.stringToCharacters str);
          join = char: list: concatStringsSep char list;
        };

        # paths
        paths = rec {
          getDirs = dir:
            filter (el: el != null) (pkgs.lib.attrsets.mapAttrsToList
              (file: type:
                if (type == "directory" && strings.getFirstChar file
                  != ".") then
                  file
                else
                  null) (builtins.readDir dir));
          readDirRec = dir:
            mapAttrs (file: type:
              if (type == "directory") then
                readDirRec "${dir}/${file}"
              else
                type) (builtins.readDir dir);
          files = dir:
            collect isString
            (mapAttrsRecursive (path: type: concatStringsSep "/" path)
              (readDirRec dir));
          packageFiles = dir:
            map (file: ./. + "/${file}")
            (filter (file: (baseNameOf file) == "package.nix") (files dir));
        };
      });
    };
}
