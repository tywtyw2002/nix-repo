{ stdenv
, lib
, installShellFiles
, fetchurl
,
}:
stdenv.mkDerivation rec {
  name = "starship-c-${version}";
  version = "c20230425";

  src = fetchurl (
    if stdenv.system == "x86_64-darwin"
    then {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-apple-darwin.tar.gz";
      sha256 = "ddc259c9479c2f175791e902591f1a7fdf2a54b0278fa0cd396552db9e034214";
    }
    else if stdenv.system == "aarch64-linux"
    then {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "0c70b9778f085358dccde05add1edaa14c2175fc216c94e160702b0588d6e180";
    }
    else {
      url = "https://github.com/tywtyw2002/starship/releases/download/${version}/starship-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "c82bdeb94b50e847ca1659af611eb947c0a038652db06f4551a7523fe66dcb66";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
  };
}
