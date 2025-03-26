{
  description = "A Nix-flake-based angular development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      overlays = [
        (final: prev: {
          nodejs = prev.nodejs_22;
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            nodePackages_latest."@angular/cli"
          ];
        };
      });

      packages = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.buildNpmPackage rec {
          pname = "checkout-angular";
          version = "0.1.0";
          src = ./.;
          nodejs = pkgs.nodejs;
          npmDepsHash = "sha256-ws06egUImLSztkET2J2s8PInE9VoVbVCiNS7354sAAI=";
          postInstall = ''
            mkdir -p $out/bin
            exe="$out/bin/${pname}"
            touch $exe
            chmod +x $exe
            echo "
              #!/usr/bin/env bash
              pushd $out/lib/node_modules/${pname}
              ${pkgs.nodejs}/bin/npm run start
              popd;" > $exe
          '';
        };
      });
    };
}
