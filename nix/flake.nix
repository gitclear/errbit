{
  description = "errbit development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=ae1dc133ea5f1538d035af41e5ddbc2ebcb67b90";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ self, flake-parts, devshell, nixpkgs }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devshell.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, ... }: {
        devshells.default = {
          imports = ["${devshell}/extra/language/ruby.nix"];

          language.ruby.package = pkgs.ruby_2_7;

          # Add additional packages you'd like to be available in your devshell
          # PATH here
          devshell.packages = with pkgs; [
          ];
          commands = [
            # Example
            #{
            #  help = pkgs.cachix.meta.description;
            #  name = pkgs.cachix.pname;
            #  package = pkgs.cachix;
            #}
          ];
          # Add extra shell environment variables or aliases to be set in the
          # devshell
          bash.extra = ''
          '';
        };
      };
    };
}
