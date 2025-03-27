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
            dive
          ];
        };
      });

      packages = forEachSupportedSystem ({ pkgs }: let
        name = "checkout-angular";
        version = "0.1.0";

        app = pkgs.buildNpmPackage {
          pname = name;
          version = version;
          src = ./.;
          nodejs = pkgs.nodejs;
          npmDepsHash = "sha256-ws06egUImLSztkET2J2s8PInE9VoVbVCiNS7354sAAI=";

          installPhase = ''
            runHook preInstall

            # Create the output directory
            mkdir -p $out/{bin,lib}

            # Copy the runtime files to output lib
            cp -R ./dist $out/lib
            cp -R ./node_modules $out/lib
            cp ./package.json $out/lib

            # Create the output binary
            exe="$out/bin/${name}"
            touch $exe
            chmod +x $exe
            echo "
              #!/usr/bin/env bash
              pushd $out/lib/node_modules/${name}
              ${pkgs.nodejs}/bin/npm run start
              popd;" > $exe

            runHook postInstall
          '';
        };
        docker = pkgs.dockerTools.buildLayeredImage {
          name = "checkout-angular";
          config.Cmd = [
            "${app}/bin/${name}"
          ];
          maxLayers = 120;
        };
      in {
        inherit app docker;
      });
    };
}
