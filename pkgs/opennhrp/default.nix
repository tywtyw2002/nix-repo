{
  lib,
  stdenv,
  fetchFromGitHub,
  # , pkg-config
  c-ares,
}:
stdenv.mkDerivation rec {
  pname = "opennhrp";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "vyos";
    repo = "vyos-opennhrp";
    rev = "16eee2c53686f52cd92c43265dad6d2b230af954";
    hash = "sha256-vPQlhWftKNvGT4vS2WfPs8/BAspg4w4yl5Tc4ugWer4=";
  };

  dontPatchELF = true;

  # nativeBuildInputs = [ pkg-config ];
  buildInputs = [c-ares];

  patches = [
    ./0008-fix-builds-with-gcc10.patch
  ];

  makeFlags = ["DESTDIR=${placeholder "out"}" "SBINDIR=/sbin"];

  meta = with lib; {
    description = "OpenNHRP is an NHRP implementation for Linux";
    homepage = "http://sourceforge.net/projects/opennhrp";
    # https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/opennhrp
    # https://github.com/vyos/vyos-opennhrp
    license = licenses.mit;
    platforms = ["x86_64-linux" "aarch64-linux"];
    # maintainers = with maintainers; [ tywtyw2002 ];
  };
}
