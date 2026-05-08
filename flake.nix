{
  description = "evil-hl-line — Change hl-line color based on evil state";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        epkgs = pkgs.emacsPackages;

        evil-hl-line = epkgs.melpaBuild {
          pname = "evil-hl-line";
          version = "0.1.0";
          src = self;
          packageRequires = [ epkgs.evil ];
        };

        # Emacs with all deps for interactive/CI use
        emacsWithDeps = pkgs.emacsWithPackages (e: [
          e.evil
          e.package-lint
        ]);
      in
      {
        packages.default = evil-hl-line;
        packages.evil-hl-line = evil-hl-line;

        # `nix develop` — shell for linting / byte-compiling
        devShells.default = pkgs.mkShell {
          name = "evil-hl-line-dev";
          buildInputs = [ emacsWithDeps ];
          shellHook = ''
            echo "evil-hl-line dev shell"
            echo "  emacs --batch -f batch-byte-compile evil-hl-line.el"
            echo "  emacs --batch -l package-lint -f package-lint-batch-and-exit evil-hl-line.el"
          '';
        };

        # `nix run` — byte-compile + package-lint in one shot
        apps.lint = {
          type = "app";
          program = toString (pkgs.writeShellScript "lint" ''
            set -e
            cd ${self}
            ${emacsWithDeps}/bin/emacs --batch \
              -f batch-byte-compile evil-hl-line.el
            ${emacsWithDeps}/bin/emacs --batch \
              -l package-lint \
              -f package-lint-batch-and-exit evil-hl-line.el
            echo "All checks passed."
          '');
        };
      });
}
