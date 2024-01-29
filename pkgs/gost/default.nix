{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "gost";
  version = "3.0.0-rc10";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    rev = "v${version}";
    sha256 = "sha256-o0lE6grS7beslw/O0AtmPxeWlA4z8XAaLlo41U6zAsg=";
  };

  vendorSha256 = "sha256-C4HPOPveU+pOd8gyZWSo9R5EAHh+RvrfqtlpiJoeW84=";

  meta = with lib; {
    description = "A simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = licenses.mit;
  };
}
