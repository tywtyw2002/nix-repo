{ stdenv
, lib
, installShellFiles
, fetchurl
}:
stdenv.mkDerivation rec {
  name = "starship-c-${version}";
  version = "c20230304";

  src = fetchurl (
    if stdenv.system == "x86_64-darwin"
    then {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-apple-darwin.tar.gz";
      sha256 = "59a1236d7e44351a714cc26171646401c9f30b00b505e1afc279866a87dbda48";
    }
    else {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "0gfjkd5nk95m19rdv4nfamlgq7xw8fvhndn4ddw34slwsnprwr6l";
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
    if stdenv.isLinux then ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/starship
    '' else "";

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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
