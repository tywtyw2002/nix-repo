{
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsrq4tWVEnf9SF4wqEtTgnkfY1sKbJEFDlqfuyJR6kJ tyw@CosHiM-MAC"
    ];
    # passwordFile = config.sops.secrets.root-password.path;
    password = "nixos";
  };
}
