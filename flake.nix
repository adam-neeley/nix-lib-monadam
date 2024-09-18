{
  description = "monadam's Nix library";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        lib = import ./lib {
          inherit (pkgs) lib;
          inherit self;
        };
        devShells.default = pkgs.mkShell { packages = with pkgs; [ ]; };
      });
}
