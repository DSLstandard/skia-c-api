{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        skia129 = pkgs.callPackage ./skia-129-modified.nix {};

        devDeps = [
          # Apparently without this, entering a nix shell breaks your VSCode terminal's bash's PS1.
          # See https://discourse.nixos.org/t/tmux-bash-prompt-breaks-inside-of-flakes/60925/4
          pkgs.bashInteractive

          pkgs.clang
          pkgs.pkg-config
          pkgs.cmake 
          pkgs.ninja
        ];

        libDeps = with pkgs; [
          # zlib is used by a lot of libraries apparently.
          # (Specifically package 'warp' needs `-lz`, 'warp' is needed by `stack hoogle --server`)
          zlib

          # skia # We actually want version=129-unstable-2024-09-18.
          skia129

          fontconfig # Skia fontmgr ports
          expat # Required by fontconfig
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = devDeps ++ libDeps;
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libDeps;
        };
      });
}

