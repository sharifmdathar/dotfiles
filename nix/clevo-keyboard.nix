{ stdenv, fetchFromGitHub, linuxPackages, lib }:

stdenv.mkDerivation rec {
  pname = "clevo-keyboard";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "wessel-novacustom";
    repo = "clevo-keyboard";
    rev = "f0fdf06";
    sha256 = "sha256-Gy9DJvj4FZ3NyFAxYkmUCFR/D9iPAE/fRX1rGX0J+NY=";
  };

  nativeBuildInputs = [ linuxPackages.kernel.dev ];

  makeFlags = [ "KDIR=${linuxPackages.kernel.dev}/lib/modules/${linuxPackages.kernel.modDirVersion}/build" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/modules/${linuxPackages.kernel.modDirVersion}/extra
    find . -name "*.ko" -exec cp {} $out/lib/modules/${linuxPackages.kernel.modDirVersion}/extra/ \;
    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Kernel module for Clevo keyboard backlighting";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
