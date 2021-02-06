{ sources ? import ./nix/sources.nix
, nixpkgs ? sources.nixpkgs
, system ? builtins.currentSystem
}:
let
  pkgs = import nixpkgs {
    crossSystem = (import "${nixpkgs}/lib").systems.examples.raspberryPi;
    inherit system;
    # config.perlPackageOverrides = old: {
    #   FileShareDir = old.perlPackages.callPackage
    #     ({ buildPerlPackage, lib, fetchurl, ClassInspector, FileShareDirInstall, ... }: buildPerlPackage {
    #       pname = "File-ShareDir";
    #       version = "1.116";
    #       src = fetchurl {
    #         url = "mirror://cpan/authors/id/R/RE/REHSACK/File-ShareDir-1.116.tar.gz";
    #         sha256 = "0a43rfb0a1fpxh4d2dayarkdxw4cx9a2krkk87zmcilcz7yhpnar";
    #       };
    #       propagatedBuildInputs = [ ClassInspector ];
    #       meta = {
    #         description = "Locate per-dist and per-module shared files";
    #         license = with lib.licenses; [ artistic1 gpl1Plus ];
    #       };
    #       buildInputs = [ FileShareDirInstall ];
    #     }) { };
    # };

    overlays = [
      (self: super: {
        # libdrm = super.libdrm.override { withValgrind = false; };
        # perl = super.perl.override {
        #   config.packageOverrides = 1;
        # };
        # perlPackages = super.perl530Packages.override (old: {
        # });
      })
    ];
  };
  nixos = pkgs.nixos ([
    ({ lib, ... }:
      {
        nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;
        # supportedSystems = [ "armv6l-linux" ];
      }
    )
    (import "${nixpkgs}/nixos/modules/installer/cd-dvd/sd-image-raspberrypi.nix")
  ]);
in
nixos.config.system.build.sdImage
