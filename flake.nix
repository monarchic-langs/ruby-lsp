{
  description = "Nix package for Ruby LSP";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    ruby-lsp = pkgs.rubyPackages.ruby-lsp;
  in {
    formatter.${system} = pkgs.alejandra;

    packages = {
      ${system}.default = ruby-lsp;
    };

    checks = {
      ${system} = {
        package = ruby-lsp;

        format = pkgs.runCommand "ruby-lsp-flake-format" {nativeBuildInputs = [pkgs.alejandra];} ''
          alejandra --check ${./flake.nix}
          touch $out
        '';

        smoke = pkgs.runCommand "ruby-lsp-smoke" {nativeBuildInputs = [ruby-lsp];} ''
          command -v ruby-lsp
          ruby-lsp --version
          touch $out
        '';
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [ruby-lsp pkgs.ruby];
    };
  };
}
