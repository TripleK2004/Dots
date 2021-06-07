{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./pkgs.nix
    ./gtk.nix
    ./mako.nix
    ./alacritty.nix
    ];
  
  programs.home-manager.enable = true;
  home.username = "triplek";
  home.homeDirectory = "/home/triplek";

  nixpkgs.config = {
    allowUnfree = true;
  };
  
  home.stateVersion = "21.03";
}
