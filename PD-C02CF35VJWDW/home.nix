{ pkgs, ... }:

{
  home.username = "princedimond";
  home.homeDirectory = "/Users/princedimond";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    #htop
    #curl
    #coreutils
    #jq
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "ls -la --color";
    };
  };
}
