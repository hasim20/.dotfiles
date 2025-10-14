{ pkgs, ... }:

{
    home.username = "hasim";
    home.homeDirectory = "/home/hasim";
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    programs.zsh.enable = true;
    programs.git = {
        enable = true;
        userEmail = "muhasimm.mh@gmail.com";
        userName = "hasim";
        aliases = {
            ci = "commit";
            co = "checkout";
            s = "status";
        };
    };

    home.packages = with pkgs; [
        fastfetch
        btop
    ];

    # FIX: error: path '/home/hasim/.dotfiles/nixos/v2/.dotfiles/yazi' does not exist
    home.file.".config/hypr".source = ../hypr;
    home.file.".config/kitty".source = ../kitty;
    home.file.".config/nvim".source = ../nvim;
    home.file.".config/tmux".source = ../tmux;
    home.file.".config/yazi".source = ../yazi;
    home.file.".zshrc".source = ../.zshrc;
}
