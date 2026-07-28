{
  description = "Nix package for Ruby LSP";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    packages.${system}.default = pkgs.rubyPackages.ruby-lsp;
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.rubyPackages.ruby-lsp pkgs.ruby];
    };
  };
}
