{
  description = "yara + signature base";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    signature-base = {
    	url = "github:Neo23x0/signature-base";
	flake = false;
    };
  };

  outputs = inputs@{ flake-parts, signature-base, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: 
let 
  yara-sigs = import ./yara.nix {
    inherit (pkgs) stdenv lib;
    inherit signature-base; 
  };
in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        
        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = yara-sigs;
	devShells.default = pkgs.mkShell {
	  nativeBuildInputs = [
	    pkgs.yara
	    yara-sigs
	  ];
	};
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
