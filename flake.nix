{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      dependencies = with pkgs; [
        nodejs
      ];
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs;
          []
          ++ dependencies;
        shellHook = ''
          export PATH=$(pwd)/node_modules/.bin:node_modules/.bin:$PATH
        '';
      };
    });
}
