{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "cyusb";
  version = "1.0.5";

  nativeBuildInputs = [ pkgs.gnumake ];
  buildInputs = [ pkgs.libusb1 ];

  src = ./.;

  patches = [ ./config.patch ];

  unpackPhase = ''
    cp -r $src source
    chmod -R u+w source
    cd source
  '';

  buildPhase = ''
    GLOBAL_CONFIG_PATH=$out/etc/cyusb.conf make lib cli
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin $out/etc
    cp lib/*.so* $out/lib
    find src/ -type f -executable -exec cp {} $out/bin \;
    cp configs/cyusb.conf $out/etc/cyusb.conf
  '';
}
