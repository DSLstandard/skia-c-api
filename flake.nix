{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hPkgs = pkgs.haskell.packages."ghc966";

        skia129 = pkgs.callPackage ./skia-129-modified.nix {};

        devDeps = [
          # Apparently without this, entering a nix shell breaks your VSCode terminal's bash's PS1.
          # See https://discourse.nixos.org/t/tmux-bash-prompt-breaks-inside-of-flakes/60925/4
          pkgs.bashInteractive

          pkgs.pkg-config

          hPkgs.cabal-install
          hPkgs.ghc
          hPkgs.fourmolu
          hPkgs.haskell-language-server
          hPkgs.hpack

          # For working with cbits/ and cbits_cmake/
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

          # For programs under demos/ using GLFW.
          #
          # The 'xorg.*' libs are learned from error messages generated when demo
          # programs failed to launch.
          glfw
          xorg.libX11
          xorg.libXi
          xorg.libXrandr
          xorg.libXxf86vm
          xorg.libXcursor
          xorg.libXinerama

          # For programs under demos/ using SDL2.
          SDL2
        ];

        pyDeps = [
            pkgs.python312
        ] ++ (with pkgs.python311Packages; [
            pycparser
            pytest
            pyyaml
        ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = devDeps ++ libDeps ++ pyDeps;
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libDeps;
        };
      });
}

