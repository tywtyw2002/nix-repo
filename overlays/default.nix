{ outputs
, inputs
,
}: {
  rust-overlay = inputs.rust-overlay.overlays.default;

  # Adds my custom packages
  additions = final: prev:
    import ../pkgs { pkgs = final; };
}
