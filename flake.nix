{
  description = "A flake for ragons st fork";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem(system: 
  let pkgs = nixpkgs.legacyPackages.${system}; in
  rec {

    packages = flake-utils.lib.flattenTree {
      st = pkgs.st.overrideAttrs ( oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        src = ./.;
      });
    };
    overlay = flake-utils.lib.flattenTree final: prev: rec {
      st-ragon = packages.${prev.system}.st;
    };
    defaultPackage = packages.st;
    apps.st = flake-utils.lib.mkApp { drv = packages.st; };
    defaultApp = apps.st;
  });
}
