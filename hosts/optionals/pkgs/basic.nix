{pkgs, ...}:
{

    programs.zsh.enable = true;

    environment.systemPackages = [
        pkgs.vim
        pkgs.wget
    ];
}