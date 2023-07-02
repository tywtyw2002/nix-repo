{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gost";
  version = "3.0.0-rc8";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    rev = "v${version}";
    sha256 = "sha256-plFmQ/npIasPFpy8rKuHZFUKPsokiRep8j4N6Ls8PLo=";
  };

  vendorSha256 = "sha256-KO+JmDoJDXgS4luXCzcawhMUr1+o0kRAjQA8+YiYVfM=";

  meta = with lib; {
    description = "A simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = licenses.mit;
  };
}