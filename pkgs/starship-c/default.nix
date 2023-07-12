{
  stdenv,
  lib,
  installShellFiles,
  fetchurl,
}:
stdenv.mkDerivation rec {
  name = "starship-c-${version}";
  version = "c20230615";

  src = fetchurl (
    if stdenv.system == "x86_64-darwin"
    then {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-apple-darwin.tar.gz";
      sha256 = "3e01d0ad3572286d7667450c38808f60822e30bf3882c6d7e43e991bb00c0cea";
    }
    else if stdenv.system == "aarch64-linux"
    then {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "c0c3688bfc317102067441195cee0743d6851020818a716ea2e7cf240e508245";
    }
    else {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "2a53c9a0c8700f81670ccdac13b63c3f1be4615b59ae401a1d193defa6b907dd";
    }
  );

  sourceRoot = ".";
  unpackCmd = "tar zxf ${src}";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mv starship $out/bin/
  '';

  preFixup =
    if stdenv.isLinux
    then ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/starship
    ''
    else "";

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)
  '';

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    # maintainers = with maintainers; [ tywtyw2002 ];
    platforms = ["x86_64-linux" "x86_64-darwin" "aarch64-linux"];
  };
}
