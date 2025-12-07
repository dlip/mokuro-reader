{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        dependencies = with pkgs; [
          nodejs
        ];
      in
      {
        packages.default = pkgs.buildNpmPackage {
          pname = "mokuro-reader";
          version = "1.0.0";

          # Directory containing package.json & next.config.js
          src = ./.;

          npmDepsHash = "sha256-aHXSjnR8kR1vIPCveAsIQdWRLdglAZrAqtXpK+BJRWA=";
          # after first build, replace with the real hash from error message

          buildPhase = ''
            npm run build
          '';

          installPhase = ''
            mkdir -p $out
            mv package.json $out
            mv node_modules $out
            mv build $out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ ] ++ dependencies;
          shellHook = ''
            export PATH=$(pwd)/node_modules/.bin:node_modules/.bin:$PATH
          '';
        };
      }
    );
}
