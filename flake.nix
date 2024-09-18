{
  description = "monadam's Nix library";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.stdenv.mkDerivation { };
        devShells.default = pkgs.mkShell { packages = with pkgs; [ ]; };
      });
}
