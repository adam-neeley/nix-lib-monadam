{
  description = "monadam's Nix library";

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { };
    in { lib = import ./lib { inherit (pkgs) lib; }; };
}
