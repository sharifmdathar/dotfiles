{ pkgs }:

# Source: https://github.com/imputnet/helium-linux
let
  version = "0.7.7.1";
in
pkgs.appimageTools.wrapType2 {
  pname = "helium-browser";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-qEHUFzCwsCyFNLFCC62wo2x1lr/boAI/UDsaaNP1vrc=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      # GUI toolkit libraries
      gtk3
      glib
      pango
      cairo
      gdk-pixbuf

      # X11 libraries
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXrender
      xorg.libxcb
      xorg.libXcursor
      xorg.libXi
      xorg.libXScrnSaver

      # Graphics libraries
      libGL
      mesa
      libdrm
      libxshmfence

      # Accessibility
      atk
      at-spi2-atk

      # Input
      libxkbcommon

      # Security/crypto
      nss
      nspr

      # Printing
      cups

      # Audio
      alsa-lib

      # Fonts
      fontconfig
      freetype

      # Other
      dbus
      expat
    ];

  meta = with pkgs.lib; {
    description = "Internet without interruptions - A privacy-focused browser";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [ "sharifmdathar" ];
  };
}
