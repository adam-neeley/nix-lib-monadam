{
  description = "monadam's Nix library";

  inputs = { nixpkgs.url = "nixpkgs/nixos-24.05"; };

  outputs = { self, nixpkgs }: { lib = import ./lib (import nixpkgs { }); };
}
