{ pkgs , rootPath ? ../. }: rec {
  # mkFakeDerivation
  mkFakeDerivation = attrs: outputs:
    let
      outputNames = builtins.attrNames outputs;
      common =
        attrs
        // outputsSet
        // {
          type = "derivation";
          outputs = outputNames;
          # TODO: this has name/value pairs
          all = outputsList;
        };
      outputToAttrListElement = outputName: {
        name = outputName;
        value =
          common
          // {
            inherit outputName;
            outPath = builtins.storePath (builtins.getAttr outputName outputs);
            # TODO: we lie here so that Nix won't build it
            drvPath = builtins.storePath (builtins.getAttr outputName outputs);
          };
      };
      outputsList = map outputToAttrListElement outputNames;
      outputsSet = builtins.listToAttrs outputsList;
    in
    outputsSet;

  importTomlPkg = { name, ... }:
    with builtins; let
      system = pkgs.system;
      pkg_conf = fromTOML (readFile "${rootPath}/pkgs/z_packages/${name}.toml" );
    in
    if (hasAttr system pkg_conf)
    then
      let
        conf = pkg_conf.${system};
      in
      (mkFakeDerivation
        {
          name = conf.name;
          pname = conf.pname;
          version = conf.version;
          system = conf.system;
        }
        {
          out = conf.path;
        }).out
    else null;
}
