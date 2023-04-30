{ pkgs, ... }: {
  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim
    pkgs.wget
  ];
}
