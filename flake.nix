{
  description = "a naive 1brc solution in haskell";

  inputs =
    { nixpkgs.url       = "github:nixos/nixpkgs/master";
      flake-parts.url   = "github:hercules-ci/flake-parts";
      haskell-flake.url = "github:srid/haskell-flake";
      # see https://community.flake.parts/haskell-flake
    };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      { systems = nixpkgs.lib.systems.flakeExposed;
        imports = [ inputs.haskell-flake.flakeModule ];

        perSystem = { self', pkgs, config, ... }:
          { haskellProjects.default =
              {
                # devShell =
                #   { mkShellArgs.nativeBuildInputs = with pkgs;
                #       [
                #         llvmPackages_15.llvm
                #         # llvmPackages_15.libllvm
                #         # llvmPackages_15.bintools-unwrapped
                #         # llvmPackages_15.clang-unwrapped
                #         clang
                #       ];
                #   };
              };
            packages.default = self'.packages."1brc-hs";
          };
      };
}
